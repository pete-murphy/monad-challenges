import { none, some, Option, fold } from "fp-ts/lib/Option";

// headMay :: [a] -> Maybe a
// headMay []     = Nothing
// headMay (x:_) = Just x
export const headMay = <A>([x, ..._]: Array<A>): Option<A> =>
  x === undefined ? none : some(x);

// tailMay :: [a] -> Maybe [a]
// tailMay []     = Nothing
// tailMay (_:xs) = Just xs
export const tailMay = <A>([_, ...xs]: Array<A>): Option<Array<A>> =>
  _ === undefined ? none : some(xs);

// lookupMay :: Eq a => a -> [(a, b)] -> Maybe b
// lookupMay x [] = Nothing
// lookupMay x ((x', y):pairs) =
//   if x == x'
//     then Just y
//     else lookupMay x pairs
export const lookupMay = <A>(x: A) => <B>([[x_, y], ...pairs]: Array<
  [A, B]
>): Option<B> =>
  x_ === undefined ? none : x === x_ ? some(y) : lookupMay(x)(pairs);

// divMay :: (Eq a, Fractional a) => a -> a -> Maybe a
// divMay numerator 0           = Nothing
// divMay numerator denominator = Just (numerator / denominator)
export const divMay = (numerator: number) => (
  denominator: number
): Option<number> => (denominator === 0 ? none : some(numerator / denominator));

// maximumMay :: Ord a => [a] -> Maybe a
// maximumMay [] = Nothing
// maximumMay (x:xs) =
//   case maximumMay xs of
//     Nothing -> Just x
//     Just x' -> Just (max x x')
export const maximumMay = ([x, ...xs]: Array<number>): Option<number> =>
  x === undefined
    ? none
    : fold(() => some(x), (x_: number) => some(Math.max(x, x_)))(
        maximumMay(xs)
      );

export const minimumMay = ([x, ...xs]: Array<number>): Option<number> =>
  x === undefined
    ? none
    : fold(() => some(x), (x_: number) => some(Math.min(x, x_)))(
        minimumMay(xs)
      );

// mapMay :: (a -> b) -> Maybe a -> Maybe b
// mapMay f Nothing  = Nothing
// mapMay f (Just a) = Just (f a)
export const mapMay = <A, B>(f: (x: A) => B) => (
  maybeA: Option<A>
): Option<B> => fold(() => none, (x: A) => some(f(x)))(maybeA);
