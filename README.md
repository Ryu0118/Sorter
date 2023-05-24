<div align="center">  
  
  # Sorter
  
  #### Swift CLI tool to reorder enum cases, imports, etc.
  
  ![Language:Swift](https://img.shields.io/static/v1?label=Language&message=Swift&color=green&style=flat-square)
  ![License:MIT](https://img.shields.io/static/v1?label=License&message=MIT&color=blue&style=flat-square)
  [![Latest Release](https://img.shields.io/github/v/release/Ryu0118/Sorter?style=flat-square)](https://github.com/Ryu0118/Sorter/releases/latest)
  [![Twitter](https://img.shields.io/twitter/follow/ryu_hu03?style=social)](https://twitter.com/ryu_hu03)
</div>


## Installation
#### Mint
```
Ryu0118/Sorter@0.1.1
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

## Future Features
- [ ] Sort by access modifiers
- [ ] Sort switch cases
- [ ] Sort dependencies in Package.swift
- [ ] Sort imports separately for standard and external libraries
- [ ] Build Tool Plugin
