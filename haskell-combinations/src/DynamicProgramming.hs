module DynamicProgramming
  ( allCombinations'
  , allCombinations
  , combinations
  ) where

-- modified to make allCombinations
allCombinations' :: [a] -> [[[a]]]
allCombinations' xs = (take . length $ xs) $ tail . combsBySize $ xs
  where
    combsBySize = foldr f ([[]] : repeat [])
    f x next = zipWith (++) (map (map (x:)) ([]:next)) next

allCombinations :: [a] -> [[a]]
allCombinations = concat . allCombinations'

combinations :: [a] -> Int -> [[a]]
combinations xs n = allCombinations' xs !! n
