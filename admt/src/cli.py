import click
from lib import create_component


CONTEXT_SETTINGS = dict(help_option_names=['-h', '--help'])



# The root command. Use @admt.command() to add a subcommand
# or @admt.group() to create another subgroup of subcommands.

@click.group(context_settings=CONTEXT_SETTINGS)
@click.option('--info')
def admt(info):
    """A CLI tool for the Adamant framework."""
    pass


@admt.command()
@click.pass_context
def help(ctx: click.Context):
    """Show this message and exit."""
    print(admt.get_help(ctx))


@admt.group()
def create():
    """Generate boilerplate code and files"""
    pass


@create.command()
@click.option('--name', default="blank_component", prompt='name')
def component(name):
    """Create a blank component"""
    create_component(name)
