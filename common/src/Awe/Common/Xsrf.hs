{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators     #-}

module Awe.Common.Xsrf where

import           Data.Text

headerName :: Text
headerName = "X-XSRF"

cookieName :: Text
cookieName = headerName -- why should this be different
