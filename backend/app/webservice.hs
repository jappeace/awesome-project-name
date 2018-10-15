{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
module Main where

import           Database.PostgreSQL.Simple (connectPostgreSQL)
import           DB.Cli
import           Lib
import           Options.Applicative

newtype BackendSettings = BackendSettings {
    serveFolder :: FilePath
    }
defaultStaticFolder :: FilePath
defaultStaticFolder
  = "dist-ghcjs/build/x86_64-linux/ghcjs-8.4.0.1/frontend-1.0.0.0/x/webservice/build/webservice/webservice.jsexe"

main :: IO ()
main = do
  (connString, BackendSettings{..}) <- readSettings
  conn <- connectPostgreSQL $ unConnectionString connString
  webAppEntry conn serveFolder

readSettings :: IO (PgConnectionString, BackendSettings)
readSettings = customExecParser (prefs showHelpOnError) $ info
    (   helper
    <*> ((,) <$> postgresOptions <*> backendOptions)
    )
    ( fullDesc <> Options.Applicative.header "Migrations" <> progDesc
      "Running the webservice"
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
