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
messageFile :: FilePath
messageFile = "messages.txt"

messages :: Connection -> Message -> Handler [Message]
messages connection message = do 
  result <- liftIO $ LBS.readFile messageFile
  case decode result of
    Nothing -> pure []
    Just x -> do
      let contents = x ++ [message]
      liftIO $ LBS.writeFile messageFile (encode contents)
      return contents

server :: Connection -> Server UserAPI
server conn= (pure users) :<|> (messages conn)

userAPI :: Proxy UserAPI
userAPI = Proxy

app :: Connection -> Application
app conn = serve userAPI (server conn)

webAppEntry :: Connection -> IO ()
webAppEntry conn = do
  run 6868 (app conn)
