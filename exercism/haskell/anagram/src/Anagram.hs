module Anagram (anagramsFor) where
-- import Debug.Trace
import Data.Char

checkAnagram :: String -> String -> Bool
-- for each character in the check string, check if it's in the given string. If it is, remove the character from the string
checkAnagram [] [] = True
checkAnagram _ [] = False
checkAnagram given (c:rst) =
  let
    (check, rest) = checkChar c (False, given)
  in
    if check == False then False else
    checkAnagram rest rst


checkChar :: Char -> (Bool, String) -> (Bool, String)
checkChar _ (found, []) = (found, [])
checkChar c (found, h:str)
  | (toLower c == toLower h && (not found)) = (True, str)
  | otherwise = let
      (f, n) =  checkChar c (found, str)
      in
      (f, h:n)
anagramsFor :: String -> [String] -> [String]
-- I guess I can clean this up by making the checkAnagram function a helper but oh well..
anagramsFor xs xss = filter (\s -> if map toLower s == map toLower xs then False else checkAnagram xs s) xss
