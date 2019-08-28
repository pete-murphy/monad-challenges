module Set1a where

import           MCPrelude

fiveRands :: [Integer]
fiveRands =
  let (n1, s1) = rand (mkSeed 1)
      (n2, s2) = rand s1
      (n3, s3) = rand s2
      (n4, s4) = rand s3
      (n5, _) = rand s4
   in [n1, n2, n3, n4, n5]

randLetter :: Gen Char
randLetter s =
  let (i, s') = rand s
   in (toLetter i, s')

randString3 :: String
randString3 =
  let (l1, s1) = randLetter $ mkSeed 1
      (l2, s2) = randLetter s1
      (l3, _) = randLetter s2
   in [l1, l2, l3]

type Gen a = Seed -> (a, Seed)

randEven :: Gen Integer
randEven = generalA (* 2) rand

randOdd :: Gen Integer
randOdd = generalA (+ 1) randEven

randTen :: Gen Integer
randTen = generalA (* 10) rand

generalA :: (a -> b) -> Gen a -> Gen b
generalA f g s =
  let (i, s') = g s
   in (f i, s')
