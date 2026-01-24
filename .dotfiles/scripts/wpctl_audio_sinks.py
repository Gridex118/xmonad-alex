#!/usr/bin/env python

import subprocess
import re
import argparse
from dataclasses import dataclass

def remove_leading_decorations(string: str) -> str:
    return re.sub(r"[^A-z0-9 .:]+", '', string).lstrip()

@dataclass
class Sink:
    ID: int
    name: str

    def __str__(self):
        return f"{self.ID}:{self.name}"

class GetSinks:
    @property
    def __lines(self) -> list[str]:
        wpctl_proc = subprocess.Popen(
            ["wpctl", "status"],
            stdout=subprocess.PIPE,
            text=True
        )
        output, _ = wpctl_proc.communicate()
        return output.split('\n')

    @staticmethod
    def __get_audio_section(wpctl_out_lines: list[str]) -> list[str]:
        start = wpctl_out_lines.index("Audio")
        end = wpctl_out_lines.index("Video")
        return wpctl_out_lines[start:end]

    @staticmethod
    def __get_audio_sink_subsection(audio_section_lines: list[str]) -> list[str]:
        start = audio_section_lines.index("Sinks:") + 1
        end = audio_section_lines.index("Sources:") - 1
        return audio_section_lines[start:end]

    def get_sinks(self) -> list[Sink]:
        lines = self.__lines.copy();
        lines = GetSinks.__get_audio_section(lines)
        lines = [ remove_leading_decorations(line) for line in lines ]
        lines = GetSinks.__get_audio_sink_subsection(lines)
        sinks: list[Sink] = []
        for line in [ line.split() for line in lines ]:
            index = line[0][:-1]            # Remove the trailing dot (.)
            name  = " ".join(line[1:-2])    # Remove the trailing volume specification
            sinks.append(Sink(int(index), name))
        return sinks

class Parser(argparse.ArgumentParser):
    def __init__(self):
        super().__init__(
            prog="GetSinks",
            description="A 'wpctl' wrapper to obtain audio sinks"
        )
        self.add_argument('-n', "--name")

if __name__ == "__main__":
    args = Parser().parse_args()
    sinks = GetSinks().get_sinks()
    if args.name is None:
        for sink in sinks:
            print(sink)
    else:
        try:
            index = [ sink.name for sink in sinks ].index(args.name)
            print(sinks[index].ID)
        except ValueError:
            print(f"Sink '{args.name}' does not exist")
