{-# LANGUAGE NoImplicitPrelude #-}

module Set3a where

import           MCPrelude

allPairs :: [a] -> [b] -> [(a, b)]
allPairs [] _                  = []
allPairs _ []                  = []
allPairs as@(a:as') bs@(b:bs') = (a, b) : allPairs [a] bs' ++ allPairs as' bs

allPairs' :: [a] -> [b] -> [(a, b)]
allPairs' as bs = concat $ map (\a -> map (\b -> (a, b)) bs) as

allPairs'' :: [a] -> [b] -> [(a, b)]
allPairs'' as bs = foldl (\acc a -> acc ++ (map (\b -> (a, b)) bs)) [] as

-- This doesn't work (!!!) pattern-matching fails
-- but you can do this in JS/TS
allPairs''' :: [a] -> [b] -> [(a, b)]
allPairs''' xs@(x:xs') ys@(y:ys')
  | null xs = []
  | null ys = []
  | otherwise = (x, y) : allPairs''' [x] ys' ++ allPairs''' xs' ys
