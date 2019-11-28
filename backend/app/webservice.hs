{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Main where

import           Awe.Back.DB.Cli
import           Awe.Back.Web
import           Data.Maybe
import           Data.Time
import           Database.PostgreSQL.Simple (connectPostgreSQL)
import           Network.URI
import           Options.Applicative
import           Reflex.Bulmex.Html
import           Servant.Auth.Server

newtype BackendSettings = BackendSettings
  { serveFolder :: FilePath
  }

defaultStaticFolder :: FilePath
defaultStaticFolder =
  "dist-ghcjs/build/x86_64-linux/ghcjs-8.4.0.1/frontend-1.0.0.0/x/webservice/build/webservice/webservice.jsexe"

main :: IO ()
main = do
  (connString, BackendSettings {..}) <- readSettings
  conn <- connectPostgreSQL $ unConnectionString connString
  jwtKey <- generateKey
  let
    settings = ApiSettings
      { cookieSettings = cookieConf
      , jwtSettings    = defaultJWTSettings jwtKey
      , connection     = conn
      , headSettings   =
        HeadSettings
          { _head_js    =
            [ defScript
                { _script_uri = fromMaybe (error "could not parse uri all.js")
                                  $ parseURIReference "all.js"
                }
            ]
          , _head_css   = []
          , _head_title = "awesomeproj"
          }
      }
  webAppEntry settings serveFolder
 where
  cookieConf = defaultCookieSettings
    { cookieIsSecure    = NotSecure -- allow setting of cookies over http, the reason for this is that we should stop providing http support, *or*, give all features on http.
    , cookieMaxAge      = Just $ secondsToDiffTime $ 60 * 60 * 24 * 365
    , cookieXsrfSetting = Nothing
    }

readSettings :: IO (PgConnectionString, BackendSettings)
readSettings = customExecParser (prefs showHelpOnError) $ info
  (helper <*> ((,) <$> postgresOptions <*> backendOptions))
  (fullDesc <> Options.Applicative.header "Migrations" <> progDesc
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
