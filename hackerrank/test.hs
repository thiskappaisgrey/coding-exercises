#!/usr/bin/env nix-shell
#!nix-shell -i runhaskell
{-# LANGUAGE OverloadedStrings  #-}

-- TODO write a shell script that automatically compiles and diff the output with a test case
-- TODO automatically parse a test cases file, compile the program and run it against the test cases, and do a diff

import Turtle -- hiding (FilePath)
import qualified Data.Text.IO as T
import Data.Text (pack, Text)
import ParseTest  
 
import Prelude hiding (FilePath)
import Data.Either (fromRight)
import Data.Maybe (fromMaybe)
import qualified Control.Foldl as F
          
parser :: Parser (Maybe FilePath) --  (FilePath, FilePath)
parser = optional $  argPath "dir" "Directory to search for progs + tests"

-- convention is to have test case have the same name as the program you are testing
-- outputs (program, test)
getProgramAndTestCaseFiles :: FilePath -> IO [(FilePath, FilePath)]
getProgramAndTestCaseFiles path = reduce F.list $ do
  p <- ls path
  -- TODO maybe also allow the user to pick what extension to use?
  let e = extension p
  guard (testExtension e)
  -- check if test file exists
  let tstf = dropExtension p <.> "tst"
  True <- liftIO (testfile tstf)
  return (p, tstf)
    where
      -- TODO maybe also check from a list of valid extensions
      testExtension :: Maybe Text -> Bool
      testExtension (Just "tst")  = False
      testExtension Nothing = False
      testExtension _ = True
      
  
    
    -- file <- ls path
  

-- A run function consists of a FilePath, the inputs to the program and outputs something 
type RunFn = FilePath -> Text -> Shell Line
-- the turtle available in nix is 1.5.25, so I have to use "encodeString"..
-- Create a run function from a command
createRunFn :: Text -> RunFn
createRunFn command  = (\file input -> inproc command [pack $ encodeString file] (toLines $ pure input))
  
-- I can support many run fns here
getRunFn :: FilePath -> RunFn
getRunFn file =
  let
    ext = extension file
  in
    case ext of
      (Just "hs") -> createRunFn "runhaskell"
      (Just "py") -> createRunFn "python3"
      Nothing -> \_ _ ->  return (unsafeTextToLine "Test function not implemented")


--  1. For each test, run the program with the input as stdin
--  2. Run diff on the output of the program against the expected output
--  3. Print whether the test passes or fails
runTestCase :: RunFn ->  (FilePath, FilePath)  -> IO ()
runTestCase progRunAction (progPath, testPath)  =
  sh $ do
  etests <- liftIO $ parseTestsFile $ encodeString testPath
  -- the ">> return []" is for the type checker
  tests <- either (\a -> fail a >> return []) return etests
  -- liftIO
  let p = unsafeTextToLine $ fromRight "" $ toText progPath
  echo ("Testing " <> p)
  mapM_  runTest tests
  where
    runTest :: Test -> Shell ()
    runTest (Test name input exp_out) = 
      do
        let output =  progRunAction progPath input
        -- if there's a race condition bug with mktempfile, then maybe I'll use mktmp instead
        outFile <- mktempfile "/tmp" "testExpOut" 
        liftIO $ writeTextFile outFile exp_out
        ec <- proc "diff" ["--color", fromRight "" $ toText outFile , "-"] output
        -- TODO colored output would be nice..
        case ec of
          ExitSuccess ->  liftIO $ T.putStrLn $ "Test: " <> name <> " succeeded!"
          ExitFailure 1 -> liftIO $ T.putStrLn $ "Test: " <> name <> " failed, expected output and program output do not match!"
          ExitFailure n -> printf "Something went wrong with diff, please check your files"


main :: IO ()  
main = do
  mpath <- options "Test script - run tests cases for programming exercises. \n See ./example/hello-world.tst to see how to write test cases" parser
  -- default is current directory
  let path = fromMaybe "." mpath 
  s <- stat path
  when (not $ isDirectory s) $ fail "User error, run this script on directories not files."
  f <- getProgramAndTestCaseFiles path
  -- print f
  -- TODO pick the right test func based on extension 
  mapM_ (\files -> runTestCase (getRunFn $ fst files) files) f

  
