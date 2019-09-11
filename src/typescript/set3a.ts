/*
allPairs :: [a] -> [b] -> [(a, b)]
allPairs [] _                  = []
allPairs _ []                  = []
allPairs xs@(x:xs') ys@(y:ys') = (x, y) : allPairs [x] ys' ++ allPairs xs' ys
*/
export const allPairs = <A>(xs: Array<A>, [x, ...xs_] = xs) => <B>(
  ys: Array<B>,
  [y, ...ys_] = ys
): Array<[A, B]> =>
  xs.length === 0
    ? []
    : ys.length === 0
    ? []
    : [[x, y], ...allPairs([x])(ys_), ...allPairs(xs_)(ys)];

allPairs([1, 2, 3])([4, 5, 6]); //?

/*
allPairs' :: [a] -> [b] -> [(a, b)]
allPairs' as bs = foldl (\acc a -> acc ++ (map (\b -> (a, b)) bs)) [] as
*/
export const allPairs_ = <A>(as: Array<A>) => <B>(
  bs: Array<B>
): Array<[A, B]> => as.reduce((acc, a) => [...acc, ...bs.map(b => [a, b])], []);
