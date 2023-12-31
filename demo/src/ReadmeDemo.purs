{-
# purescript-typelevel-regex

Regular expressions for type level strings.


## Installation

```
spago install typelevel-regex
```

## Features

- Subset of JS regexes
- Friendly error messages
- No runtime overhead

## Example

The `guard` function is similar to `test` which exists for many regex implementations.
The difference is that instead of returning a boolean,
it reflects the type level input string if the regex matches.

-}

module ReadmeDemo where

import Type.Regex as Regex

type RegexURL =
  "^(ftp|https?)://[a-z][a-z0-9]*\\.(app|com|org)(/[a-z]+)*(\\?([a-z]+))?$"

-- The following only compiles if the type level string matches the above regex:

sample1 :: String
sample1 = Regex.guard @RegexURL @"http://hello.com/path/to?query"

sample2 :: String
sample2 = Regex.guard @RegexURL @"http://hello.com/path/to"

sample3 :: String
sample3 = Regex.guard @RegexURL @"https://hello99.org/path/to"

sample4 :: String
sample4 = Regex.guard @RegexURL @"ftp://hello.org/path/to/home"

{-

## Supported regex features

| Feature                     | Example                  |
| --------------------------- | ------------------------ |
| Character literals          | `a`, `b`, `c`, ...       |
| Wildcards                   | `.`                      |
| Match Start/End             | `^`, `$`                 |
| Groups                      | `(abc)`, `(hello)`, ...  |
| Alternatives                | `a\|b\|c`, `(foo\|bar)`  |
| Match Many                  | `(foo)*`                 |
| Match Some                  | `(foo)+`                 |
| Match Maybe                 | `(foo)?`                 |
| Character Classes           | `[abc]`, `[a-z0-9_]`     |
| Negative Character Classes  | `[^abc]`, `[^a-z0-9_]`   |
| Escapes                     | `\\?`, `\\[`             |


-}