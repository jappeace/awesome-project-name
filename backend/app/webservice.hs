{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Database.PostgreSQL.Simple   (connectPostgreSQL)
import DB
import Lib
import System.Environment
import DB.Cli

newtype BackendSettings = BackendSettings {
    serveFolder :: Maybe FilePath
    }
defaultStaticFolder :: FilePath
defaultStaticFolder
  = "dist-ghcjs/build/x86_64-linux/ghcjs-0.2.1/frontend-1.0.0.0/c/webservice/build/webservice/webservice.jsexe/"

main :: IO ()
main = do
  staticFolder <- flip fmap getArgs $ \case
    [] -> defaultStaticFolder
    arg:_ -> arg
  conn <- connectPostgreSQL connectionString
  webAppEntry conn staticFolder

readSettings :: IO (PgConnectionString, BackendSettings)
readSettings = customExecParser (prefs showHelpOnError) $ info
    (   helper
    <*> (,) <$> postgresOptions <*> backendOptions
    )
    ( fullDesc <> Options.Applicative.header "Migrations" <> progDesc
      "Schema management"
    )
backendOptions :: Parser BackendSettings 
backendOptions = BackendSettings <$> strOption
    (  short 's'
    <> long "static-folder"
    <> metavar "STATIC_FOLDER_DIR"
    <> value defaultStaticFolder
    <> help "The Postgres database connection string"
    <> showDefault
    )
