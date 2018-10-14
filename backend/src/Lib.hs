{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

{-# OPTIONS_GHC -Wno-missing-monadfail-instances #-}


module Lib
    ( webAppEntry
    ) where

import Servant
import Common
import Control.Monad.IO.Class(liftIO)
import Network.Wai(Application)
import Network.Wai.Handler.Warp(run)
import qualified Network.Wai as Wai
import qualified Network.Wai.Middleware.Gzip as Wai

import           Database.PostgreSQL.Simple   (Connection)
import qualified DB as DB
import           Database.Beam.Backend.SQL.BeamExtensions (runInsertReturningList)

import qualified Database.Beam                            as Beam
import qualified Database.Beam.Postgres                            as PgBeam
import Data.Text(pack, unpack)

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


server :: Connection -> FilePath -> Server Webservice
server conn staticFolder =
  (pure users :<|> messages conn) :<|> serveDirectoryFileServer staticFolder

app :: Connection -> FilePath -> Application
app conn staticFolder = serve webservice (server conn staticFolder)

webAppEntry :: Connection -> FilePath -> IO ()
webAppEntry conn staticFolder = run 6868 $ compress $ app conn staticFolder

compress :: Wai.Middleware
compress = Wai.gzip Wai.def { Wai.gzipFiles = Wai.GzipCompress }