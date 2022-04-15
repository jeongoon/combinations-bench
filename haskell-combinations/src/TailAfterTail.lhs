Copyright (c) 2022 JEON Myoungjin <jeongoon@g... >

LICENSE: [Open Software License 3.0](https://opensource.org/licenses/OSL-3.0)

= You can find this article will be updated on [my blog](https://jeongoon.github.io/posts/2022-04-03-Combinations-TailAfterTail.html)

\begin{code}
{-# LANGUAGE BangPatterns #-}

module TailAfterTail
  ( combinationsWithScanl
  , combinationsWithSingleStep
  , combinations
  , combinationsWithTwoSteps
  , allCombinationsWithScanl
  , allCombinationsWithSingleStep
  , allCombinationsWithTwoSteps
  , allCombinations
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

allCombinationsWithScanl' :: [a] -> [[[[a]]]]
allCombinationsWithScanl' ms =
  scanl' genStep (combinations1' ms) (membersTails ms)

flatten_allCombinationsGrouped allComboFunc =
  map concat . allComboFunc

allCombinationsWithScanlGrouped :: [a] -> [[[a]]]
allCombinationsWithScanlGrouped =
  flatten_allCombinationsGrouped allCombinationsWithScanl'

allCombinationsWithScanl :: [a] -> [[a]]
allCombinationsWithScanl = concat . allCombinationsWithScanlGrouped
\end{code}

== pure implementation without scanl (SingleStep)

the following code is new pure implementation without scanl or zipWith.
sligtly faster than original implementation with (bang pattern: !).
(small: faster, medium: similar, large: faster)

\begin{code}
unsafe_allCombinationsWithSingleStep :: [a] -> [[[[a]]]]
unsafe_allCombinationsWithSingleStep members =
  let
    helper ! cases = -- bang pattern added
      let
        genStep (m:ms) (_:cs:[]) = [ [ m : c | c <- cs ] ]
        genStep (m:ms) (_:cs) =
          [ m : c | c <- concat cs ] : genStep ms cs
      in
         cases : helper (genStep members cases)
  in
    helper [ [[m]] | m <- members ]

unsafe_allCombinationsWithSingleStepGrouped :: [a] -> [[[a]]]
unsafe_allCombinationsWithSingleStepGrouped =
  flatten_allCombinationsGrouped unsafe_allCombinationsWithSingleStep

allCombinationsWithSingleStep :: [a] -> [[a]]
allCombinationsWithSingleStep members =
  concat
  . take (length members)
  . unsafe_allCombinationsWithSingleStepGrouped
  $ members


\end{code}

\begin{code}
allCombinationsWithTwoSteps' :: [a] -> [[[[a]]]]
allCombinationsWithTwoSteps'
  members@(fm:rms) = -- ^ fm : first member; rms: rest memebers
  let
    initFirstCase = [[fm]]
    initRestCases = [ [[m]] | m <- rms ]

    genFirstCase {- prevTail -} =
      map (fm:) . concat {- $ prevTail -}

    genRestCases _ [] = []
    genRestCases (m:ms) rcs@(_:rcs') = -- ^ rcs : rest of cases
      (map (m:) . concat $ rcs) : (genRestCases ms rcs')

    helper [] = []
    helper ! prevTail =
      let
        newTail = genRestCases rms (tail prevTail)
      in
        ((genFirstCase prevTail) : newTail) : helper newTail

  in (initFirstCase : initRestCases) : helper initRestCases

allCombinationsWithTwoStepsGrouped :: [a] -> [[[a]]]
allCombinationsWithTwoStepsGrouped =
  flatten_allCombinationsGrouped allCombinationsWithTwoSteps'

allCombinationsWithTwoSteps :: [a] -> [[a]]
allCombinationsWithTwoSteps members =
  concat . allCombinationsWithTwoStepsGrouped $ members
\end{code}

== combinations variant from each implementation

\begin{code}
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

combinationsWithScanl      = combinationsWith allCombinationsWithScanlGrouped
combinationsWithSingleStep = combinationsWith unsafe_allCombinationsWithSingleStepGrouped
combinationsWithTwoSteps   = combinationsWith allCombinationsWithTwoStepsGrouped
\end{code}

== choose default allCombinations and combinations
\begin{code}
allCombinations = allCombinationsWithTwoSteps
combinations = combinationsWithTwoSteps
\end{code}
