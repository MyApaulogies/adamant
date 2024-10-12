from deco import admt_command



@admt_command()
def create_component(name: str):
    print("creating component (not really):", name)
