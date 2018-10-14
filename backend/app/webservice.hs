{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Database.PostgreSQL.Simple   (connectPostgreSQL)
import DB
import Lib
import System.Environment

defaultStaticFolder :: FilePath
defaultStaticFolder
  = "dist-ghcjs/build/x86_64-linux/ghcjs-8.4.0.1/frontend-1.0.0.0/x/webservice/build/webservice/webservice.jsexe"

main :: IO ()
main = do
  staticFolder <- flip fmap getArgs $ \case
    [] -> defaultStaticFolder
    arg:_ -> arg
  conn <- connectPostgreSQL connectionString
  webAppEntry conn staticFolder
