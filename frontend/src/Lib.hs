{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fprint-explicit-kinds -Wpartial-type-signatures #-}


module Lib
  ( reflex
  ) where
import Reflex
import Reflex.Dom
import Data.Map (Map)
import qualified Data.Map as Map
import qualified Data.Text as Text
import Text.Read (readMaybe)
import Control.Applicative ((<*>), (<$>))
import Common
import Servant.Reflex
import Data.Proxy
import Control.Monad(join)
import Data.Monoid((<>)) -- sauron
import ServantClient

reflex :: IO()
reflex = do

  mainWidget $
    el "div" $ do
        intButton  <- button "Get Users"
        serverInts <- fmapMaybe reqSuccess <$> getUsers intButton
        name <- textInput def
        email <- textInput def
        dynText $ _textInput_value email
        display =<< holdDyn ([User "none" "none"]) serverInts
        input <- messageInput 
        sendMsg <- button "Send Message"
        messages <- fmapMaybe reqSuccess <$> postMessage (Right <$> input) sendMsg 
        resulting <- holdDyn ([Message (User "none" "none") "ddd"]) messages
        el "div" $
            simpleList resulting fancyMsg 
        pure ()
  where
    fancyMsg :: (MonadWidget t m) => Dynamic t Message -> m (Element EventResult GhcjsDomSpace t)
    fancyMsg msg = elClass "div" "message" $ do
        elDynHtml' "h1" $ Text.pack . name . from <$> msg
        elDynHtml' "span" $ Text.pack . content <$> msg

messageInput :: (MonadWidget t m) => m (Dynamic t Message)
messageInput = do
    user <- userInput
    message <- labeledInput "message"
    pure $ (Message <$> user) <*> (Text.unpack <$> _textInput_value message)

userInput :: (MonadWidget t m) => m (Dynamic t User)
userInput = do
        username <- labeledInput "username"
        email <- labeledInput "email"
        pure $ User . Text.unpack <$> _textInput_value username <*> (Text.unpack <$> _textInput_value email)

labeledInput :: (MonadWidget t m) => Text.Text -> m (TextInput t)
labeledInput label = elClass "div" "field" $ do
    elClass "label" "label" $ text label
    elClass "div" "control" $ textInput (def & textInputConfig_attributes .~ constDyn (Text.pack "class" =: Text.pack "input"))
