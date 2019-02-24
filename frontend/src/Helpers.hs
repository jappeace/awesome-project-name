{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RankNTypes       #-}

-- | Helper funcs for reflex
--   idk eventjoin and holdEvent seem to usually slow down browser
--   because they tend to modify the dom
module Helpers where

import           Control.Applicative    (empty)
import           Control.Monad.IO.Class (MonadIO)
import           Data.Time
import           Data.Time.Clock.System (systemEpochDay)
import           Reflex
import qualified Reflex.Dom             as Dom

eventJoin :: (Reflex t, MonadHold t m) => Event t (Event t a) -> m (Event t a)
eventJoin = switchHold never

-- | Block those nothing events and only let trough just a's
noNothing :: FunctorMaybe f => f (Maybe a) -> f a
noNothing = fmapMaybe id

-- | Do something monadic with an event val
--   Because of haskell lazyness the things inside a holdevent
--   don't get evaluated untill the event fires, which makes the first
--   time slow. However it is good for initialization as we don't
--   need to load things unused.
holdEvent :: (Dom.DomBuilder t m, MonadHold t m)
  => b
  -> Event t a
  -> (a -> m b)
  -> m (Dynamic t b)
holdEvent val evt fun =
  Dom.widgetHold (pure val) $ fun <$> evt

-- | show something for 5 seconds after an event
flash :: (Monoid c, Dom.MonadWidget t m) => Event t b -> (b -> m c) -> m (Dynamic t c)
flash = flash' mempty

flash' :: Dom.MonadWidget t m => c -> Event t b -> (b -> m c) -> m (Dynamic t c)
flash' defVal event monadFunc = do
  delayed <- delayFor5secs event
  holdEvent defVal (leftmost [pure <$> event, empty <$ delayed]) $
        maybe (pure defVal) monadFunc

delayFor5secs ::
     (PerformEvent t m, TriggerEvent t m, MonadIO (Performable m))
  => Event t a
  -> m (Event t a)
delayFor5secs = delay $ toNominal $ secondsToDiffTime 5

-- | new time lib has this already
toNominal :: DiffTime -> NominalDiffTime
toNominal diff = diffUTCTime second first
  where
    first = UTCTime
      { utctDay = systemEpochDay
      , utctDayTime = picosecondsToDiffTime 0
      }
    second = UTCTime
      { utctDay = systemEpochDay
      , utctDayTime = diff
      }
