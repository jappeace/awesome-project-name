{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}

module Lib
    ( webAppEntry
    ) where

import Servant
import Control.Monad.IO.Class(liftIO)
import Data.ByteString.Lazy as LBS (writeFile, readFile) 
import Data.Aeson(ToJSON, FromJSON, encode, decode)
import GHC.Generics(Generic)
import Network.Wai(Application)
import Network.Wai.Handler.Warp(run)
import           Database.PostgreSQL.Simple   (Connection)
import qualified DB as DB
import           Database.Beam.Backend.SQL.BeamExtensions (runInsertReturningList)

import qualified Database.Beam                            as Beam
import qualified Database.Beam.Postgres                            as PgBeam
import Data.Text(pack, unpack)

type UserAPI = "users" :> Get '[JSON] [User]
      :<|> "message" :> ReqBody '[JSON] Message :> Post '[JSON] [Message]

data Message = Message {
  from :: User,
  content :: String
} deriving (Eq, Show, Generic)

instance ToJSON Message
instance FromJSON Message

data User = User
  { name :: String
  , email :: String
  } deriving (Eq, Show, Generic)

instance ToJSON User
instance FromJSON User

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
      [user] <- runInsertReturningList (DB._users DB.awesomeDB) $ Beam.insertExpressions [DB.User{
            DB._userId = Beam.default_,
            DB._name = Beam.val_ (pack $ name $ user ),
            DB._email = Beam.val_ (pack $ email $ user )
        }]
      _ <- runInsertReturningList (DB._messages DB.awesomeDB) $ Beam.insertExpressions $ [DB.Message{
            DB._messageId = Beam.default_,
            DB._from = Beam.val_ (Beam.pk user),
            DB._content = Beam.val_ (pack $ content message)
        }]
      Beam.runSelectReturningList $ Beam.select $ do 
        usr <- (Beam.all_ (DB._users DB.awesomeDB))
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
server conn= (pure users) :<|> (messages conn)

userAPI :: Proxy UserAPI
userAPI = Proxy

app :: Connection -> Application
app conn = serve userAPI (server conn)

webAppEntry :: Connection -> IO ()
webAppEntry conn = do
  run 6868 (app conn)
