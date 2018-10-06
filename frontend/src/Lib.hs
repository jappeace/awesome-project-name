{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( reflex
    ) where
import Reflex.Dom

reflex :: IO()
reflex = mainWidget $ el "div" $ text "Welcome to Reflex"
