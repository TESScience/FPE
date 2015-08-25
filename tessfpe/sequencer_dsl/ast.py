def strip_block_comments(text):
    "Strips text of block comments"
    import re
    block_comment_re = re.compile(
        r'//.*?$|/\*.*?\*/|\'(?:\\.|[^\\\'])*\'|"(?:\\.|[^\\"])*"',
        re.DOTALL | re.MULTILINE
    )
    return re.sub(block_comment_re, '', text)

class Semantics:

    def __init__(self):
        self.parameters = {}
        self.sequences = {}

    def parameter(self, ast):
        self.parameters[ast["name"]] = ast["value"]

    def single_step(_, __):
        return {"steps": 1}

    def state_changes(_, ast):
        return dict(zip(ast[::2], ast[1::2]))

    def steps(_, ast):
        return {"steps": sum(i for x in ast for i in x.values())}

    def signal(_, ast):
        state_changes, steps = ast
        if state_changes == {}:
            return steps
        else:
            return ast

    def constant(_, ast):
        return int(ast)

    def predefined_symbol(self, ast):
        return self.parameters[ast]

    def value(_, ast):
        return ast["value"]

    def multiply(_, ast):
        a, _, b = ast
        return a * b

    def divide(_, ast):
        a, _, b = ast
        return a / b

    def subtract(_, ast):
        a, _, b = ast
        return a - b

    def add(_, ast):
        a, _, b = ast
        return a + b
