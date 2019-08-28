// type GreekData = [(String, [Integer])]
export type GreekData = Array<[string, Array<number>]>;

// greekDataA :: GreekData
// greekDataA = [ ("alpha", [5, 10])
//              , ("beta", [0, 8])
//              , ("gamma", [18, 47, 60])
//              , ("delta", [42])
//              ]
export const greekDataA: GreekData = [
  ["alpha", [5, 10]],
  ["beta", [0, 8]],
  ["gamma", [18, 47, 60]],
  ["delta", [42]]
];

// greekDataB :: GreekData
// greekDataB = [ ("phi", [53, 13])
//              , ("chi", [21, 8, 191])
//              , ("psi", [])
//              , ("omega", [6, 82, 144])
//              ]
export const greekDataB: GreekData = [
  ["phi", [53, 13]],
  ["chi", [21, 8, 191]],
  ["psi", []],
  ["omega", [6, 82, 144]]
];
