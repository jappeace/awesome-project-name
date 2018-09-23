{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Database.PostgreSQL.Simple   (connectPostgreSQL)
import DB
import Lib

main :: IO ()
main = do
  conn <- connectPostgreSQL connectionString
  webAppEntry conn
