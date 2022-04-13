To create a bencmark executable module name generally be `Main`
\begin{code}
module Main where

import Criterion
import Criterion.Main (defaultMain)
\end{code}

\begin{code}
import qualified TailAfterTail as Tat
\end{code}

\begin{code}
takeN members =
  let
    helper 0 []    = []
    helper n cases =
      let
        genStep (m:ms) (_:cs) =
          [ m : c | c <- concat cs ] : genStep ms cs
      in
        cases : helper (pred n) (take n $ genStep members cases)
  in
    helper (pred . length $ members) [ [[m]] | m <- members ]
\end{code}

\begin{code}
patterMatching members =
  let
    helper []    = []
    helper cases =
      let
        genStep (m:ms) (_:cs:[]) = [ [ m : c | c <- cs ] ]
        genStep (m:ms) (_:cs) =
          [ m : c | c <- concat cs ] : genStep ms cs
      in
        cases : helper (genStep members cases)
  in
    helper [ [[m]] | m <- members ]

\end{code}


\begin{code}
allCombinationsWith combiFunc ms =
  concat . take (length ms) . map concat . combiFunc $ ms
\end{code}

\begin{code}
small, medium, large :: [Int]
small = [1..5]
medium = [1..12]
large = [1..22]
\end{code}

\begin{code}
data TestData a =
  TestData
  { name :: String
  , combiFunction :: [a] -> [[a]]
  , sample :: [a]
  }

\end{code}

\begin{code}
benchAllCombo (TestData name combiFunction sample) =
  bench name $ nf combiFunction sample
\end{code}

\begin{code}
main :: IO ()
main = do
  defaultMain
    [ bgroup "Tail After Tail"
      [ benchAllCombo TestData { name = "Medium 1"
                               , combiFunction = Tat.allCombinations
                               , sample =  medium
                               }
      , benchAllCombo TestData { name = "Large 1"
                               , combiFunction = Tat.allCombinations
                               , sample = large
                               }
      , benchAllCombo TestData { name = "Medium 2"
                               , combiFunction = Tat.allCombinations
                               , sample =  medium
                               }
      , benchAllCombo TestData { name = "Large 2"
                               , combiFunction = Tat.allCombinations
                               , sample = large
                               }
      ]

      , bgroup "Take N"
      [ benchAllCombo TestData { name = "Medium 1"
                               , combiFunction =
                                   allCombinationsWith takeN
                               , sample = medium
                               }
      , benchAllCombo TestData { name = "Large 1"
                               , combiFunction =
                                   allCombinationsWith takeN
                               , sample = large
                               }
      , benchAllCombo TestData { name = "Medium 2"
                               , combiFunction =
                                   allCombinationsWith takeN
                               , sample = medium
                               }
      , benchAllCombo TestData { name = "Large 2"
                               , combiFunction =
                                   allCombinationsWith takeN
                               , sample = large
                               }
      ]
    , bgroup "PatternMatching"
      [ benchAllCombo TestData { name = "Medium 1"
                               , combiFunction =
                                   allCombinationsWith patterMatching
                               , sample = medium
                               }
      , benchAllCombo TestData { name = "Large 1"
                               , combiFunction =
                                   allCombinationsWith patterMatching
                               , sample = large
                               }
      , benchAllCombo TestData { name = "Medium 2"
                               , combiFunction =
                                   allCombinationsWith patterMatching
                               , sample = medium
                               }
      , benchAllCombo TestData { name = "Large 2"
                               , combiFunction =
                                   allCombinationsWith patterMatching
                               , sample = large
                               }
      ]
    ]
\end{code}
