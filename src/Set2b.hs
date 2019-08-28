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
