import { Option, none, fold } from "fp-ts/lib/Option";
import { GreekData, greekDataA, greekDataB } from "./greekData";
import {
  divMay,
  headMay,
  lookupMay,
  maximumMay,
  tailMay,
  chainMay
} from "./optionFunctions";

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
const queryGreek = (gd: GreekData) => (str: string): Option<number> =>
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
          )(maximumMay(ys))
      )(tailMay(xs))
  )(lookupMay(str)(gd));

// queryGreek2 :: GreekData -> String -> Maybe Double
// queryGreek2 gd str =
//   chain (lookupMay str gd) $ \xs ->
//     chain (tailMay xs) $ \ys ->
//       chain (maximumMay ys) $ \y ->
//         chain (headMay xs) $ \x -> divMay (fromIntegral y) (fromIntegral x)
const queryGreek2 = (gd: GreekData) => (str: string): Option<number> =>
  chainMay(lookupMay(str)(gd))(xs =>
    chainMay(tailMay(xs))(ys =>
      chainMay(maximumMay(ys))(y => chainMay(headMay(xs))(x => divMay(y)(x)))
    )
  );
