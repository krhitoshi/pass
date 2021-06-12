# pass

[![Gem Version](https://badge.fury.io/rb/pass.svg)](https://badge.fury.io/rb/pass)
![Testing workflow](https://github.com/krhitoshi/pass/workflows/Testing%20workflow/badge.svg)

## Description

The 'pass' command generates random passwords.

## Installation

The first step is to install the gem

```
  gem install pass
```

## Usage

You can run Pass to generate one random password. A generated password has 12 characters with more than one upper case letter, lower case letter, and numeric character.

```
  pass
```

If you need more passwords, you can specify the number of passwords.

```
  pass 12
```

You can specify the password length by -c option.

```
  pass -c 30
```

## Options

```
  -c NUM                           specify password length
  -s                               include symbols
  -v, --version                    show version
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
