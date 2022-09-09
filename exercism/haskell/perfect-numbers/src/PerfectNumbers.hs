module PerfectNumbers (classify, Classification(..)) where

data Classification = Deficient | Perfect | Abundant deriving (Eq, Show)
factors :: Int -> [Int]
-- returns all the factors besides itself
factors 1 = []
factors n = 1: sqrtList ++ secondList
  where root = abs $ round $ sqrt $ realToFrac n
        sqrtList = filter (\x -> (rem n x) == 0) [root, root - 1 .. 2]
        secondList' = map (\a -> n `quot` a) sqrtList
        secondList = if not (null secondList') && head secondList' == root then tail secondList' else secondList'


classify :: Int -> Maybe Classification
classify n
  | n <= 0 = Nothing
  | aliquot == n = Just Perfect
  | aliquot > n = Just Abundant
  | aliquot < n = Just Deficient
  | otherwise = Nothing
  where aliquot = foldl (+) 0 $ factors n
