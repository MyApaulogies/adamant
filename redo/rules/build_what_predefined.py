
from base_classes.build_rule_base import build_rule_base
import os.path
from os import environ
import sys


def get_predefined_targets() -> list:
    '''List of `redo` targets that can be run from anywhere in the repository.'''
    return [
        "all",
        # "path",
        # "recursive",
        "clean",
        "clean_all",
        "clear_cache",
        "templates",
        "publish",
        "targets",
        "prove",
        "analyze",
        "style",
        "pretty",
        "test_all",
        "coverage_all",
        "style_all",
    ]
    # with open('../predefined_targets.txt') as f:
    #     return f.read().split()


class build_what_predefined(build_rule_base):
    '''Lists all redo targets which will be available in any subdirectory
    of the project base folder. See `build_what`.
    '''

    # similar to redo what, no need to access database
    def build(self, redo_1, redo_2, redo_3):
        # directory = os.path.dirname(os.path.abspath(redo_1))
        # environ["BUILD_PATH"] = directory + os.pathsep + directory + os.sep + ".."
        # super(build_what_predefined, self).build(redo_1, redo_2, redo_3)
        self._build(redo_1, redo_2, redo_3)

    def _build(self, redo_1, redo_2, redo_3):
        redo_targets = sorted(get_predefined_targets())
        sys.stderr.write(
            "redo " + "\nredo ".join(sorted(redo_targets)) + "\n"
        )

