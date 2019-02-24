{-# LANGUAGE OverloadedStrings #-}


-- | Deal with db
module DB.Cli where

import qualified Data.ByteString     as BS
import           Data.Monoid         ((<>))
import           Options.Applicative

defaultConnectionString :: BS.ByteString
defaultConnectionString = "dbname=awesome_db"

newtype PgConnectionString = PgConnectionString { unConnectionString :: BS.ByteString }

postgresOptions :: Parser PgConnectionString
postgresOptions = PgConnectionString <$> strOption
    (  short 'd'
    <> long "database"
    <> metavar "DB_CONNECTION_STRING"
    <> value defaultConnectionString
    <> help "The Postgres database connection string"
    <> showDefault
    )
