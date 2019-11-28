{-# LANGUAGE AllowAmbiguousTypes       #-}
{-# LANGUAGE OverloadedStrings         #-}
{-# LANGUAGE RankNTypes                #-}
{-# LANGUAGE TypeApplications          #-}

{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE PartialTypeSignatures     #-}
{-# LANGUAGE ScopedTypeVariables       #-}
{-# LANGUAGE TypeOperators             #-}

{-# OPTIONS_GHC  -Wno-partial-type-signatures #-}
{-# OPTIONS_GHC  -Wno-simplifiable-class-constraints #-}

-- | This modules purpose is just to generate the xhr clients.
--   there is some type magick going on generating these,
--   therefore the functions are isolated.
module Awe.Front.ServantClient
  ( postMessage, getUsers, postLogin, getMe
  ) where

import           Awe.Common
import           Awe.Common.Xsrf
import           Control.Lens
import           Data.Proxy
import qualified Data.Text                as Text
import           JSDOM                    (currentDocument)
import qualified JSDOM.Generated.Document as Doc
import           JSDOM.Types              (JSM)
import           Reflex
import           Reflex.Dom
import           Servant.API
import           Servant.Reflex


getCookies :: JSM (Maybe Text.Text)
getCookies =
  currentDocument >>=
    maybe (pure Nothing) (fmap Just . Doc.getCookie)

-- | find the cookie from the cookie string
findCookie :: Text.Text -> JSM (Maybe Text.Text)
findCookie which = do
  mayCookies <- getCookies
  case mayCookies of
    Nothing -> pure Nothing
    Just cookies ->
      pure $ Just $ Text.takeWhile ((/=) ';') $ Text.drop 1 $ Text.dropWhile ((/=) '=') $ snd $ Text.breakOn which cookies

clientOpts :: ClientOptions
clientOpts = ClientOptions $ tweakReq
  where
    tweakReq r = do
      mayCookie <- findCookie cookieName
      return $ r & headerMod headerName .~ mayCookie -- forgive lenses
    headerMod d = xhrRequest_config . xhrRequestConfig_headers . at d

-- | This intermediate definition is necisarry because the @m is similar for both clients,
--   they have the same wrapping monad however the containing type is different
--   (which is why we have the nomonomorphism restirction disabled)
apiClients :: forall t m. (MonadWidget t m) => _
apiClients = clientWithOpts serviceAPI (Proxy @m) (Proxy @()) (constDyn url) clientOpts
  where url :: BaseUrl
        url = BasePath "/"

postLogin :: (DomBuilder t m, Prerender js t m)
          => Dynamic t (Either Text.Text User)
          -> Event t ()
          -> m (Event t (ReqResult () (AuthCookies NoContent)))
postLogin dd yy = fmap switchDyn $ prerender (pure never) $ postLogin' dd yy

getUsers :: (DomBuilder t m, Prerender js t m)
          => Event t ()
          -> m (Event t (ReqResult () [User]))
getUsers dd = fmap switchDyn $ prerender (pure never) $ getUsers' dd

getMe :: (DomBuilder t m, Prerender js t m)
          => Event t ()
          -> m (Event t (ReqResult () User))
getMe dd = fmap switchDyn $ prerender (pure never) $ getMe' dd

postMessage :: (DomBuilder t m, Prerender js t m)
            => Dynamic t (Either Text.Text Message)
            -> Event t ()
            -> m (Event t (ReqResult () [Message]))
postMessage dd yy = fmap switchDyn $ prerender (pure never) $ postMessage' dd yy

postLogin' :: MonadWidget t m
          => Dynamic t (Either Text.Text User)
          -> Event t ()
          -> m (Event t (ReqResult () (AuthCookies NoContent)))
getUsers' :: MonadWidget t m
          => Event t ()
          -> m (Event t (ReqResult () [User]))
getMe' :: MonadWidget t m
          => Event t ()
          -> m (Event t (ReqResult () User))
postMessage' :: MonadWidget t m
            => Dynamic t (Either Text.Text Message)
            -> Event t ()
            -> m (Event t (ReqResult () [Message]))
(postLogin' :<|> (getMe' :<|> getUsers' :<|> postMessage')) = apiClients
