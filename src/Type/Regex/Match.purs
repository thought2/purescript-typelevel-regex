module Type.Regex.Match where

import Prim.Boolean (False, True)
import Prim.Symbol as Sym
import Prim.TypeError (class Fail, Above, Beside, Text)
import Type.Char (UnsafeMkChar)
import Type.Regex.RegexRep (type (~), Regex)
import Type.Regex.RegexRep as R

class ScanRegex (regex :: Regex) (str :: Symbol)

instance
  ( RegexAttemptGo regex str rest matches
  , ScanRegexResult rest matches
  ) =>
  ScanRegex regex str

--- ScanRegexResult

class ScanRegexResult (rest :: Symbol) (matches :: Boolean)

instance ScanRegexResult "" True

else instance
  ( Fail
      ( Above
          (Text "Regex failed to match.")
          (Beside (Text "Unmateched rest is: ") (Text rest))
      )
  ) =>
  ScanRegexResult rest matches

--- RegexAttemptGo

class
  RegexAttemptGo (regex :: Regex) (str :: Symbol) (rest :: Symbol) (matches :: Boolean)
  | regex str -> rest matches

instance RegexAttemptGo R.Nil rest rest True

else instance RegexAttemptGo (R.Alt regex R.Nil) "" "" True

else instance RegexAttemptGo (R.Alt R.Nil regex) "" "" True

else instance RegexAttemptGo (R.Many regex) "" "" True

else instance RegexAttemptGo regex "" "" False

else instance
  ( Sym.Cons head tail str
  , RegexAttemptMatch regex head tail rest matches
  ) =>
  RegexAttemptGo regex str rest matches

--- RegexAttemptMatch

class
  RegexAttemptMatch (regex :: Regex) (head :: Symbol) (tail :: Symbol) (rest :: Symbol) (matches :: Boolean)
  | regex head tail -> rest matches

instance
  RegexAttemptMatch (R.Lit (UnsafeMkChar head) True) head tail tail True

else instance
  ( Sym.Cons head tail str
  ) =>
  RegexAttemptMatch R.Nil head tail str True

else instance
  ( Sym.Cons head tail str
  , RegexAttemptGo regex1 str rest matches
  , RegexAttemptMatchCatResult regex2 matches rest rest' matches'
  ) =>
  RegexAttemptMatch (R.Cat regex1 regex2) head tail rest' matches'

else instance
  ( Sym.Cons head tail str
  , RegexAttemptGo regex1 str restLeft matches

  , RegexAttemptMatchAltResult regex2 matches restLeft str rest' matches'
  ) =>
  RegexAttemptMatch (R.Alt regex1 regex2) head tail rest' matches'

else instance
  ( Sym.Cons head tail sym
  , RegexAttemptGo regex sym restIn matches
  , RegexManyResult matches regex sym restIn rest' matches'
  ) =>
  RegexAttemptMatch (R.Many regex) head tail rest' matches'

else instance
  RegexAttemptMatch regex head tail tail False

--- RegexAttemptMatchCatResult

class
  RegexAttemptMatchCatResult (regex :: Regex) (matched :: Boolean) (restIn :: Symbol) (restOut :: Symbol) (matches :: Boolean)
  | regex matched restIn -> restOut matches

instance
  ( RegexAttemptGo regex restIn restOut matches
  ) =>
  RegexAttemptMatchCatResult regex True restIn restOut matches

else instance
  RegexAttemptMatchCatResult regex False rest rest False

--- RegexAttemptMatchAltResult

class
  RegexAttemptMatchAltResult (regex :: Regex) (matched :: Boolean) (restInLeft :: Symbol) (restInRight :: Symbol) (restOut :: Symbol) (matches :: Boolean)
  | regex matched restInLeft restInRight -> restOut matches

instance
  RegexAttemptMatchAltResult regex True rest restInRight rest True

else instance
  ( RegexAttemptGo regex restIn restOut matches
  ) =>
  RegexAttemptMatchAltResult regex False restInLeft restIn restOut matches

--- RegexManyResult

class
  RegexManyResult
    (matched :: Boolean)
    (regex :: Regex)
    (backtrace :: Symbol)
    (restIn :: Symbol)
    (restOut :: Symbol)
    (matches :: Boolean)
  | matched regex backtrace restIn -> restOut matches

-- instance
--   RegexManyResult True regex backtrace "" "" True

instance
  ( RegexAttemptGo (R.Many regex) restIn restOut matches
  ) =>
  RegexManyResult True regex backtrace restIn restOut matches

else instance
  RegexManyResult False regex backtrace restIn backtrace True