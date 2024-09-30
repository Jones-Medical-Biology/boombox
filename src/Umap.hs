module Umap ( dataset
            , kNearestNeighbors
            , DataPoint
            , DataSet
            ) where

import Data.List (sortOn)

type DataPoint = [Double]
type DataSet = [DataPoint]

-- distance
euclideanDistance :: DataPoint -> DataPoint -> Double
euclideanDistance x y = sqrt . sum $ zipWith (\a b -> (a-b) ^ 2 ) x y

euclideanDistance3D :: DataPoint -> DataPoint -> DataPoint-> Double
euclideanDistance3D x y z = sqrt . sum $ zipWith3 (\a b c -> (a-b) ^ 2 + (a-c)^2) x y z

euclideanDistanceGeneralized :: DataPoint -> DataPoint -> Double
euclideanDistanceGeneralized x y =
  sqrt $ sum $ zipWith (\ x y -> (y - x) ^ 2) x y

findKNearestNeighbors :: Int -> DataSet -> DataPoint -> [(DataPoint, Double)]
findKNearestNeighbors k ds point = take k sortedDistances
  where
    distances = map(\x -> (x, euclideanDistanceGeneralized point x)) ds
    sortedDistances = sortOn snd distances

kNearestNeighbors :: DataSet -> DataPoint -> [(DataPoint, Double)]
kNearestNeighbors ds tp = findKNearestNeighbors k ds tp

graphWeights :: DataSet -> [[(Int, Double)]] -> [[(Int, Double)]]
graphWeights ds knn = map assignWeights knn
  where
    -- Weight assignment using Gaussian kernel
    assignWeights neighbors = map(\(i,d) -> (i, exp(-0.5*d^2))) neighbors

-- practice data
dataset :: DataSet
dataset = [[1.0, 2.0, 3.0], [2.0, 3.0, 4.0], [3.0, 4.0, 5.0], [4.0, 5.0, 6.0], [5.0, 6.0, 7.0], [6.0, 7.0, 8.0], [7.0, 8.0, 9.0]]

dataset2 :: DataSet
dataset2 = [[1..5], [6..10], [11..15],[16..20]]

targetPoint :: DataPoint
targetPoint = [2.5, 3.5, 4.5]

-- dataset = readFile "dataset.txt"
