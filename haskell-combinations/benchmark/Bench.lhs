This benchmark shows how fast each combination method will be under
small combination or medium size combination. (the number of members are 15)

== Module Name and Criterion
We will create a executable out of this module, So the name of module should
b e `Main`. and `Criterion` will be used for more accurate benchmark result.

\begin{code}
module Main where

import Criterion
import Criterion.Main (defaultMain)
\end{code}

== Load Modules To Test

\begin{code}
import qualified TailAfterTail as Tat
import qualified LeadersAndFollowers as Laf
import qualified DynamicProgramming as Dyn
\end{code}

== Prepare Sample Members

Some Numbers are used to be tested with `criterion`

`size5` is for small sample. `medium` for medium sample.

\begin{code}
small, medium, large :: [Int]
small = [1..5]
medium = [1..12]
large = [1..22]
\end{code}

== Helper Function and Data Types

In Elm language, not to confuse the order of argument,
it is recommeded to write a data type, especially when the function
has more than three arguments. And I believe that in haskell, it will be
the same, IMHO.

\begin{code}
data TestData a =
  TestData
  { name :: String
  , combiFunction :: [a] -> [[a]]
  , sample :: [a]
  }

\end{code}

=== benchAllCombo

`benchAllCombo` will make `Benchmark` type will be applied to `bgroup` function.

\begin{code}
benchAllCombo (TestData name combiFunction sample) =
  bench name $ nf combiFunction sample
\end{code}

=== mkAllCombinationsWith

`mkAllCombinationsWith` is a wrapper function to create all possible
combinations out of the members when the combination module doesn't provide one.

\begin{code}
mkAllCombinationsWith combiFunction ms =
  concat [ combiFunction ms n | n <- [1..length ms] ]
\end{code}

**FIXME**
However, this is not actually recommened approach. and will give inaccurate
result.

== main

`main` function is the executable code block for this benchmark.

defaultMain from `Criterion` will do rest of the job for us to handle
any arguments and execute each benchmark group (`bgroup`)


\begin{code}
main :: IO ()
main = do
  defaultMain
    [
\end{code}

=== bench

[bench](https://hackage.haskell.org/package/criterion-1.5.9.0/docs/Criterion.html#v:bench)
will create a `Benchmark` type but please note that

You should pass:

1. A function to test
2. An agrument to be applied.

In other words, you should not do:

```haskell
bench "test benchmark message" $ nf const testFunctionWithoutArgument
```
*`const` is sometimes useful function as much as `id` to make another function
suits in the type in a context*

Rather you should do:

```haskell
bench "test benchmark message" $ nf testFunction aArgument
```

\begin{code}
      bgroup "Small Sample Comparison"
      [ benchAllCombo TestData { name = "Leaders and Followers"
                               , combiFunction = mkAllCombinationsWith Laf.combinations
                               , sample = small }
      , benchAllCombo TestData { name = "Tail After Tail (scanl)"
                               , combiFunction = Tat.allCombinations
                               , sample = small }
      , benchAllCombo TestData { name = "Tail After Tail (new)"
                               , combiFunction = Tat.allCombinations'
                               , sample = small }
      , benchAllCombo TestData { name = "Dynamic Programming"
                               , combiFunction = Dyn.allCombinations
                               , sample = small }
      ]

      , bgroup "Medium Sample Comparison"
      [ benchAllCombo TestData { name = "Leaders and Followers"
                               , combiFunction = mkAllCombinationsWith Laf.combinations
                               , sample = medium }
      , benchAllCombo TestData { name = "Dynamic Programming 1"
                               , combiFunction = Dyn.allCombinations
                               , sample = medium }
      , benchAllCombo TestData { name = "Dynamic Programming 2"
                               , combiFunction = Dyn.allCombinations
                               , sample = medium }
      , benchAllCombo TestData { name = "Tail After Tail (scanl) 1"
                               , combiFunction = Tat.allCombinations
                               , sample = medium }
      , benchAllCombo TestData { name = "Tail After Tail (scanl) 2"
                               , combiFunction = Tat.allCombinations
                               , sample = medium }
      , benchAllCombo TestData { name = "Tail After Tail (new) 1"
                               , combiFunction = Tat.allCombinations
                               , sample = medium }
      , benchAllCombo TestData { name = "Tail After Tail (new) 2"
                               , combiFunction = Tat.allCombinations
                               , sample = medium }
      ]

      , bgroup "Large Sample Comparison"
      [ benchAllCombo TestData { name = "Tail After Tail (scanl) 1"
                               , combiFunction = Tat.allCombinations
                               , sample = large }
      , benchAllCombo TestData { name = "Tail After Tail (scanl) 2"
                               , combiFunction = Tat.allCombinations
                               , sample = large }
      , benchAllCombo TestData { name = "Tail After Tail (new) 1"
                               , combiFunction = Tat.allCombinations'
                               , sample = large }
      , benchAllCombo TestData { name = "Tail After Tail (new) 2"
                               , combiFunction = Tat.allCombinations'
                               , sample = large }
      , benchAllCombo TestData { name = "Dynamic Programming 1"
                               , combiFunction = Dyn.allCombinations
                               , sample = large }
      , benchAllCombo TestData { name = "Dynamic Programming 2"
                               , combiFunction = Dyn.allCombinations
                               , sample = large }
      , benchAllCombo TestData { name = "Leaders and Followers"
                               , combiFunction = mkAllCombinationsWith Laf.combinations
                               , sample = large }
      ]
    ]
\end{code}

and you could run the test with `stack` in two ways:

=== bench target

```sh
sh> stack build haskell-combinations:bench:haskell-combinations-benchmark
sh> #                                ^^^^^ -> benchmark target
sh> ... will compile the code print out the benchmarks result

.. snip ..
Benchmark haskell-combinations-benchmark: RUNNING...
benchmarking Small Sample Comparison/Leaders and Followers
time                 3.935 μs   (3.918 μs .. 3.963 μs)
                     0.999 R²   (0.997 R² .. 1.000 R²)
mean                 4.013 μs   (3.952 μs .. 4.230 μs)
std dev              353.3 ns   (100.6 ns .. 721.7 ns)
variance introduced by outliers: 84% (severely inflated)
                                  
benchmarking Small Sample Comparison/Tail After Tail
time                 3.758 μs   (3.573 μs .. 4.002 μs)
                     0.982 R²   (0.972 R² .. 0.995 R²)
mean                 3.645 μs   (3.545 μs .. 3.785 μs)
std dev              413.5 ns   (300.6 ns .. 567.0 ns)
variance introduced by outliers: 90% (severely inflated)
                                  
benchmarking Small Sample Comparison/Dynamic Programming
time                 3.291 μs   (3.162 μs .. 3.492 μs)
                     0.966 R²   (0.946 R² .. 0.982 R²)
mean                 3.603 μs   (3.416 μs .. 3.910 μs)
std dev              795.0 ns   (617.9 ns .. 1.153 μs)
variance introduced by outliers: 97% (severely inflated)

.. snip ..

```
=== executable target

```sh
'# compile first
sh> stack build haskell-combinations:exe:haskell-combinations-benchmark-exe
'# execute
sh> stack exec haskell-combinations-benchmark-exe -- -o output.html
'# and have a look `output.html`
```

`output.html` will report the result with some helpful graphs.
