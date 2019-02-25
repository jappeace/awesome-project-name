{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}

module Common where

import           Data.Aeson   (FromJSON, ToJSON)
import           Data.Proxy
import           GHC.Generics (Generic)
import           Servant.API
import           Servant.Auth
import           Web.Cookie

type ServiceAPI = PublicAPI :<|> Auth '[Cookie, JWT] User :> AuthAPI

type CookieHeader = Header "Set-Cookie" SetCookie
type OptCookieHeader = Header' [Optional, Strict] "Set-Cookie" SetCookie
type AuthCookies a = Headers '[CookieHeader, OptCookieHeader] a

type PublicAPI = "api" :> "1.0" :> "login" :> ReqBody '[JSON] User :> Post '[JSON] (AuthCookies NoContent)

type AuthAPI =
          "api" :> "1.0" :> "me" :> Get '[JSON] User
      :<|> "api" :> "1.0" :> "users" :> Get '[JSON] [User]
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


