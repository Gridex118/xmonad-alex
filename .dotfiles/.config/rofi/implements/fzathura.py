#!/usr/bin/python

import os
import argparse
import subprocess


class FZathuraParser(argparse.ArgumentParser):
    def __init__(self):
        super().__init__(
            prog="FZathura",
            description="A simple frontend for Zathura"
        )
        self.add_argument('-r', "--resume", action="store_true")
        self.add_argument('-m', "--menu", action="store_true")
        self.add_argument('-n', "--no-save-recent", action="store_true")
        self.add_argument('-p', "--pdf")


def set_up_root_dir() -> str:
    HOME: str | None = os.getenv("HOME")
    if HOME is None:
        print("Failed to fetch envvars")
        exit()
    os.chdir(HOME + "/Documents")
    return HOME

def get_all_pdfs_in_documents() -> list[str]:
    all_pdfs: list[str] = []
    for path_name, _, files in os.walk("."):
        pdf_files: list[str] = [ child for child in files if child.endswith(".pdf") ]
        rel_path_name: str = path_name.replace("./", "")
        for pdf_file in pdf_files:
            all_pdfs.append(os.path.join(rel_path_name, pdf_file))
    return all_pdfs

def get_rofi_menu_selection(home_dir: str) -> str:
    rofi_dmenu_proc = subprocess.Popen(
        ["rofi", "-theme", f"{home_dir}/.config/rofi/themes/dmenu.rasi",
        "-i", "-dmenu"],
        stdin=subprocess.PIPE, stdout=subprocess.PIPE,
        text=True
    )
    all_pdfs: str = "\n".join(get_all_pdfs_in_documents())
    output, _ = rofi_dmenu_proc.communicate(input=all_pdfs)
    return output.replace('\n', '')

def zathura_open_pdf(pdf_file: str, save_to_recents: bool = True) -> None:
    if save_to_recents:
        with open("/tmp/zathura_recents.log", "w") as sink:
            sink.write(pdf_file)
    subprocess.run(f"zathura --fork '{pdf_file}'", shell=True)


HOME:str = set_up_root_dir()
args = FZathuraParser().parse_args()

pdf_file: str = args.pdf or ""
if args.resume and not pdf_file:
    try:
        with open("/tmp/zathura_recents.log", "r") as source:
            pdf_file = source.read()
    except FileNotFoundError:
        print("No recents log file found")
elif args.menu and not pdf_file:
    pdf_file = get_rofi_menu_selection(HOME)

if pdf_file:
    zathura_open_pdf(
        pdf_file, not args.no_save_recent
    )
else: print("Aborting; Nothing was Selected")
