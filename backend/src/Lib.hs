{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

{-# OPTIONS_GHC -Wno-missing-monadfail-instances #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}


module Lib
    ( webAppEntry, ApiSettings(..)
    ) where

import           Common
import           Control.Monad.IO.Class                   (liftIO)
import           Network.Wai                              (Application)
import qualified Network.Wai                              as Wai
import           Network.Wai.Handler.Warp                 (run)
import qualified Network.Wai.Middleware.Gzip              as Wai
import           Servant

import           Database.Beam.Backend.SQL.BeamExtensions (runInsertReturningList)
import           Database.PostgreSQL.Simple               (Connection)
import qualified DB                                       as DB

import           Data.Text                                (pack, unpack)
import qualified Database.Beam                            as Beam
import qualified Database.Beam.Postgres                   as PgBeam
import           Servant.Auth.Server

type Webservice = ServiceAPI
      :<|> Raw -- JS entry point

webservice :: Proxy Webservice
webservice = Proxy

users :: [User]
users =
  [ User "Isaac Newton"    "isaac@newton.co.uk"
  , User "Albert Einstein" "ae@mc2.org"
  ]

messages :: Connection -> Message -> Handler [Message]
messages conn message = do
  fromDb <- liftIO $
    PgBeam.runBeamPostgres conn $ do
      let user = from message
      [foundUser] <- runInsertReturningList (DB._ausers DB.awesomeDB) $
          Beam.insertExpressions [DB.User
            Beam.default_
            (Beam.val_ (pack $ name $ user ))
            (Beam.val_ (pack $ email $ user ))
        ]
      _ <- runInsertReturningList (DB._messages DB.awesomeDB) $
          Beam.insertExpressions
            [DB.Message
              Beam.default_
              (Beam.val_ (Beam.pk foundUser))
              (Beam.val_ (pack $ content message))
            ]
      Beam.runSelectReturningList $ Beam.select $ do
        usr <- (Beam.all_ (DB._ausers DB.awesomeDB))
        msg <- Beam.oneToMany_ (DB._messages DB.awesomeDB) DB._from usr
        pure (msg, usr)
  pure $
    fmap (
      \(msg, usr) -> Message
        (User
          (unpack $ DB._name usr)
          (unpack $ DB._email usr))
        (unpack $ DB._content msg)
    ) fromDb

login :: ApiSettings -> User -> Handler (AuthCookies NoContent)
login settings user = if elem user users then do
    withCookies <- liftIO $ acceptLogin cookies (jwtSettings settings) user
    pure $ maybe (clearSession cookies NoContent) (\x -> x NoContent) withCookies
  else throwAll err401 -- unauthorized
  where
    cookies = cookieSettings settings

server :: ApiSettings -> FilePath -> Server Webservice
server settings staticFolder =
  (login settings :<|> authenticatedServer settings) :<|> serveDirectoryFileServer staticFolder

authenticatedServer :: ApiSettings -> AuthResult User -> Server AuthAPI
authenticatedServer settings (Authenticated _) =
    (pure users :<|> messages (connection settings))
authenticatedServer _ _ = throwAll err401 -- unauthorized

app :: ApiSettings -> FilePath -> Application
app settings staticFolder =
  serveWithContext webservice context $ server settings staticFolder
  where
    context = cookieSettings settings :. jwtSettings settings :. EmptyContext

webAppEntry :: ApiSettings -> FilePath -> IO ()
webAppEntry settings staticFolder = run 6868 $ compress $ app settings staticFolder

compress :: Wai.Middleware
compress = Wai.gzip Wai.def { Wai.gzipFiles = Wai.GzipCompress }

data ApiSettings = ApiSettings
  { cookieSettings :: CookieSettings
  , jwtSettings    :: JWTSettings
  , connection     :: Connection
  }

-- doesn't make sense client side
instance ToJWT User
instance FromJWT User
