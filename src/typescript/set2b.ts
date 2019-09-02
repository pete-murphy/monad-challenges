import { Option, none, fold, chain, some } from "fp-ts/lib/Option";
import * as M from "fp-ts/lib/Monoid";
import { GreekData, greekDataA, greekDataB } from "./greekData";
import {
  divMay,
  headMay,
  lookupMay,
  maximumMay,
  tailMay,
  chainMay
} from "./optionFunctions";
import { identity } from "fp-ts/lib/function";
import { ordNumber, Ord } from "fp-ts/lib/Ord";
import { eqString } from "fp-ts/lib/Eq";

// queryGreek :: GreekData -> String -> Maybe Double
// queryGreek gd str =
//   case lookupMay str gd of
//     Nothing -> Nothing
//     Just xs ->
//       case tailMay xs of
//         Nothing -> Nothing
//         Just ys ->
//           case maximumMay ys of
//             Nothing -> Nothing
//             Just y ->
//               case headMay xs of
//                 Nothing -> Nothing
//                 Just x  -> divMay (fromIntegral y) (fromIntegral x)
export const queryGreek = (gd: GreekData) => (str: string): Option<number> =>
  fold(
    () => none,
    (xs: Array<number>) =>
      fold(
        () => none,
        (ys: Array<number>) =>
          fold(
            () => none,
            (y: number) =>
              fold(() => none, (x: number) => divMay(y)(x))(headMay(xs))
          )(maximumMay(ordNumber)(ys))
      )(tailMay(xs))
  )(lookupMay(eqString)(str)(gd));

// queryGreek2 :: GreekData -> String -> Maybe Double
// queryGreek2 gd str =
//   chain (lookupMay str gd) $ \xs ->
//     chain (tailMay xs) $ \ys ->
//       chain (maximumMay ys) $ \y ->
//         chain (headMay xs) $ \x -> divMay (fromIntegral y) (fromIntegral x)
export const queryGreek2 = (gd: GreekData) => (str: string): Option<number> =>
  chainMay(lookupMay(eqString)(str)(gd))(xs =>
    chainMay(tailMay(xs))(ys =>
      chainMay(maximumMay(ordNumber)(ys))(y =>
        chainMay(headMay(xs))(x => divMay(y)(x))
      )
    )
  );

// addSalaries :: [(String, Integer)] -> String -> String -> Maybe Integer
// addSalaries ss p1 p2 =
//   chain
//     (lookupMay p1 ss)
//     (\s1 -> chain (lookupMay p2 ss) (\s2 -> Just (s1 + s2)))
export const addSalaries = (ss: Array<[string, number]>) => (p1: string) => (
  p2: string
): Option<number> =>
  chainMay(lookupMay(eqString)(p1)(ss))(s1 =>
    chainMay(lookupMay(eqString)(p2)(ss))(s2 => some(s1 + s2))
  );

// yLink :: (a -> b -> c) -> Maybe a -> Maybe b -> Maybe c
// yLink f ma mb = chain ma (\a -> chain mb (\b -> mkMaybe (f a b)))
export const yLink = <A, B, C>(f: (a: A) => (b: B) => C) => (ma: Option<A>) => (
  mb: Option<B>
): Option<C> => chainMay(ma)(a => chainMay(mb)(b => some(f(a)(b))));

// transMaybe :: (a -> b) -> Maybe a -> Maybe b
// transMaybe f Nothing  = Nothing
// transMaybe f (Just a) = mkMaybe $ f a
export const transMaybe = <A, B>(f: (a: A) => B) => (
  ma: Option<A>
): Option<B> => fold(() => none, (a: A) => some(f(a)))(ma);

// product :: Num a => t a -> a
// product = getProduct . foldMap Product
export const product = M.fold(M.monoidProduct);

// tailProd :: Num a => [a] -> Maybe a
// tailProd as = transMaybe product (tailMay as)
export const tailProd = (as: Array<number>): Option<number> =>
  transMaybe(product)(tailMay(as));

// sum :: Num a => t a -> a
// sum = getSum . foldMap Sum
export const sum = M.fold(M.monoidSum);

// tailSum :: Num a => [a] -> Maybe a
// tailSum as = transMaybe sum (tailMay as)
export const tailSum = (as: Array<number>): Option<number> =>
  transMaybe(sum)(tailMay(as));

// collapse :: Maybe (Maybe a) -> Maybe a
// collapse mma = chain mma id
export const collapse = <A>(mma: Option<Option<A>>): Option<A> =>
  chainMay(mma)(identity);

// tailMax :: Ord a => [a] -> Maybe a
// tailMax as = collapse $ transMaybe maximumMay (tailMay as)
export const tailMax = <A>(O: Ord<A>) => (as: Array<A>): Option<A> =>
  collapse(transMaybe(maximumMay(O))(tailMay(as)));
