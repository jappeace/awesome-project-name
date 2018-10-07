{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}

module Common where

import GHC.Generics(Generic)
import Servant.API
import Data.Proxy
import Data.Aeson(ToJSON, FromJSON)
type UserAPI = "api" :> "v0.0" :> "users" :> Get '[JSON] [User]
      :<|> "api" :> "v0.0" :> "message" :> ReqBody '[JSON] Message :> Post '[JSON] [Message]
      :<|> Raw -- JS entry point

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

userAPI :: Proxy UserAPI
userAPI = Proxy
