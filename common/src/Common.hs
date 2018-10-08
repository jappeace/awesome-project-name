{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}

module Common where

import GHC.Generics(Generic)
import Servant.API
import Data.Proxy
import Data.Aeson(ToJSON, FromJSON)

type ServiceAPI = "api" :> "1.0" :> "users" :> Get '[JSON] [User]
      :<|> "api" :> "1.0" :> "message" :> ReqBody '[JSON] Message :> Post '[JSON] [Message]

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

serviceAPI :: Proxy ServiceAPI
serviceAPI = Proxy

