{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo       #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TypeApplications #-}
{-# OPTIONS_GHC -fprint-explicit-kinds -Wpartial-type-signatures #-}


{-# LANGUAGE NoMonomorphismRestriction          #-}
{-# LANGUAGE OverloadedStrings, PartialTypeSignatures, RecursiveDo #-}
{-# LANGUAGE ScopedTypeVariables, TypeApplications, TypeFamilies   #-}
{-# LANGUAGE TypeOperators #-}

module Lib
  ( reflex
  ) where
import Reflex
import Reflex.Dom
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Text (pack, unpack, Text)
import Text.Read (readMaybe)
import Control.Applicative ((<*>), (<$>))
import Servant.API
import Common
import Servant.Reflex
import Data.Proxy
import Control.Monad(join)

reflex :: IO()
reflex = do

  mainWidget $
    el "div" $ do
    nx <- numberInput
    d <- dropdown Times (constDyn ops) def
    ny <- numberInput
    let values = zipDynWith (,) nx ny
        result = zipDynWith (\o (x,y) -> runOp o <$> x <*> y) (_dropdown_value d) values
        resultText = fmap (pack . show) result
    text " =dad fadf adfdsf "
    dynText resultText
    elClass "div" "int-demo" $ do
        intButton  <- button "Get Int"
        serverInts <- fmapMaybe reqSuccess <$> getUsers intButton
        name <- textInput def
        email <- textInput def
        dynText $ _textInput_value email
        display =<< holdDyn ([User "none" "none"]) serverInts
        sendMsg <- button "Send Message"
        input <- messageInput 
        messages <- fmapMaybe reqSuccess <$> postMessage input sendMsg 
        display =<< holdDyn ([Message (User "none" "none") "ddd"]) messages

        -- postMessage <- fmapMaybe reqSuccess <$> postMessage 

messageInput :: (MonadWidget t m) => m (Dynamic t (Either Text Message))
messageInput = do
    message <- textInput def
    pure $ join $ mapDyn (Right . (Message $ User "none" "none") . unpack) (_textInput_value message)

numberInput :: (MonadWidget t m) => m (Dynamic t (Maybe Double))
numberInput = do
  let errorState = "style" =: "border-color: red"
      validState = "style" =: "border-color: green"
  rec n <- textInput $ def & textInputConfig_inputType .~ "number"
                           & textInputConfig_initialValue .~ "0"
                           & textInputConfig_attributes .~ attrs
      let result = readMaybe . unpack <$> _textInput_value n
          attrs  = fmap (maybe errorState (const validState)) result
  return result

data Op = Plus | Minus | Times | Divide deriving (Eq, Ord)

ops :: Map Op Text
ops = Map.fromList [(Plus, "+"), (Minus, "-"), (Times, "*"), (Divide, "/")]

runOp :: Fractional a => Op -> a -> a -> a
runOp s = case s of
            Plus -> (+)
            Minus -> (-)
            Times -> (*)
            Divide -> (/)


-- | The typesignature of this function is ridiculous, let's just ignore it
apiClients :: forall t m. (MonadWidget t m) => _
apiClients = client serviceAPI (Proxy @m) (Proxy @()) (constDyn url)
  where url :: BaseUrl
        url = BasePath "/"

getUsers :: MonadWidget t m
          => Event t ()  -- ^ Trigger the XHR Request
          -> m (Event t (ReqResult () [User])) -- ^ Consume the answer
postMessage :: MonadWidget t m
            => Dynamic t (Either Text Message)
            -> Event t ()
            -> m (Event t (ReqResult () [Message]))
(getUsers :<|> postMessage) = apiClients
