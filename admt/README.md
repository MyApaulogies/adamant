


This is the folder where the `admt` CLI tool lives.

### Installation (local)

Use `pip -e .`. Dependencies and project configuration are managed by the `pyproject.toml`. To activate shell completion: run one of the following commands:
```bash
# bash
eval "$(_ADMT_COMPLETE=bash_source admt)""
```
```fish
# fish
_ADMT_COMPLETE=fish_source admt | source
```

### Add a subcommand

Write a function in `lib.py` and wrap it in `@admt_command()`.

To register it in `admt`, write a [Click](https://click.palletsprojects.com/) function in `cli.py` with the decorator `@admt.command()` (or `@create.command()` for a subcommand of `admt create`). It should lightly wrap and call the corresponding function in `lib.py`. Add parameters and options as necessary -- refer to other commands and [Click documentation](https://click.palletsprojects.com/en/8.1.x/#documentation) and [examples](https://click.palletsprojects.com/en/8.1.x/quickstart/#screencast-and-examples). (generally prefer a certain style of options?)

