{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Lib
    ( webAppEntry
    ) where

import Servant
import Common
import Data.Aeson(encode, decode)
import Control.Monad.IO.Class(liftIO)
import Data.ByteString.Lazy as LBS (writeFile, readFile) 
import Network.Wai(Application)
import Network.Wai.Handler.Warp(run)
import           Database.PostgreSQL.Simple   (Connection)
import qualified DB as DB
import           Database.Beam.Backend.SQL.BeamExtensions (runInsertReturningList)

import qualified Database.Beam                            as Beam
import qualified Database.Beam.Postgres                            as PgBeam
import Data.Text(pack, unpack)


users :: [User]
users =
  [ User "Isaac Newton"    "isaac@newton.co.uk"
  , User "Albert Einstein" "ae@mc2.org"
  ]

messages :: Connection -> Message -> Handler [Message]
messages conn message = do 
  messages <- liftIO $ 
    PgBeam.runBeamPostgres conn $ do
      let user = from message
      [user] <- runInsertReturningList (DB._ausers DB.awesomeDB) $ 
          Beam.insertExpressions [DB.User 
            Beam.default_
            (Beam.val_ (pack $ name $ user ))
            (Beam.val_ (pack $ email $ user ))
        ]
      _ <- runInsertReturningList (DB._messages DB.awesomeDB) $ 
          Beam.insertExpressions 
            [DB.Message 
              Beam.default_ 
              (Beam.val_ (Beam.pk user))
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
    ) messages


server :: Connection -> Server UserAPI
server conn=
  (pure users) :<|> (messages conn) :<|> serveDirectoryFileServer "dist-ghcjs/build/x86_64-linux/ghcjs-0.2.1/frontend-0.1.0.0/c/webservice/build/webservice/webservice.jsexe/"

app :: Connection -> Application
app conn = serve userAPI (server conn)

webAppEntry :: Connection -> IO ()
webAppEntry conn = do
  run 6868 (app conn)
