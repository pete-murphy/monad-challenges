{-# LANGUAGE InstanceSigs  #-}
{-# LANGUAGE TupleSections #-}

module Set1b where

import           MCPrelude
import           Set1a

randPair :: Gen (Char, Integer)
randPair s =
  let (c, s') = randLetter s
      (i, s'') = rand s'
   in ((c, i), s'')

generalPair :: Gen a -> Gen b -> Gen (a, b)
generalPair ga gb s =
  let (a, s') = ga s
      (b, s'') = gb s'
   in ((a, b), s'')

generalB :: (a -> b -> c) -> Gen a -> Gen b -> Gen c
generalB f ga gb s =
  let (a, s') = ga s
      (b, s'') = gb s'
      c = f a b
   in (c, s'')

generalPair2 :: Gen a -> Gen b -> Gen (a, b)
generalPair2 = generalB (,)

repRandom :: [Seed -> (a, Seed)] -> Seed -> ([a], Seed)
repRandom gens seed = go gens ([], seed)
  where
    go [] (xs, s) = (reverse xs, s)
    go (f:fs) (xs, s) =
      let (x, s') = f s
       in go fs (x : xs, s')

repRandom' :: [Seed -> (a, Seed)] -> Seed -> ([a], Seed)
repRandom' gens seed = foldl f ([], seed) gens
  where
    f (xs, s) gen = (xs ++ [x], s')
      where
        (x, s') = gen s

repRandom'' :: [Gen a] -> Gen [a]
repRandom'' [] = ([], )
repRandom'' (g:gs) =
  \s ->
    let (a, s') = g s
        (as, s'') = repRandom'' gs s'
     in (a : as, s'')

newtype Gen' a =
  Gen'
    { runGen' :: Seed -> (a, Seed)
    }
-- instance Functor Gen' where
--   fmap :: (a -> b) -> Gen' a -> Gen' b
--   fmap f (Gen' g) =
--     Gen' $ \s ->
--       let (x, s') = g s
--        in (f x, s')
-- instance Applicative Gen' where
--   pure :: a -> Gen' a
--   pure x = Gen' (x, )
--   (<*>) :: Gen' (a -> b) -> Gen' a -> Gen' b
--   Gen' gf <*> Gen' ga =
--     Gen' $ \s ->
--       let (f, s') = gf s
--           (a, s'') = ga s'
--        in (f a, s'')
-- instance Monad Gen' where
--   return = pure
--   (>>=) :: Gen' a -> (a -> Gen' b) -> Gen' b
--   Gen' ga >>= f =
--     Gen' $ \s ->
--       let (a, s') = ga s
--           Gen' gb = f a
--        in gb s'
