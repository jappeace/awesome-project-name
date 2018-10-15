{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
module Main where

import           Database.PostgreSQL.Simple   (connectPostgreSQL)
import DB(checkedAwesomeDB )
import DB.Cli(postgresOptions, PgConnectionString(..), unConnectionString)

import Database.Beam.Postgres.Migrate (migrationBackend)
import Database.Beam.Migrate.Simple(createSchema)
import           Options.Applicative
import Database.Beam.Postgres (runBeamPostgresDebug)
import Data.Monoid((<>)) -- sauron

main :: IO ()
main = do
  connString <- readSettings
  conn <- connectPostgreSQL $ unConnectionString connString
  runBeamPostgresDebug putStrLn conn $ createSchema migrationBackend checkedAwesomeDB

readSettings :: IO PgConnectionString
readSettings = customExecParser (prefs showHelpOnError) $ info
    (   helper
    <*> postgresOptions
    )
    ( fullDesc <> Options.Applicative.header "Migrations" <> progDesc
      "Schema management"
    )
