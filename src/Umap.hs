module Umap ( dataset
            , kNearestNeighbors
            , DataPoint
            , DataSet
            ) where

import Data.List (sortOn)
import Control.Parallel.Strategies
import Control.DeepSeq (NFData)

type DataPoint = [Double]
type DataSet = [DataPoint]

-- distance
euclideanDistance :: DataPoint -> DataPoint -> Double
euclideanDistance x y = sqrt . sum $ zipWith (\a b -> (a-b) ^ 2 ) x y

euclideanDistance3D :: DataPoint -> DataPoint -> DataPoint-> Double
euclideanDistance3D x y z = sqrt . sum $ zipWith3 (\a b c -> (a-b) ^ 2 + (a-c)^2) x y z

euclideanDistanceGeneralized :: DataPoint -> DataPoint -> Double
euclideanDistanceGeneralized x y = sqrt $ sum $ squaredDifferences
  where
    squaredDifferences = zipWith (\ x y -> (y - x) ^ 2) x y `using` parList rdeepseq

-- findKNearestNeighbors :: Int -> DataSet -> DataPoint -> [(DataPoint, Double)]
-- findKNearestNeighbors k ds point = take k sortedDistances
--   where
--     distances = map(\x -> (x, euclideanDistanceGeneralized point x)) ds
--     sortedDistances = sortOn snd distances

findKNearestNeighbors :: (NFData DataPoint, NFData DataSet) => Int -> DataSet -> DataPoint -> [(DataPoint, Double)]
findKNearestNeighbors k ds point = take k sortedDistances
  where
    distances = parMap rdeepseq (\x -> (x, euclideanDistanceGeneralized point x)) ds
    sortedDistances = sortOn snd distances

findKNearestNeighborsMatrix :: Int -> [[(DataPoint, Double)]] -> Int -> [(DataPoint, Double)]
findKNearestNeighborsMatrix k distMatrix idx = take k sortedDistances
  where
    sortedDistances = sortOn snd (distMatrix !! idx)

kNearestNeighbors :: DataSet -> DataPoint -> [(DataPoint, Double)]
kNearestNeighbors ds tp = findKNearestNeighbors 2 ds tp

graphWeights :: DataSet -> [[(Int, Double)]] -> [[(Int, Double)]]
graphWeights ds knn = map assignWeights knn
  where
    -- Weight assignment using Gaussian kernel
    assignWeights neighbors = map (\(i,d) -> (i, exp (-0.5*d^2))) neighbors

distanceMatrix :: DataSet -> [[ (DataPoint, Double) ]]
distanceMatrix ds = map (\point -> map (\d -> (d, euclideanDistanceGeneralized point d)) ds) ds

-- generateSigma :: [[ (DataPoint, Double) ]] -> Int -> [[ (DataPoint, Double, Double) ]] 
-- generateSigma x:xs k = 
--   sigmaHelper x k 
--   where
--     sigmaHelper [] k = generateSigma xs k 
--     sigmaHelper (x:xs) k = x : sigmaHelper xs 

-- rho = sortOn snd x !! 1 

-- (sum $ ((\x -> x - rho) x)) / ln(log_2(k))
sigma :: (Enum a, Floating a) => a
sigma = (sum $ (map (\x -> x - rho) x)) / (log (logBase 2 (k)))
  where
    x = [distances]
    k = 4
    rho = 1

distances :: [DataPoint] -> DataPoint -> [(DataPoint, Double)]
distances = map (\x -> (x, euclideanDistanceGeneralized point x))

simScore :: (Enum a, Floating a) => Double -> Double -> a -> Double
simScore dist rho sigma = exp (negate ((dist - rho) / sigma))





-- sigma = (sum distances)/ ln (log_2 (k)) 


-- Finding knn based on the distance matrix

-- practice data
dataset :: DataSet
dataset = [[1.0, 2.0, 3.0], [2.0, 3.0, 4.0], [3.0, 4.0, 5.0], [4.0, 5.0, 6.0], [5.0, 6.0, 7.0], [6.0, 7.0, 8.0], [7.0, 8.0, 9.0]]

dataset2 :: DataSet
dataset2 = [[1..5], [6..10], [11..15],[16..20]]

targetPoint :: DataPoint
targetPoint = [2.5, 3.5, 4.5]

main :: IO ()
main = do
   let distMatrix = distanceMatrix dataset
   mapM_ print distMatrix --mapM is a monadic version of map the underscore ignores the results and simply performs the action to each element of the list but doesnt collect the results.

-- dataset = readFile "dataset.txt"
