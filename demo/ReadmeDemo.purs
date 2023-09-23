{-
# purescript-typelevel-regex

Apply regular expressions to type level strings.

## Examples

Regexes int he following examples are simplified for readability.
In reality would be a bit more complex.
-}

module ReadmeDemo where

import Type.Regex as Regex

-- email :: String
-- email = Regex.guard @"[a-z]@[a-z]\\.(com|org)" @"joe@doe.com"

{-

## Supported regex features


|                    |     |
| ------------------ | --- |
| Character literals | `a` |
|                    |     |
|                    |     |

-}
