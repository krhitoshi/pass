# pass

[![Gem Version](https://badge.fury.io/rb/pass.svg)](https://badge.fury.io/rb/pass)
![Testing workflow](https://github.com/krhitoshi/pass/workflows/Testing%20workflow/badge.svg)

## Description

The 'pass' command generates random passwords.

## Installation

All you have to do is to install the gem

```
$ gem install pass
```

## Usage

You can just run 'pass' to get one random password.
Every time you run it, you will get a different password.

Each password has 20 characters and does not include ambiguous characters ``l o I O 1 " ' ` |``.
As default, a password consists of upper case letters, lower case letters, and numbers.

```
$ pass
phxeaYZm7wUF8ACRjuSP

$ pass
Vm8ukJsPfeZXvCASUYTM
```

If you need more passwords, you can specify the number of passwords.

```
$ pass 3
jMtfmQhXbFSJ2TpVrBey
48UKdpNLf6sxatmq2JzP
5JYuhCbSHqZatVwA8B97
```

You can specify the password length with -l or --length option.

```
$ pass -l 30
7wkxqiWXSYpPLnNsAyTeuU59dgmJFC

$ pass --length 50
```

You can use -s or --symbols option to include symbols in passwords.

```
$ pass -s
uV=#v3,Z9Hd^$B?DKt%P

$ pass --symbols
```

You can specify certain characters you don't want to put in passwords with -e or --exclude option.

```
$ pass -e 'ABCD678'
$ pass --symbols --exclude '*[]{}/\'
```

## Options

```
-c [NUMBER]                      (deprecated) specify password length
-l, --length [NUMBER]            specify password length
-s, --symbols                    include symbols
-e, --exclude [CHARACTERS]       exclude characters
-v, --version                    show version
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
