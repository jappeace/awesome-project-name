{-# LANGUAGE AllowAmbiguousTypes       #-}
{-# LANGUAGE OverloadedStrings         #-}
{-# LANGUAGE RankNTypes                #-}
{-# LANGUAGE TypeApplications          #-}

{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE PartialTypeSignatures     #-}
{-# LANGUAGE ScopedTypeVariables       #-}
{-# LANGUAGE TypeOperators             #-}

{-# OPTIONS_GHC  -Wno-partial-type-signatures #-}

-- | This modules purpose is just to generate the xhr clients.
--   there is some type magick going on generating these,
--   therefore the functions are isolated.
module ServantClient
  ( postMessage, getUsers, postLogin, getMe
  ) where

import           Common
import           Data.Proxy
import qualified Data.Text      as Text
import           Orphanage      ()
import           Reflex
import           Reflex.Dom
import           Servant.API
import           Servant.Reflex

-- | This intermediate definition is necisarry because the @m is similar for both clients,
--   they have the same wrapping monad however the containing type is different
--   (which is why we have the nomonomorphism restirction disabled)
apiClients :: forall t m. (MonadWidget t m) => _
apiClients = client serviceAPI (Proxy @m) (Proxy @()) (constDyn url)
  where url :: BaseUrl
        url = BasePath "/"

postLogin :: MonadWidget t m
          => Dynamic t (Either Text.Text User)
          -> Event t ()
          -> m (Event t (ReqResult () (AuthCookies NoContent)))
getUsers :: MonadWidget t m
          => Event t ()
          -> m (Event t (ReqResult () [User]))
getMe :: MonadWidget t m
          => Event t ()
          -> m (Event t (ReqResult () User))
postMessage :: MonadWidget t m
            => Dynamic t (Either Text.Text Message)
            -> Event t ()
            -> m (Event t (ReqResult () [Message]))
(postLogin :<|> (getMe :<|> getUsers :<|> postMessage)) = apiClients
