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

reflex :: MonadWidget t m => m ()
reflex = do
  rec loginEvt <- elDynAttr "div" loginAttr loginWidget
      loginAttr <- holdDyn (Map.empty) $ hidden <$ loginEvt
  void $ holdEvent () loginEvt authenticatedWidget

authenticatedWidget :: MonadWidget t m => User -> m ()
authenticatedWidget user =
  el "div" $ do
    getUsersWidget
    sendMsgWidget user

loginWidget :: (MonadWidget t m) => m (Event t User)
loginWidget = do
  pb <- getPostBuild
  autoLoginEvt <- getMe pb
  user <- userInput
  buttonEvt <- button "login"
  postResult <- postLogin (Right <$> user) buttonEvt
  void $ flash postResult $ text . Text.pack . show . reqFailure
  pure $ leftmost [withSuccess autoLoginEvt, current user <@ withSuccess postResult]

sendMsgWidget :: MonadWidget t m => User -> m ()
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
     (MonadWidget t m)
  => Dynamic t Message
  -> m (Element EventResult GhcjsDomSpace t)
fancyMsg msg =
  elClass "div" "message" $ do
    _ <- elDynHtml' "h1" $ Text.pack . name . from <$> msg
    elDynHtml' "span" $ Text.pack . content <$> msg

getUsersWidget :: MonadWidget t m => m ()
getUsersWidget =
  el "div" $ do
    intButton <- button "Get Users"
    serverInts <- fmapMaybe reqSuccess <$> getUsers intButton
    display =<< holdDyn ([User "none" "none"]) serverInts

messageInput :: (MonadWidget t m) => User -> m (Dynamic t Message)
messageInput user = do
  message <- labeledInput "message"
  pure $ Message user <$> (Text.unpack <$> _textInput_value message)

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

withSuccess :: Reflex t => Event t (ReqResult () b) -> Event t b
withSuccess = fmapMaybe reqSuccess
