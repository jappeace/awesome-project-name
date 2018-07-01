{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Database.PostgreSQL.Simple   (connectPostgreSQL)

import Lib

main :: IO ()
main = do
  conn <- connectPostgreSQL "dbname=awesome_db"
  webAppEntry conn
