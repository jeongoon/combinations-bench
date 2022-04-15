= bencmark implementations of my `Tail after Tail`

\begin{code}
module Main where

import Criterion
import Criterion.Main (defaultMain)
\end{code}

== Load Modules To Test

To test how fast my combinations module are, I made serveral individual module
per combinations method.

you could access codes at [here](https://github.com/jeongoon/combinations-bench/tree/main/haskell-combinations/src)

\begin{code}
import qualified TailAfterTail as Tat
import qualified DynamicProgramming as Dyn
\end{code}

== Prepare Sample Members

Some Numbers are used to be tested with `criterion`.

\begin{code}
small, medium, large :: [Int]
small  = [1..5]
medium = [1..12]
large  = [1..22]
\end{code}

== Helper Function and Data Types

In Elm language, not to confuse the order of argument,
it forces us  to write a data type, especially when the function
has more than three arguments. And I believe that in haskell, it will be
the good practice as well.

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

== main

`main` function is the executable code block for this benchmark.

defaultMain from `Criterion` will do rest of the job for us to handle
any arguments and execute each benchmark group (`bgroup`)


\begin{code}
main :: IO ()
main = do
  defaultMain
\end{code}

=== bench

[bench](https://hackage.haskell.org/package/criterion-1.5.9.0/docs/Criterion.html#v:bench)
will create a `Benchmark` type but *please note that*

You *should* pass:

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
bench "test benchmark message" $ nf testFunction anArgument
```

*nf* stands for `normal form` and another one is `weak head normal form`.
I skipped this explanation as I don't have enough knowledge to share yet.

\begin{code}
    [ bgroup "Small Sample Comparison"
      [ benchAllCombo TestData { name = "Tail After Tail (Scanl)"
                               , combiFunction = Tat.allCombinationsWithScanl
                               , sample = small }
      , benchAllCombo TestData { name = "Tail After Tail (SingleStep)"
                               , combiFunction = Tat.allCombinationsWithSingleStep
                               , sample = small }
      , benchAllCombo TestData { name = "Tail After Tail (TwoSteps)"
                               , combiFunction = Tat.allCombinationsWithTwoSteps
                               , sample = small }
      , benchAllCombo TestData { name = "Dynamic Programming"
                               , combiFunction = Dyn.allCombinations
                               , sample = small }
      ]

      , bgroup "Medium Sample Comparison"
      [ benchAllCombo TestData { name = "Tail After Tail (Scanl) 1"
                               , combiFunction = Tat.allCombinationsWithScanl
                               , sample = medium }
      , benchAllCombo TestData { name = "Tail After Tail (Scanl) 2"
                               , combiFunction = Tat.allCombinationsWithScanl
                               , sample = medium }
      , benchAllCombo TestData { name = "Tail After Tail (SingleStep) 1"
                               , combiFunction = Tat.allCombinationsWithSingleStep
                               , sample = medium }
      , benchAllCombo TestData { name = "Tail After Tail (SingleStep) 2"
                               , combiFunction = Tat.allCombinationsWithSingleStep
                               , sample = medium }
      , benchAllCombo TestData { name = "Tail After Tail (TwoSteps) 1"
                               , combiFunction = Tat.allCombinationsWithTwoSteps
                               , sample = medium }
      , benchAllCombo TestData { name = "Tail After Tail (TwoSteps) 2"
                               , combiFunction = Tat.allCombinationsWithTwoSteps
                               , sample = medium }
      , benchAllCombo TestData { name = "Dynamic Programming"
                               , combiFunction = Dyn.allCombinations
                               , sample = medium }
      ]
      , bgroup "Large Sample Comparison"
      [ benchAllCombo TestData { name = "Tail After Tail (Scanl) 1"
                               , combiFunction = Tat.allCombinationsWithScanl
                               , sample = large }
      , benchAllCombo TestData { name = "Tail After Tail (Scanl) 2"
                               , combiFunction = Tat.allCombinationsWithScanl
                               , sample = large }
      , benchAllCombo TestData { name = "Tail After Tail (SingleStep) 1"
                               , combiFunction = Tat.allCombinationsWithSingleStep
                               , sample = large }
      , benchAllCombo TestData { name = "Tail After Tail (SingleStep) 2"
                               , combiFunction = Tat.allCombinationsWithSingleStep
                               , sample = large }
      , benchAllCombo TestData { name = "Tail After Tail (TwoSteps) 1"
                               , combiFunction = Tat.allCombinationsWithTwoSteps
                               , sample = large }
      , benchAllCombo TestData { name = "Tail After Tail (TwoSteps) 2"
                               , combiFunction = Tat.allCombinationsWithTwoSteps
                               , sample = large }
      , benchAllCombo TestData { name = "Dynamic Programming"
                               , combiFunction = Dyn.allCombinations
                               , sample = large }
      ]
    ]
\end{code}
