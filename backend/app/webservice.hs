{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
module Main where

import           Data.Time
import           Database.PostgreSQL.Simple (connectPostgreSQL)
import           DB.Cli
import           Lib
import           Options.Applicative
import           Servant.Auth.Server

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
  jwtKey <- generateKey
  let settings = ApiSettings
        { cookieSettings = cookieConf
        , jwtSettings    = defaultJWTSettings jwtKey
        , connection     = conn
        }
  webAppEntry settings serveFolder
    where
    cookieConf =
      defaultCookieSettings
        { cookieIsSecure = NotSecure -- allow setting of cookies over http, the reason for this is that we should stop providing http support, *or*, give all features on http.
        , cookieXsrfSetting = Nothing
        -- ^ TODO add xsrf protection https://github.com/haskell-servant/servant-auth#xsrf-and-the-frontend
        -- last time I tried adding it it disabled permeneant cookies, dunno why
        , cookieMaxAge = Just $ secondsToDiffTime $ 60 * 60 * 24 * 365
        }

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
