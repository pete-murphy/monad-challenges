{-# LANGUAGE NoImplicitPrelude #-}

module Set3a where

import           MCPrelude

allPairs :: [a] -> [b] -> [(a, b)]
allPairs [] _                  = []
allPairs _ []                  = []
allPairs xs@(x:xs') ys@(y:ys') = (x, y) : allPairs [x] ys' ++ allPairs xs' ys

allPairs' :: [a] -> [b] -> [(a, b)]
allPairs' as bs = concat $ map (\a -> map (\b -> (a, b)) bs) as
