module Acronym (abbreviate) where
import qualified Data.Text as T
import           Data.Text (Text)
import           Data.Char (isSpace, isUpper, ord)

getAbbrevFromWord :: Text -> Text
getAbbrevFromWord word = T.cons  (T.head word)  (if (T.length camelAbbrev + 1 == T.length word) then T.empty else camelAbbrev)
  where camelAbbrev = T.filter isUpper $ T.tail word
abbreviate :: Text -> Text
abbreviate xs = T.toUpper $ foldl (\t t1 -> T.append t $ getAbbrevFromWord t1) T.empty $ wordList
  where isSep x = isSpace x || ord x == ord '-' || ord x == ord '_'
        wordList = filter (\t -> t /= T.empty) $ T.split isSep xs
