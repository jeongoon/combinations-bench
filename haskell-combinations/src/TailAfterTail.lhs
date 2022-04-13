Copyright (c) 2022 JEON Myoungjin <jeongoon@g... >

LICENSE: [Open Software License 3.0](https://opensource.org/licenses/OSL-3.0)

= You can find this article will be updated on [my blog](https://jeongoon.github.io/posts/2022-04-03-Combinations-TailAfterTail.html)

\begin{code}
{-# LANGUAGE BangPatterns #-}

module TailAfterTail
  ( combinations
  , combinations'
  , allCombinations
  , allCombinations'
  ) where

import Data.List (tails, inits, scanl')

\end{code}


== original version (scanl)

\begin{code}
combinations1' :: [a] -> [[[a]]]
combinations1' ms = [ [[m]] | m <- ms ]

genPart :: Foldable t => a -> t [[a]] -> [[a]]
genPart leader followerGroups = [ leader : followers
                                  | followers <- concat followerGroups ]

usefulTails :: [a] -> [[a]]
usefulTails = init . tails

genStep :: [[[a]]] -> [a] -> [[[a]]]
genStep prevTails members' =
  zipWith genPart members' (usefulTails prevTails')
  where
    prevTails' = tail prevTails -- head is not useful

membersTails = reverse . tail . inits -- tail is used to skip empty list.

allCombinationsScanl :: [a] -> [[[[a]]]]
allCombinationsScanl ms = scanl' genStep (combinations1' ms) (membersTails ms)

flatten_allCombinationsGrouped allComboFunc =
  map concat . allComboFunc

allCombinationsGrouped :: [a] -> [[[a]]]
allCombinationsGrouped =
  flatten_allCombinationsGrouped allCombinationsScanl

allCombinations :: [a] -> [[a]]
allCombinations = concat . allCombinationsGrouped
\end{code}


\begin{code}
unsafe_allCombinations :: [a] -> [[[[a]]]]
unsafe_allCombinations members =
  let
    helper [] = []
    helper ! cases =
      let
        genStep (m:ms) (_:cs:[]) = [ [ m : c | c <- cs ] ]
        genStep (m:ms) (_:cs) =
          [ m : c | c <- concat cs ] : genStep ms cs
      in
        cases : helper (genStep members cases)
  in
    helper [ [[m]] | m <- members ]

unsafe_allCombinationsGrouped :: [a] -> [[[a]]]
unsafe_allCombinationsGrouped =
  flatten_allCombinationsGrouped unsafe_allCombinations

allCombinations' :: [a] -> [[a]]
allCombinations' members =
  concat . take (length members) . unsafe_allCombinationsGrouped $ members


combinationsWith :: ([a] -> [[[a]]]) -> [a] -> Int -> Int -> [[a]]
combinationsWith allComboGroupedFunc ms n1@selectFrom n2@selectTo =
  let
    ( isFlipped, n1', n2' ) = -- smaller value first
      if n1 < n2 then ( False
                      , max n1 0
                      , max n2 0)
      else            ( True
                      , max n2 0
                      , max n1 0)
      -- and ensure all range value are zero or positive by usig `max`
    rangeLength = n2' - n1' + 1
    reverseIfNeeded
      | isFlipped = reverse
      | otherwise = id

  in
    -- note: read from the bottom
    concat                      -- 4. final flattening
    . reverseIfNeeded           -- 3. if user put opposite way, reverse it.
    . take rangeLength          -- 2. takes only intrested lists
    . drop (pred n1')           -- 1. ignore some
    $ allComboGroupedFunc ms

combinations = combinationsWith allCombinationsGrouped
combinations' = combinationsWith unsafe_allCombinationsGrouped
\end{code}
