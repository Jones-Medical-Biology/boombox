Module Main where 

import System.Exit (exitFailure)
import Test.QuickCheck
import Lib

main :: IO ()
main = do
  quickCheck prop_selfDistance
  quickCheck prop_symmetricDistance
  quickCheck prop_triangleInequality
  quickCheck prop_knnCount
  quickCheck prop_knnSorted

-- Assuming DataPoint is [Double]
type DataPoint = [Double]

-- Property: Distance from a point to itself should be zero
prop_selfDistance :: DataPoint -> Property
prop_selfDistance point = euclideanDistanceGeneralized point point === 0.0

-- Property: Distance is symmetric
prop_symmetricDistance :: DataPoint -> DataPoint -> Property
prop_symmetricDistance p1 p2 = 
  euclideanDistanceGeneralized p1 p2 === euclideanDistanceGeneralized p2 p1

-- Property: Triangle inequality
prop_triangleInequality :: DataPoint -> DataPoint -> DataPoint -> Property
prop_triangleInequality p1 p2 p3 =
  euclideanDistanceGeneralized p1 p3 <= 
  euclideanDistanceGeneralized p1 p2 + euclideanDistanceGeneralized p2 p3

-- Property: Number of returned neighbors is correct
prop_knnCount :: Int -> [DataPoint] -> DataPoint -> Property
prop_knnCount k ds point = k > 0 && not (null ds) ==>
  length (findKNearestNeighbors k ds point) === min k (length ds)

-- Property: Returned neighbors are sorted by distance
prop_knnSorted :: Int -> [DataPoint] -> DataPoint -> Property
prop_knnSorted k ds point = k > 0 && not (null ds) ==>
  let neighbors = findKNearestNeighbors k ds point
  in and $ zipWith (\(_,d1) (_,d2) -> d1 <= d2) neighbors (tail neighbors)
