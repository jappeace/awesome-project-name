{-# LANGUAGE OverloadedStrings     #-}


-- | Deal with db
module DB.Cli where

import qualified Data.ByteString as BS
import Options.Applicative
import Data.Monoid((<>)) -- sauron

defaultConnectionString :: BS.ByteString
defaultConnectionString = "dbname=raster_db"

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
