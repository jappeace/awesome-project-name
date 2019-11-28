{-# LANGUAGE ConstraintKinds   #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo       #-}

module Awe.Front.Main
  ( main
  , IniState(..)
  )
where

import           Awe.Common
import           Awe.Front.ServantClient
import           Control.Applicative            ( (<$>)
                                                , (<*>)
                                                )
import           Control.Monad                  ( void )
import           Control.Monad.Fix
import           Control.Monad.IO.Class
import           Data.Aeson
import qualified Data.Map                      as Map
import qualified Data.Text                     as Text
import           GHC.Generics                   ( Generic )
import           Reflex
import           Reflex.Bulmex.Event
import           Reflex.Bulmex.Html
import           Reflex.Bulmex.Input.Polymorphic
import           Reflex.Dom                    as Dom
                                         hiding ( TextInput
                                                , textInput
                                                , _textInput_value
                                                )
import           Servant.Reflex

hidden :: Map.Map Text.Text Text.Text
hidden = Map.singleton "style" "display:none;"

-- I recommend doing somethign similar for higher level widgets
type AWidget js t m
  = ( Prerender js t m
    , DomBuilder t m
    , PerformEvent t m
    , MonadHold t m
    , MonadFix m
    , TriggerEvent t m
    , MonadIO (Performable m)
    , PostBuild t m
    )

newtype IniState =
  IniState (Maybe User)
  deriving (Generic)

instance FromJSON IniState
instance ToJSON IniState

main :: (AWidget js t m) => IniState -> m ()
main iniState = do
  iniDyn <- writeReadDom "iniState" iniState
  rec loginEvt  <- elDynAttr "div" loginAttr $ loginWidget iniDyn
      loginAttr <- holdDyn Map.empty $ hidden <$ loginEvt
  void $ holdEvent () loginEvt authenticatedWidget

authenticatedWidget
  :: ( DomBuilder t m
     , Prerender js t m
     , MonadFix m
     , MonadHold t m
     , PostBuild t m
     )
  => User
  -> m ()
authenticatedWidget user = el "div" $ do
  getUsersWidget
  sendMsgWidget user

loginForm :: (AWidget js t m) => m (Event t User)
loginForm = do
  user       <- userInput
  buttonEvt  <- button "login"
  postResult <- postLogin (Right <$> user) buttonEvt
  void $ flash postResult $ text . Text.pack . show . reqFailure
  pure $ current user <@ withSuccess postResult

loginWidget :: (AWidget js t m) => Dynamic t IniState -> m (Event t User)
loginWidget iniDyn = do
  pb      <- getPostBuild
  formEvt <- loginForm
  pure $ leftmost
    [formEvt, noNothing $ updated userDyn, noNothing $ current userDyn <@ pb]
  where userDyn = unpackUser <$> iniDyn

unpackUser :: IniState -> Maybe User
unpackUser (IniState d) = d

sendMsgWidget
  :: ( PostBuild t m
     , DomBuilder t m
     , MonadFix m
     , MonadHold t m
     , Prerender js t m
     )
  => User
  -> m ()
sendMsgWidget user = el "div" $ do
  input     <- messageInput user
  sendMsg   <- button "Send Message"
  messages  <- fmapMaybe reqSuccess <$> postMessage (Right <$> input) sendMsg
  resulting <- holdDyn [Message (User "none" "none") "ddd"] -- what to show if nothing
                       messages -- source of messages (if any)
  void $ el "div" $ simpleList resulting fancyMsg

fancyMsg :: (DomBuilder t m, PostBuild t m) => Dynamic t Message -> m ()
fancyMsg msg = elClass "div" "message" $ do
  void $ el "h1" $ dynText $ Text.pack . name . from <$> msg
  void $ el "span" $ dynText $ Text.pack . content <$> msg

getUsersWidget
  :: (DomBuilder t m, PostBuild t m, MonadHold t m, Prerender js t m) => m ()
getUsersWidget = el "div" $ do
  intButton  <- button "Get Users"
  serverInts <- fmapMaybe reqSuccess <$> getUsers intButton
  display =<< holdDyn [User "none" "none"] serverInts

messageInput :: (DomBuilder t m, PostBuild t m) => User -> m (Dynamic t Message)
messageInput user = do
  message <- labeledInput "message"
  pure $ Message user <$> (Text.unpack <$> _textInput_value message)

userInput :: (DomBuilder t m, PostBuild t m) => m (Dynamic t User)
userInput = do
  username   <- labeledInput "username"
  emailInput <- labeledInput "email"
  pure
    $   User
    .   Text.unpack
    <$> _textInput_value username
    <*> (Text.unpack <$> _textInput_value emailInput)

labeledInput :: (DomBuilder t m, PostBuild t m) => Text.Text -> m (TextInput t)
labeledInput label = elClass "div" "field" $ do
  elClass "label" "label" $ text label
  elClass "div" "control" $ textInput
    (def & textInputConfig_attributes .~ constDyn
      (Text.pack "class" =: Text.pack "input")
    )

withSuccess :: Reflex t => Event t (ReqResult () b) -> Event t b
withSuccess = fmapMaybe reqSuccess
