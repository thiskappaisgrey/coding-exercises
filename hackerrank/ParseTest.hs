-- parses my special test-file format
{-# LANGUAGE OverloadedStrings #-}
module ParseTest ( Test(..) , parseTestsFile , parseTests  ) where

import Data.Text (pack, Text, append)
import Data.Attoparsec.Text
import Data.Attoparsec.Combinator (lookAhead)
import Control.Applicative ((<|>))
import qualified Data.Text.IO as TI
-- a test case has 3 parts:
-- 1. name
-- 2. input
-- 3. expected output
-- I can write this in another module but I want everything in 1 module for simplicity
-- see testcase.tst for example syntax

data Test = Test {

  test_name :: Text
  , test_input :: Text
  , test_exp_output :: Text
                 } deriving Show

between :: Parser open -> Parser close -> Parser a -> Parser a
between open close p = open >> p >>= (\a -> close >> return a)

-- TODO I could use less "skipSpaces".. I can also write this applicative style if I wanted to refactor
testParser :: Parser Test
testParser =  between (string "--" >> skipSpace)  (skipSpace >> string "--") $ do
  _ <- string "name:"
  skipSpace
  -- TODO unsnoc to get rid of trailing newline
  name <- takeSection
  skipSpace
  _ <- string "input:"
  skipSpace
  input <- takeSection
  skipSpace
  _ <- string "output:"
  skipSpace
  output <- takeSection
  skipSpace
  return $ Test name input output
  where
    takeSection = between  (string "[-" >> skipSpace) (skipSpace >> string "-]") $ takeBetweenBrackets
    -- I guess "do" is fine here, since I need to bind "t" anyways
    -- according to doc, manyTill anyChar (string "-->")  is inefficient so I wrote it like this instead.. don't know if it's any better..
    takeBetweenBrackets = do
      t <- takeTill (== '-')
      (lookAhead (string "-]") >> return t) <|>  (append (append t "-") <$> (char '-' >> takeBetweenBrackets) )

  
testsParser :: Parser [Test]
testsParser = do
  a <- many' (between skipSpace skipSpace testParser)
  endOfInput
  return a
  

parseTests :: Text -> Either String [Test]
parseTests  = parseOnly testsParser 

parseTestsFile :: FilePath -> IO (Either String [Test])
parseTestsFile f = TI.readFile f >>= return . parseTests
