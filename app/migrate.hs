-- | Because beam-migrate-cli actually doesn't do anything we access 
-- functionality with this program instead.
-- see:
-- https://github.com/tathougies/beam/issues/249
-- https://github.com/tathougies/beam/issues/242
-- if they ever finish that. We probably should delete this

{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE RecordWildCards #-}

module Main where

import DB
import Database.Beam
import Database.Beam.Migrate
import Database.Beam.Migrate.Backend
import Database.Beam.Migrate.Generics
import Database.Beam.Migrate.Simple
import Database.Beam.Postgres
import qualified Database.Beam.Postgres.Migrate as Postgres (migrationBackend)
import Database.Beam.Migrate.Actions (heuristicSolver)
import Database.Beam.Postgres.Syntax
import qualified Database.PostgreSQL.Simple as Pg
import Data.Monoid((<>))

main :: IO ()
main = do
  conn <- connectPostgreSQL connectionString
  migrate conn
  pure ()


instance Show PgCommandSyntax
-- Got the code mostly from
-- https://github.com/tathougies/beam/issues/154
migrate :: Connection -> IO ()
migrate conn = do
  result <- simpleMigration Postgres.migrationBackend conn migrateDB 
  case result of
    Nothing -> print "oh noes"
    Just x -> print $ x
