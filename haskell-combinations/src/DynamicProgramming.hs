module DynamicProgramming
  ( combinations
  ) where

combinations :: [a] -> Int -> [[a]]
combinations xs m = combsBySize xs !! m
  where
    combsBySize = foldr f ([[]] : repeat [])
    f x next = zipWith (++) (map (map (x:)) ([]:next)) next
