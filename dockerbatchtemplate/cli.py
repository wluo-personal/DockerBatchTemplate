import typer

app = typer.Typer()

@app.command()
def demo1(content: str = typer.Option("DEMO1", help="DEMO, Any String.")):
    print(content)

@app.command()
def demo2(content: str = typer.Option("DEMO2", help="DEMO, Any String.")):
    print(content)

if __name__ == "__main__":
    app()