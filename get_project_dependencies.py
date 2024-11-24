import toml

with open('pyproject.toml', 'r') as input:
  pyproject = toml.load(input)

[print(f'{dep}\n') for dep in pyproject.get('project', {}).pop('dependencies', {})]
