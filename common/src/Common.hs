{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}

module Common where

import           Data.Aeson   (FromJSON, ToJSON)
import           Data.Proxy
import           GHC.Generics (Generic)
import           Servant.API

type ServiceAPI =
          "api" :> "1.0" :> "users" :> Get '[JSON] [User]
      :<|> "api" :> "1.0" :> "message" :> ReqBody '[JSON] Message :> Post '[JSON] [Message]

data Message = Message {
  from    :: User,
  content :: String
} deriving (Eq, Show, Generic)

instance ToJSON Message
instance FromJSON Message

data User = User
  { name  :: String
  , email :: String
  } deriving (Eq, Show, Generic)

instance ToJSON User
instance FromJSON User

serviceAPI :: Proxy ServiceAPI
serviceAPI = Proxy

