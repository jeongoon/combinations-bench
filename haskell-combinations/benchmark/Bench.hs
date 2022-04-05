module Main where

import Criterion
import Criterion.Main (defaultMain)

import qualified TailAfterTail as Tat
import qualified LeadersAndFollwers as Laf
import qualified DynamicProgramming as Dyn

size5 = [1..5]
size10 = [1..10]
size30 = [1..30]

data BenchType a
  = AllCombinations
    { members :: [a]
    , nTimes  :: Int
    }

benchAllCombo benchType combiFunction =
  case benchType of
    AllCombinations members nTimes ->
      bench ( "Size member of " <> (show . length $ members)
      <> " x " <> (show nTimes) <> " times Test" ) $ whnf
      const [ combiFunction ms | ms <- replicate nTimes members ]

mkAllCombinationsWith combiFunction ms =
  concat [ combiFunction ms n | n <- [1..length ms] ]

main :: IO ()
main = do
  defaultMain
    [ bgroup "Leaders and Followers benchmarks"
      [ benchAllCombo (AllCombinations size5 5)
        (mkAllCombinationsWith Laf.combinations)
      , benchAllCombo (AllCombinations size30 1)
        (mkAllCombinationsWith Laf.combinations)
      ]
    , bgroup "Tail After Tail benchmarks"
      [ benchAllCombo (AllCombinations size5 5) Tat.allCombinations
      , benchAllCombo (AllCombinations size30 1) Tat.allCombinations
      ]
    , bgroup "Dynamic Programming benchmarks"
      [ benchAllCombo (AllCombinations size5 5) $
        mkAllCombinationsWith Dyn.combinations
      , benchAllCombo (AllCombinations size30 1) $
        mkAllCombinationsWith Dyn.combinations
      ]
    ]
