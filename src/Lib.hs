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
    Right vs -> (putStrLn . show) $ kNearestNeighbors (tail (V.toList vs)) (head (V.toList vs))
