{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Database.PostgreSQL.Simple   (connectPostgreSQL)
import DB
import Lib
import System.Environment

defaultStaticFolder :: FilePath
defaultStaticFolder
  = "dist-ghcjs/build/x86_64-linux/ghcjs-0.2.1/frontend-0.1.0.0/c/webservice/build/webservice/webservice.jsexe/"

main :: IO ()
main = do
  staticFolder <- flip fmap getArgs $ \case
    [] -> defaultStaticFolder
    arg:_ -> arg
  conn <- connectPostgreSQL connectionString
  webAppEntry conn staticFolder
