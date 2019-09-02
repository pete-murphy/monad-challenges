module Set2b where

import           MCPrelude
import           Set2a

queryGreek :: GreekData -> String -> Maybe Double
queryGreek gd str =
  case lookupMay str gd of
    Nothing -> Nothing
    Just xs ->
      case tailMay xs of
        Nothing -> Nothing
        Just ys ->
          case maximumMay ys of
            Nothing -> Nothing
            Just y ->
              case headMay xs of
                Nothing -> Nothing
                Just x  -> divMay (fromIntegral y) (fromIntegral x)

queryGreek2 :: GreekData -> String -> Maybe Double
queryGreek2 gd str =
  chain (lookupMay str gd) $ \xs ->
    chain (tailMay xs) $ \ys ->
      chain (maximumMay ys) $ \y ->
        chain (headMay xs) $ \x -> divMay (fromIntegral y) (fromIntegral x)

queryGreek3 :: GreekData -> String -> Maybe Double
queryGreek3 gd str =
  lookupMay str gd `chain` \xs ->
    tailMay xs `chain` \ys ->
      maximumMay ys `chain` \y ->
        headMay xs `chain` \x -> divMay (fromIntegral y) (fromIntegral x)

{-
queryGreek4 :: GreekData -> String -> Maybe Double
queryGreek4 gd str = do
  xs <- lookupMay str gd
  ys <- tailMay xs
  y <- maximumMay ys
  x <- headMay xs
  divMay (fromIntegral y) (fromIntegral x)
-}
addSalaries :: [(String, Integer)] -> String -> String -> Maybe Integer
addSalaries ss p1 p2 =
  chain
    (lookupMay p1 ss)
    (\s1 -> chain (lookupMay p2 ss) (\s2 -> Just (s1 + s2)))

-- chain :: Maybe a -> (a -> Maybe b) -> Maybe b
yLink' :: (a -> b -> c) -> Maybe a -> Maybe b -> Maybe c
yLink' _ Nothing _         = Nothing
yLink' _ _ Nothing         = Nothing
yLink' f (Just a) (Just b) = mkMaybe $ f a b

yLink :: (a -> b -> c) -> Maybe a -> Maybe b -> Maybe c
yLink f ma mb = chain ma (\a -> chain mb (\b -> mkMaybe (f a b)))

mkMaybe :: a -> Maybe a
mkMaybe = Just

tailProd :: Num a => [a] -> Maybe a
tailProd as = transMaybe product (tailMay as)

tailSum :: Num a => [a] -> Maybe a
tailSum as = transMaybe sum (tailMay as)

transMaybe :: (a -> b) -> Maybe a -> Maybe b
transMaybe f Nothing  = Nothing
transMaybe f (Just a) = mkMaybe $ f a

tailMax :: Ord a => [a] -> Maybe a
tailMax as = collapse $ transMaybe maximumMay (tailMay as)

-- chain :: Maybe x -> (x -> Maybe y) -> Maybe y
--          x ~ (Maybe a)
--          y ~ a
--          Maybe y ~ x ~ (Maybe a)
collapse :: Maybe (Maybe a) -> Maybe a
collapse mma = chain mma id
