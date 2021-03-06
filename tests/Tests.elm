module Tests exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Diff exposing (..)


all : Test
all =
  describe "A Test Suite"
    [ basic
    , perf
    ]


basic : Test
basic =
  describe "Basic"
    [ test "basic" (\_ -> Expect.equal [] (diff [] []) )
    , test "basic" (\_ -> Expect.equal [Removed 1] (diff [1] []) )
    , test "basic" (\_ -> Expect.equal [Added 1] (diff [] [1]) )
    , test "basic" (\_ -> Expect.equal [NoChange 1] (diff [1] [1]) )
    , test "basic" (\_ -> Expect.equal [NoChange 1, Removed 2] (diff [1,2] [1]) )
    , test "basic" (\_ -> Expect.equal [Removed 1, NoChange 2] (diff [1,2] [2]) )
    , test "basic" (\_ -> Expect.equal [NoChange 1, Added 2] (diff [1] [1,2]) )
    , test "basic" (\_ -> Expect.equal [Added 1, NoChange 2] (diff [2] [1,2]) )
    , test "basic" (\_ -> Expect.equal [NoChange 1, NoChange 2] (diff [1,2] [1,2]) )
    , test "basic" (\_ -> Expect.equal [Removed 1, Removed 2] (diff [1,2] []) )
    , test "basic" (\_ -> Expect.equal [Added 1, Added 2] (diff [] [1,2]) )
    , test "basic" (\_ -> Expect.equal [Removed 1, Added 2] (diff [1] [2]) )
    , test "basic" (\_ -> Expect.equal [Removed 1, Added 2, NoChange 3] (diff [1, 3] [2, 3]) )
    , test "basic" (\_ -> Expect.equal [Removed 1, Removed 2, Added 3, Added 4] (diff [1, 2] [3, 4]) )
    ]


runManyTimes : Int -> String -> String -> (() -> Expectation)
runManyTimes times a b =
  let
    total =
      List.foldl (\i n -> n + List.length (diffLines a b)) 0 (List.range 1 times)
  in
    \_ -> Expect.true "" (total > 0)


perf : Test
perf =
  describe "Perf"
    [ test "exactly same" (runManyTimes 100 a a)
    , test "add line to first" (runManyTimes 100 a b)
    , test "add line to last" (runManyTimes 100 a c)
    , test "drop first line" (runManyTimes 100 a d)
    , test "remove line at middle" (runManyTimes 100 a e)
    , test "add line at middle" (runManyTimes 100 a f)

    -- O(ND): 0.63s ( O(ND) = (280*2)*(280*2) )
    -- O(NP): 0.32s ( O(NP) = (280*2)*((280*2-0)/2) )
    , test "modify all" (runManyTimes 10 a g)

    -- O(ND): 0.13s ( O(ND) = 280*280 )
    -- O(NP): 0.0s ( O(NP) = 280*((280-280)/2) )
    , test "add all" (runManyTimes 10 "" a)

    -- O(ND): 0.13s ( O(ND) = 280*280 )
    -- O(NP): 0.0s ( O(NP) = 280*((280-280)/2) )
    , test "remove all" (runManyTimes 10 a "")
    ]


b = "first\n" ++ a
c = a ++ "\nlast"
d = mapLines (List.drop 1) a
e = mapLines (List.take 100) a ++ mapLines (List.drop 101) a
f = mapLines (List.take 101) a ++ mapLines (List.drop 100) a
g = mapEachLine ((++) "_") a

mapLines f s =
  String.join "\n" (f (String.lines s))

mapEachLine f s =
  mapLines (List.map f) s

a = """
{ a =
    [ 0
    , 1
    , 2
    , 3
    , 4
    , 5
    , 6
    , 7
    , 8
    , 9
    , 1
    , 2
    , 3
    , 4
    , 5
    , 6
    , 7
    , 8
    , 9
    ]
, b =
    [ 0
    , 1
    , 2
    , 3
    , 4
    , 5
    , 6
    , 7
    , 8
    , 9
    , 1
    , 2
    , 3
    , 4
    , 5
    , 6
    , 7
    , 8
    , 9
    ]
, c =
    [ 0
    , 1
    , 2
    , 3
    , 4
    , 5
    , 6
    , 7
    , 8
    , 9
    , 1
    , 2
    , 3
    , 4
    , 5
    , 6
    , 7
    , 8
    , 9
    ]
, d = 0
, e =
    [ 0
    , 1
    , 2
    , 3
    , 4
    , 5
    , 6
    , 7
    , 8
    , 9
    , 1
    , 2
    , 3
    , 4
    , 5
    , 6
    , 7
    , 8
    , 9
    ]
, f =
    [ 0
    , 1
    , 2
    , 3
    , 4
    , 5
    , 6
    , 7
    , 8
    , 9
    , 1
    , 2
    , 3
    , 4
    , 5
    , 6
    , 7
    , 8
    , 9
    ]
, g =
    [ 0
    , 1
    , 2
    , 3
    , 4
    , 5
    , 6
    , 7
    , 8
    , 9
    , 1
    , 2
    , 3
    , 4
    , 5
    , 6
    , 7
    , 8
    , 9
    ]
, h =
    { a = 1
    , b = 1
    , c = 1
    , d = 1
    , e = "1"
    , f = "1"
    , g = "1"
    , h = "1"
    , i = "1"
    , j = "1"
    , k = "1"
    }
, i = 0
, j =
    "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
, k =
    "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
, l =
    "ccccccccccccccccccccccccccccccccccc"
, o =
    "dddddddddddddddddddddddddddddddddddddddddddddddddddddd"
, p =
    Just
      ( Just
          ( Just
              ( Just
                  ( Just
                      ( Just ( Just ( Just ( Just 1 ) ) ) )
                  )
              )
          )
      )
, q =
    Just
      ( Just
          ( Just
              ( Just
                  ( Just
                      ( Just ( Just ( Just ( Just 2 ) ) ) )
                  )
              )
          )
      )
, r =
    Just
      ( Just
          ( Just
              ( Just
                  ( Just
                      ( Just ( Just ( Just ( Just 3 ) ) ) )
                  )
              )
          )
      )
, s =
    Just
      ( Just
          ( Just
              ( Just
                  ( Just
                      ( Just ( Just ( Just ( Just 4 ) ) ) )
                  )
              )
          )
      )
, t = "Ok, Google"
, u = 123456789
, v = 123.456
, w =
    [ 0
    , 1
    , 2
    , 3
    , 4
    , 5
    , 6
    , 7
    , 8
    , 9
    , 1
    , 2
    , 3
    , 4
    , 5
    , 6
    , 7
    , 8
    , 9
    ]
, x =
    [ 0
    , 1
    , 2
    , 3
    , 4
    , 5
    , 6
    , 7
    , 8
    , 9
    , 1
    , 2
    , 3
    , 4
    , 5
    , 6
    , 7
    , 8
    , 9
    ]
, y =
    [ 0
    , 1
    , 2
    , 3
    , 4
    , 5
    , 6
    , 7
    , 8
    , 9
    , 1
    , 2
    , 3
    , 4
    , 5
    , 6
    , 7
    , 8
    , 9
    ]
, z =
    [ 0
    , 1
    , 2
    , 3
    , 4
    , 5
    , 6
    , 7
    , 8
    , 9
    , 1
    , 2
    , 3
    , 4
    , 5
    , 6
    , 7
    , 8
    , 9
    ]
}
"""
