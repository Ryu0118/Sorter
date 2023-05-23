# Sorter
Swift CLI tool to reorder enum cases, imports, etc.

## Installation
### Mint
```
Ryu0118/Sorter@0.0.2
```

## Usage
```
USAGE: sorter [--file <file>] [--project <project>] [--rule-path <rule-path>] [--rules <rules>]

OPTIONS:
  -f, --file <file>       Swift file path you want to sort
  -p, --project <project> Project Path you want to sort
  --rule-path <rule-path> Explicitly specify the path to the file in which the
                          rules to be enabled are listed
  --rules <rules>         Specify the rule. To specify multiple rules, write
                          rules separated by commas.
  -h, --help              Show help information.
```

### Rules
- import
- enum_case
