{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo       #-}

module Lib
  ( reflex
  ) where

import           Common
import           Control.Applicative ((<$>), (<*>))
import           Control.Monad       (void)
import qualified Data.Map            as Map
import qualified Data.Text           as Text
import           Helpers             (flash, holdEvent)
import           Reflex
import           Reflex.Dom
import           Servant.Reflex
import           ServantClient

hidden :: Map.Map Text.Text Text.Text
hidden = Map.singleton "style" "display:none;"

reflex :: DomBuilder t m => m ()
reflex = do
  rec loginEvt <- elDynAttr "div" loginAttr loginWidget
      loginAttr <- holdDyn (Map.empty) $ hidden <$ loginEvt
  void $ holdEvent () loginEvt authenticatedWidget

authenticatedWidget :: DomBuilder t m => User -> m ()
authenticatedWidget user =
  el "div" $ do
    getUsersWidget
    sendMsgWidget user

autoLogin :: (DomBuilder t m) => m (Event t User)
autoLogin = do
  pb <- getPostBuild
  withSuccess <$> getMe pb

loginForm :: (DomBuilder t m) => m (Event t User)
loginForm = do
  user <- userInput
  buttonEvt <- button "login"
  postResult <- postLogin (Right <$> user) buttonEvt
  void $ flash postResult $ text . Text.pack . show . reqFailure
  pure $ current user <@ withSuccess postResult

loginWidget :: (DomBuilder t m) => m (Event t User)
loginWidget = do
  autoLoginEvt <- autoLogin
  formEvt <- loginForm
  pure $ leftmost [formEvt, autoLoginEvt]

sendMsgWidget :: DomBuilder t m => User -> m ()
sendMsgWidget user =
  el "div" $ do
    input <- messageInput user
    sendMsg <- button "Send Message"
    messages <- fmapMaybe reqSuccess <$> postMessage (Right <$> input) sendMsg
    resulting <-
      holdDyn
        ([Message (User "none" "none") "ddd"]) -- what to show if nothing
        messages -- source of messages (if any)
    void $ el "div" $ simpleList resulting fancyMsg


fancyMsg ::
     (DomBuilder t m)
  => Dynamic t Message
  -> m (Element EventResult GhcjsDomSpace t)
fancyMsg msg =
  elClass "div" "message" $ do
    _ <- elDynHtml' "h1" $ Text.pack . name . from <$> msg
    elDynHtml' "span" $ Text.pack . content <$> msg

getUsersWidget :: DomBuilder t m => m ()
getUsersWidget =
  el "div" $ do
    intButton <- button "Get Users"
    serverInts <- fmapMaybe reqSuccess <$> getUsers intButton
    display =<< holdDyn ([User "none" "none"]) serverInts

messageInput :: (DomBuilder t m) => User -> m (Dynamic t Message)
messageInput user = do
  message <- labeledInput "message"
  pure $ Message user <$> (Text.unpack <$> _textInput_value message)

userInput :: (DomBuilder t m) => m (Dynamic t User)
userInput = do
  username <- labeledInput "username"
  emailInput <- labeledInput "email"
  pure $
    User . Text.unpack <$> _textInput_value username <*>
    (Text.unpack <$> _textInput_value emailInput)

labeledInput :: (DomBuilder t m) => Text.Text -> m (TextInput t)
labeledInput label =
  elClass "div" "field" $ do
    elClass "label" "label" $ text label
    elClass "div" "control" $
      textInput
        (def &
         textInputConfig_attributes .~
         constDyn (Text.pack "class" =: Text.pack "input"))

withSuccess :: Reflex t => Event t (ReqResult () b) -> Event t b
withSuccess = fmapMaybe reqSuccess
