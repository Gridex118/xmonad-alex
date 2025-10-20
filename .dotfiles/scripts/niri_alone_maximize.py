#!/bin/python

import socket
import sys
import os
import subprocess
import json
from dataclasses import dataclass
from typing import Final

def notify(msg: str):
    try:
        print(msg)
    except IOError:
        subprocess.run(["notify-send", msg])

@dataclass
class NiriAloneMaximizeService:
    _addr: Final[str]
    _buf_size: Final[int] = 4096
    _encoding: Final[str] = "utf-8"

    @staticmethod
    def get_new_client(addr: str) -> socket.socket:
        client = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        assert client is not None, "Error connecting to niri"
        client.connect(addr)
        return client

    def get_requested_data(self, request: str, client: socket.socket | None = None):
        client_provided = client is not None
        if not client_provided:
            client = NiriAloneMaximizeService.get_new_client(self._addr)
        client.sendall(f'"{request}"\n'.encode(self._encoding))
        response = client.recv(self._buf_size).decode(self._encoding)
        if not client_provided: client.close()
        return response

    @property
    def focused_window_id(self) -> str | None:
        try:
            response = self.get_requested_data("FocusedWindow")
            response_parsed = json.loads(response)
        except OSError | json.JSONDecodeError as e:
            notify(f"focused_window_ind gave: {e}")
            return None
        if "Ok" in response_parsed:
            focused_window = response_parsed["Ok"]["FocusedWindow"]
            if focused_window is not None: return focused_window["id"]

    @property
    def non_empty_workspaces(self) -> dict[str, int] | None:
        try:
            response = self.get_requested_data("Windows")
            response_parsed = json.loads(response)
        except OSError | json.JSONDecodeError as e:
            notify(f"non_empty_workspaces gave: {e}")
            return None
        if "Ok" in response_parsed:
            workspaces = [
                window["workspace_id"]
                for window in response_parsed["Ok"]["Windows"]
            ]
            workspace_counts = {
                workspace: workspaces.count(workspace)
                for workspace in workspaces
            }
            return workspace_counts

    def handle_opening(self, event_strings: list[str]):
        for string in event_strings:
            parsed = json.loads(string)
            window = parsed["WindowOpenedOrChanged"]["window"]
            if not window["is_floating"]:
                workspace = window["workspace_id"]
                workspaces = self.non_empty_workspaces
                if workspaces is not None and workspace in workspaces:
                    siblings = workspaces[workspace] - 1
                    if not siblings and window["id"] == self.focused_window_id:
                        subprocess.run(["niri", "msg", "action", "set-column-width", "100%"])

    def run(self):
        event_stream_client = NiriAloneMaximizeService.get_new_client(self._addr)
        try:
            while True:
                response = self.get_requested_data("EventStream", event_stream_client)
                if not len(response): continue
                open_change_event_strings = [
                    string for string in response.split('\n')
                    if len(string) > 0 and "WindowOpenedOrChanged" in string
                ]
                try:
                    self.handle_opening(open_change_event_strings)
                except json.JSONDecodeError as e:
                    notify(f"run gave: {e}")
                    continue
        except KeyboardInterrupt:
            event_stream_client.close()
            sys.exit(0)


if __name__ == "__main__":
    try:
        socket_addr = os.getenv("NIRI_SOCKET")
        if socket_addr is None or not os.path.exists(socket_addr):
            notify("Could not obtain a valid niri socket address to listen to")
            sys.exit(-1)
        service = NiriAloneMaximizeService(socket_addr)
        service.run()
    except IOError: pass
