module Umap ( dataset
            , kNearestNeighbors
            , DataPoint
            , DataSet
            ) where

import Data.List (sortOn)
import Control.Parallel.Strategies
import Control.DeepSeq (NFData)
import Data.ByteString (zipWith)

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
-- !!!!!! Generate Sigma Matrix From Rho Matrix (and distance matrix and k) (see below)
sigma :: (Enum a, Floating a) => a -> [a] -> [a] -> a
sigma k dists rhos = (sum $ (zipWith (\x y -> x - y) dists rhos)) / (log (logBase 2 (k)))
sigmas :: (Enum a, Floating a) => a -> [a] -> [a]
sigmas sigma dists = replicate distsLength sigma
  where
    distsLength = length dists

-- !!!!!!!!!! Output is a list, needs to be a matrix.
sigmaMat :: (Enum c, Floating c) => c -> [[(a,c)]] -> [[c]] -> [[c]]
sigmaMat k distMat rhoMat = zipWith (sigma k) distMatrix rhoMat
  where
    distMatrix = map (map snd) distMat

distances :: [DataPoint] -> DataPoint -> [(DataPoint, Double)]
distances = map (\x -> (x, euclideanDistanceGeneralized point x))

simScore :: (Enum a, Floating a) => Double -> Double -> a -> Double
simScore dist rho sigma = exp (negate ((dist - rho) / sigma))

-- !!!!!!!!!!!!!!! Need to generate simscore matrix
simScoreMat :: [[(a,c)]] -> [[c]] -> [[c]] -> [[c]]
simScoreMat distMat rhoMat sigmaMat = --simScoreMatrix
-- change rho to rhos (bc this change was made in sigma above)

-- !!!!!!!!!!!!!! Type system !!!!!!! Research goal creative!  
-- *** simScoreMat :: [[(a,c)]] -> [[Rho]] -> [[Sigma]] -> [[SimScore]]
  
distMatToRhos ::[[(a, b)]] -> [b] 
distMatToRhos = map (\a -> snd (a !! 1)) 

widthRho :: [[(a,b)]] -> Int
widthRho (x:_) = length x 
-- distanceMatrix :: [[(a,b)]]
-- [[(a,b)]] => [a]

distMatToRhoMat :: [[(a,b)]]-> [[b]]
distMatToRhoMat distMat = matrixFromList (distMatToRhos distMat) (widthRho distMat) 

matrixFromList :: [a] -> Int -> [[a]]
matrixFromList [] _ = []
matrixFromList (x:xs) n = replicate n x : matrixFromList xs n

-- generate our [a] which is our list of rho or list of sigma
-- Rho: we can get it by taking the first element !! 1 of each row in the matrix
-- then, use the zip function that we created that has type [[a]] -> [[a]] -> [[a]]
-- after rho matrix has been subtracted from dist matrix, divide result by sigma?
-- apply simScore to each element within matrix 
-- fxn that takes in 3 matrices (sigma, rho, dist) 



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
