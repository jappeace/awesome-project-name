{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

{-# OPTIONS_GHC -Wno-missing-monadfail-instances #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}


module Awe.Back.Render
    ( renderHtmlEndpoint
    ) where

import           Awe.Common
import           Awe.Front.Main
import           Control.Monad.IO.Class    (liftIO)
import qualified Data.ByteString           as BS
import           Reflex.Bulmex.Html        (HeadSettings, htmlWidget)
import           Reflex.Dom.Builder.Static
import           Servant
import           Servant.Auth.Server

renderHtmlEndpoint :: HeadSettings -> AuthResult User -> Handler BS.ByteString
renderHtmlEndpoint settings authRes = do
  liftIO $ do
    putStrLn "authres is"
    print authRes
  fmap snd $ liftIO $ renderStatic $
    htmlWidget settings $ main $ IniState $ toMaybe authRes

toMaybe :: AuthResult User -> Maybe User
toMaybe (Authenticated auth) = Just auth
toMaybe _                    = Nothing
