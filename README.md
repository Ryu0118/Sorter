# Sorter
Swift CLI tool to reorder enum cases, imports, etc.

## Installation
#### Mint
```
Ryu0118/Sorter@0.0.2
```

#### homebrew
```
$ brew install Ryu0118/sorter/sorter
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
### To Use sorter in a project
Create a file named `sorter` in the root directory of the project, <br>
and list the rules you want to enable there as follows
```
import
enum_case
```

## Rules
- import
- enum_case

## Examples

#### Specify a file
```
$ sorter -f test.swift
```

#### Specify a project
```
$ sorter -p ~/MyProject
```

#### Specify the rule
```
$ sorter -p ~/MyProject --rules import,enum_case
```

#### Explicitly specify the file path where custom rules are listed
```
$ sorter -p ~/MyProject --rule-path ~/MyProject/sorter
```
