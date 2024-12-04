import json
import pathlib

import vars


def json_format(
        input: str | int | list | pathlib.Path
) -> str | int | list | pathlib.Path:
    if type(input) == list:
        return json.dumps(input)
    elif type(input) == int:
        return input
    return f"\"{input}\""


def ascii_art(text: str) -> any:
    import pyfiglet

    render = pyfiglet.Figlet(font='slant')
    return render.renderText(text)


# SOURCE: https://stackoverflow.com/questions/22058048/hashing-a-file-in-python
def get_checksum(path: pathlib.Path) -> str:
    import hashlib

    print("Getting the checksum of the provided file ...")
    BUFF_SIZE = 65536
    checksum = hashlib.sha256()

    with open(path, "rb") as f:
        while True:
            data = f.read(BUFF_SIZE)
            if not data:
                break
            checksum.update(data)

    return checksum.hexdigest()


def create_build_dir(path: pathlib.Path) -> None:
    try:
        path.mkdir()
    except FileExistsError:
        print(f"The path: {path} already exists.")

    return None


def copy_file(path_src: pathlib.Path, path_dst: pathlib.Path) -> None:
    import shutil
    import filecmp

    try:
        if not path_src.exists() or not path_src.is_file():
            print(f"Source path: {path_src} does not exist or is not a file.")

        if not path_dst.is_file():
            tmp = pathlib.Path(path_dst).joinpath(path_src.name)
            if not tmp.is_file() or (tmp.is_file()
                                     and not filecmp.cmp(tmp, path_src)):
                print(f"Please wait, the file is being copied to {path_dst}.")
                shutil.copy2(path_src, path_dst)
                print("The file was successfully copied.")
            else:
                print("The file already exists.")
    except Exception:
        print("Error: An error occured while copying the file.")
        exit(1)

    return None
