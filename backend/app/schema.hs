{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Awe.Back.DB                    ( checkedAwesomeDB )
import           Awe.Back.DB.Cli                ( PgConnectionString(..)
                                                , postgresOptions
                                                , unConnectionString
                                                )
import           Database.PostgreSQL.Simple     ( connectPostgreSQL )

import           Data.Monoid                    ( (<>) )
import           Database.Beam.Migrate.Simple   ( createSchema )
import           Database.Beam.Postgres         ( runBeamPostgresDebug )
import           Database.Beam.Postgres.Migrate ( migrationBackend )
import           Options.Applicative

main :: IO ()
main = do
  connString <- readSettings
  conn       <- connectPostgreSQL $ unConnectionString connString
  runBeamPostgresDebug putStrLn conn
    $ createSchema migrationBackend checkedAwesomeDB

readSettings :: IO PgConnectionString
readSettings = customExecParser (prefs showHelpOnError) $ info
  (helper <*> postgresOptions)
  (fullDesc <> Options.Applicative.header "Migrations" <> progDesc
    "Schema management"
  )
