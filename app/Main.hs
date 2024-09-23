module Main where

import Lib (giveMeData)
import System.Environment

main :: IO ()
main = do
  args <- getArgs
  case args of
    (x:xs) -> case x of
      "knn" -> case xs of
        (x:_) -> giveMeData x
        _     -> putStrLn "I need a filepath"
      _     -> putStrLn "I need a program I know (knn)"
    _      -> putStrLn "I need the name of a program (knn) and an argument (filepath)"
