module Main where
import Text.Read
-- simple program that reads from stdin and prints out the number + 3
main = do
  s <- getLine
  let i = (readMaybe s) :: Maybe Int
  case i of
    Nothing -> putStrLn "User error, enter an int pls"
    Just i -> putStrLn ("n + 3: " <> (show $ i + 3))
