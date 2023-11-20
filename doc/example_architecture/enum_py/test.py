#!/usr/bin/env python3

# Build our dependencies using the build system.
# This is necessary because some of the depdencies we
# have are autogenerated.
from util import pydep

pydep.build_py_deps()

from test_enums import First_Enum, Second_Enum

# Main:
if __name__ == "__main__":
    print("create enums:")
    fe = First_Enum(1)
    print(str(fe))
    print(str(fe.to_tuple_string()))
    print(str(fe.to_string()))
    try:
        fe = First_Enum(-1)
        assert False, "should not get here."
    except ValueError:
        pass
    se = Second_Enum(10)
    print()
    print(str(se))
    print(str(se.to_tuple_string()))
    print(str(se.to_string()))
    try:
        se = Second_Enum(12)
        assert False, "should not get here."
    except ValueError:
        pass
    print("passed.")
    print()
