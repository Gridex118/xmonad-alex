#!/bin/python

import socket
from select import select
import sys
import os
import subprocess
import json
from dataclasses import dataclass
from typing import Final, Literal

Request = Literal["EventStream", "FocusedWindow", "Windows"]


def notify(msg: str, send_notification = False):
    try:
        print(msg)
    except IOError:
        if send_notification: subprocess.run(["notify-send", msg])


@dataclass
class NiriService:
    addr: Final[str]
    _buf_size: Final[int] = 4096
    _encoding: Final[str] = "utf-8"
    _timeout: Final[float] = 5.0

    def __post_init__(self):
        self._incomplete_msg: str | None = None

    @staticmethod
    def _get_new_client(addr: str) -> socket.socket:
        client = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        assert client is not None, "Error initializing socket"
        client.connect(addr)
        client.setblocking(False)
        return client

    def _send_request(self, client: socket.socket, request: Request):
        client.sendall(f'"{request}"\n'.encode(self._encoding))

    def _get_json(self, decoded_response: str) -> list[dict]:
        parsed_lines: list[dict] = [ ]
        lines = decoded_response.split('\n')
        last_line = lines.pop()
        for line in lines:
            if self._incomplete_msg is not None:
                line = self._incomplete_msg + line
                self._incomplete_msg = None
            parsed_lines.append(json.loads(line))
        if len(last_line) > 0:
            self._incomplete_msg = last_line
        return parsed_lines

    def _wait_receive_json(self, client: socket.socket) -> list[dict] | None:
        rready, _, _ = select([client], [], [], self._timeout)
        if rready:
            response = client.recv(self._buf_size).decode(self._encoding)
            if response is not None:
                return self._get_json(response)

class NiriHelperService(NiriService):
    
    def _get_requested_response(self, request: Request) -> dict | None:
        with NiriService._get_new_client(self.addr) as client:
            try:
                self._send_request(client, request)
            except socket.error:
                notify(f"Error sending request ({request}) to client")
                return None
            response = (self._wait_receive_json(client) or [None])[0] or { }
            return response["Ok"].get(request) if "Ok" in response else None

class NiriFocusedWindowService(NiriHelperService):

    @property
    def window_id(self) -> int | None:
        response = self._get_requested_response("FocusedWindow") or { }
        return (response or { }).get("id")

class NiriWorkspacesService(NiriHelperService):

    @property
    def non_empty_workspaces(self) -> dict[int, int]:
        response = self._get_requested_response("Windows") or { }
        workspaces = [ window["workspace_id"] for window in response ]
        workspace_counts = {
            workspace: workspaces.count(workspace)
            for workspace in workspaces
        }
        return workspace_counts

class NiriAloneMaximizeService(NiriService):

    def __post_init__(self):
        super().__post_init__()
        self._focused_service = NiriFocusedWindowService(self.addr)
        self._workspaces_service = NiriWorkspacesService(self.addr)
        self._blacklist: list[int] = [ ]

    def maximize_if_necessary(self, open_change_event: dict):
        window = open_change_event["WindowOpenedOrChanged"]["window"]
        window_id = window.get("id")
        is_focused = window_id == self._focused_service.window_id
        is_blacklisted = window_id in self._blacklist
        if not window["is_floating"] and not is_blacklisted and is_focused:
            self._blacklist.append(window_id)
            workspace = window.get("workspace_id")
            workspaces = self._workspaces_service.non_empty_workspaces
            if workspace in workspaces:
                siblings = workspaces[workspace] - 1
                if not siblings:
                    subprocess.run(["niri", "msg", "action", "set-column-width", "100%"])

    def remove_from_blacklist(self, closing_event: dict):
        window_id = closing_event["WindowClosed"].get("id")
        if window_id in self._blacklist:
            self._blacklist.pop(self._blacklist.index(window_id))

    @staticmethod
    def handle_event(event_name: str, events, handler):
        selectable_events = [
            event for event in events
            if event_name in event
        ]
        selected_event = (selectable_events or [None])[0]
        if selected_event is not None:
            handler(selected_event)

    def run(self):
        with NiriService._get_new_client(self.addr) as event_stream_client:
            try:
                self._send_request(event_stream_client, "EventStream")
            except socket.error:
                notify("Error sending request (EventStream) to client", send_notification=True)
                return
            while True:
                events = self._wait_receive_json(event_stream_client)
                if events is None: continue
                NiriAloneMaximizeService.handle_event("WindowOpenedOrChanged", events, self.maximize_if_necessary)
                NiriAloneMaximizeService.handle_event("WindowClosed", events, self.remove_from_blacklist)


if __name__ == "__main__":
    socket_addr = os.getenv("NIRI_SOCKET")
    if socket_addr is None or not os.path.exists(socket_addr):
        notify("Could not obtain a valid niri socket address to listen to", send_notification=True)
        sys.exit(-1)
    try:
        niri_alone_maximize_service = NiriAloneMaximizeService(socket_addr)
        niri_alone_maximize_service.run()
    except KeyboardInterrupt:
        notify("Received KeyboardInterrupt", send_notification=True)
