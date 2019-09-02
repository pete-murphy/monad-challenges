{-# LANGUAGE NoImplicitPrelude #-}

module Set2a where

import           MCPrelude

data Maybe a
  = Nothing
  | Just a

instance Show a => Show (Maybe a) where
  show Nothing  = "Nothing"
  show (Just x) = "Just " ++ show x

instance Eq a => Eq (Maybe a) where
  Just x == Just y = x == y
  Nothing == Nothing = True
  _ == _ = False

fold :: Maybe a -> b -> (a -> b) -> b
fold (Just a) b aToB = aToB a
fold Nothing b aToB  = b

chain :: Maybe a -> (a -> Maybe b) -> Maybe b
chain Nothing _          = Nothing
chain (Just a) aToMaybeB = aToMaybeB a

foo :: Int -> Maybe Int
foo a =
  if a > 5
    then Just (a * 7)
    else Nothing

headMay :: [a] -> Maybe a
headMay []     = Nothing
headMay (a:as) = Just a

tailMay :: [a] -> Maybe [a]
tailMay []     = Nothing
tailMay (a:as) = Just as

lookupMay :: Eq a => a -> [(a, b)] -> Maybe b
lookupMay a [] = Nothing
lookupMay a ((a', b):pairs) =
  if a == a'
    then Just b
    else lookupMay a pairs

divMay :: (Eq a, Fractional a) => a -> a -> Maybe a
divMay numerator 0           = Nothing
divMay numerator denominator = Just (numerator / denominator)

maximumMay :: Ord a => [a] -> Maybe a
maximumMay [] = Nothing
maximumMay (a:as) =
  case maximumMay as of
    Nothing -> Just a
    Just a' -> Just (max a a')

newtype Down a =
  Down
    { getDown :: a
    }
  deriving (Eq)

instance Ord a => Ord (Down a) where
  Down a <= Down b = a > b

mapMay :: (a -> b) -> Maybe a -> Maybe b
mapMay f Nothing  = Nothing
mapMay f (Just a) = Just (f a)

minimumMay :: Ord a => [a] -> Maybe a
minimumMay as = mapMay getDown (maximumMay $ map Down as)

addSalaries :: [(String, Integer)] -> String -> String -> Maybe Integer
addSalaries ss p1 p2 = lookupMay p1 ss lookupMay p2 ss
