{-# LANGUAGE ScopedTypeVariables, BangPatterns #-}

module Lib ( giveMeData
           ) where

import Umap ( kNearestNeighbors
            , DataPoint)

import qualified Data.ByteString.Lazy as BL
import Data.Csv
import Data.Char (ord)
import qualified Data.Vector as V

giveMeData :: FilePath -> IO ()
giveMeData x = do
  csvData      <- BL.readFile x
  let myDecode = decode NoHeader csvData :: Either String (V.Vector Umap.DataPoint)
  case myDecode of
    Left err -> putStrLn err
    Right vs -> do
      out <- return (kNearestNeighbors (tail (V.toList vs)) (head (V.toList vs)))
      putStr "Ref: "
      (putStrLn . show) (head (V.toList vs))
      putStr "1: "
      (putStr . show) $ fst $ (!!) out 0
      putStr ", Distance: "
      (putStrLn . show) $ snd $ (!!) out 0
      putStr "2: "
      (putStr . show) $ fst $ (!!) out 1
      putStr ", Distance: "
      (putStrLn . show) $ snd $ (!!) out 1
