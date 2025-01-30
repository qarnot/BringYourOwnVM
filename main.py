#!/usr/bin/python3

import argparse
from src.cli.cli import main
from src.cli import vars

parser = argparse.ArgumentParser(prog=vars.program_command,
                                 description=vars.program_desc)

parser.add_argument('-v',
                    '--verbose',
                    help='enable the verbose mode',
                    action='store_true')

parser.add_argument('-f',
                    '--file',
                    help='provide a configuration file',
                    type=str)

if __name__ == "__main__":
    args: argparse.ArgumentParser = parser.parse_args()
    main(args)
