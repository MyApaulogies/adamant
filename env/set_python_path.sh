# This shell script sets up the python path
# by recursively searching through a directory tree
# for __init__.py files. Any directory with an
# init file in it is considered a python
# package and is added to the path.

# Get the root of the git repository
ROOT_DIR=$1

# Function finds __init__.py files and forms a path.
create_python_path()
{
  for init in `git -C $ROOT_DIR ls-files | grep "__init__.py$"`
  do
    dirname "$ROOT_DIR/$init"
  done | tr '\n' ':'
}

export PYTHONPATH=`create_python_path`:$PYTHONPATH
