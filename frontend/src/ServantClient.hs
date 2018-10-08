{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TypeApplications #-}
{-# OPTIONS_GHC -Wno-partial-type-signatures #-}


{-# LANGUAGE NoMonomorphismRestriction          #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE  TypeApplications #-}
{-# LANGUAGE TypeOperators #-}

-- | This modules purpose is just to generate the xhr clients.
--   there is some type magick going on generating these,
--   therefore the functions are isolated.
module ServantClient
  ( postMessage, getUsers 
  ) where


import Reflex
import Reflex.Dom
import Data.Map (Map)
import qualified Data.Map as Map
import qualified Data.Text as Text
import Text.Read (readMaybe)
import Control.Applicative ((<*>), (<$>))
import Servant.API
import Common
import Servant.Reflex
import Data.Proxy
import Control.Monad(join)
import Data.Monoid((<>)) -- sauron

-- | The typesignature of this function is ridiculous, let's just ignore it
--   This intermediate definition is necisarry because the @m is similar for both clients,
--   they have the same wrapping monad however the containing type is different
--   (which is why we have the nomonomorphism restirction disabled)
apiClients :: forall t m. (MonadWidget t m) => _
apiClients = client serviceAPI (Proxy @m) (Proxy @()) (constDyn url)
  where url :: BaseUrl
        url = BasePath "/"

getUsers :: MonadWidget t m
          => Event t ()  -- ^ Trigger the XHR Request
          -> m (Event t (ReqResult () [User])) -- ^ Consume the answer
postMessage :: MonadWidget t m
            => Dynamic t (Either Text.Text Message)
            -> Event t ()
            -> m (Event t (ReqResult () [Message]))
(getUsers :<|> postMessage) = apiClients
