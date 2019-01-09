{-# LANGUAGE OverloadedStrings #-}

module Lib
  ( body
  ) where

import           Common
import           Control.Monad  (void)
import           Reflex
import           Reflex.Dom
import           Servant.Reflex
import           ServantClient

body :: MonadWidget t m => m ()
body = do
  nestEvtWidgets

nestEvtWidgets :: MonadWidget t m => m ()
nestEvtWidgets = do
  intButton <- button "Where is the other button?"
  void $ widgetHold (pure ()) $
    (const $ display =<< fancyButton) <$> intButton

fancyButton :: MonadWidget t m => m (Dynamic t String)
fancyButton = do
  intButton <- button "I wonder what will happen?"
  plantRes <- getPlants intButton
  display =<< holdDyn [Plant 4 Nothing] (fmapMaybe reqSuccess plantRes)
  holdDyn "not pressed" $ "pressed" <$ intButton
