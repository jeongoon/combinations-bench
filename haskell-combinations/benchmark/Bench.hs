module Main where

import Criterion
import Criterion.Main (defaultMain)

import qualified TailAfterTail as Tat
import qualified LeadersAndFollowers as Laf
import qualified DynamicProgramming as Dyn
size5, size15, size30 :: [Int]
size5 = [1..5]
size15 = [1..15]
size30 = [1..30]

benchAllCombo members combiFunction =
  bench ( "Size: " <> (show . length $ members) ) $ whnf combiFunction members

mkAllCombinationsWith combiFunction ms =
  concat [ combiFunction ms n | n <- [1..length ms] ]

main :: IO ()
main = do
  defaultMain
    [ bgroup "Leaders and Followers benchmarks"
      [ benchAllCombo size5  $ mkAllCombinationsWith Laf.combinations
      , benchAllCombo size15 $ mkAllCombinationsWith Laf.combinations
      ]
    , bgroup "Tail After Tail benchmarks"
      [ benchAllCombo size5  Tat.allCombinations
      , benchAllCombo size15 Tat.allCombinations
      ]
    , bgroup "Dynamic Programming benchmarks"
      [ benchAllCombo size5  $ mkAllCombinationsWith Dyn.combinations
      , benchAllCombo size15 $ mkAllCombinationsWith Dyn.combinations
      ]
    ]
