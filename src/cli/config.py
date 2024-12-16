#!/usr/bin/python3

import pathlib


class Config:

    def __init__(self):
        from src.cli.vars import _out_path, _in_path, _repo, _tag, _command, _devices_list, _exportable_vars, _var_file_name

        self.out_path = pathlib.Path(_out_path)
        self.in_path = pathlib.Path(_in_path)
        self.repo = _repo
        self.tag = _tag
        self.command = _command
        self.devices_list = _devices_list
        self.volumes_dict = [f"{str(self.out_path.absolute())}:{self.in_path}"]
        self.var_file_path = pathlib.Path(_out_path).joinpath(_var_file_name)
        self.exportable_vars = _exportable_vars
