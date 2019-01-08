{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC
  -fprint-explicit-kinds -Wpartial-type-signatures #-}

module Lib
  ( reflex
  ) where

import           Common
import           Control.Applicative ((<$>), (<*>))
import qualified Data.Text           as Text
import           Reflex
import           Reflex.Dom
import           Servant.Reflex
import           ServantClient

reflex :: IO ()
reflex =
  mainWidget $
  el "div" $
        -- babys steps, get users from memory
   do
    intButton <- button "Get Users"
    serverInts <- fmapMaybe reqSuccess <$> getUsers intButton
    display =<< holdDyn ([User "none" "none"]) serverInts
        -- Post a usermessage and display results
    input <- messageInput
    sendMsg <- button "Send Message"
    messages <- fmapMaybe reqSuccess <$> postMessage (Right <$> input) sendMsg
    resulting <-
      holdDyn
        ([Message (User "none" "none") "ddd"]) -- what to show if nothing
        messages -- source of messages (if any)
    _ <- el "div" $ simpleList resulting fancyMsg
    pure ()
  where
    fancyMsg ::
         (MonadWidget t m)
      => Dynamic t Message
      -> m (Element EventResult GhcjsDomSpace t)
    fancyMsg msg =
      elClass "div" "message" $ do
        _ <- elDynHtml' "h1" $ Text.pack . name . from <$> msg
        elDynHtml' "span" $ Text.pack . content <$> msg

messageInput :: (MonadWidget t m) => m (Dynamic t Message)
messageInput = do
  user <- userInput
  message <- labeledInput "message"
  pure $ (Message <$> user) <*> (Text.unpack <$> _textInput_value message)

userInput :: (MonadWidget t m) => m (Dynamic t User)
userInput = do
  username <- labeledInput "username"
  emailInput <- labeledInput "email"
  pure $
    User . Text.unpack <$> _textInput_value username <*>
    (Text.unpack <$> _textInput_value emailInput)

labeledInput :: (MonadWidget t m) => Text.Text -> m (TextInput t)
labeledInput label =
  elClass "div" "field" $ do
    elClass "label" "label" $ text label
    elClass "div" "control" $
      textInput
        (def &
         textInputConfig_attributes .~
         constDyn (Text.pack "class" =: Text.pack "input"))
