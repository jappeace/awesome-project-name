{-# OPTIONS_GHC -fno-warn-orphans #-}

-- | Orphanage, put all your orphans in here for just the frontend.
--   eg for types not used by backend.
module Awe.Front.Orphanage where

import           Data.Text.Encoding (encodeUtf8)
import           Web.Cookie
import           Web.HttpApiData

-- XXX this is implemented in a later http api data, if above 0.3.10
-- we should delete this
-- The version of servant auth we use does implement these,
-- because we don't actually care about the content of the cookies it
-- should be fine.
-- (it's just browser state)
instance FromHttpApiData SetCookie where
  parseUrlPiece = parseHeader . encodeUtf8
  parseHeader = Right . parseSetCookie
