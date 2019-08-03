{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Awe.Front.Main as App
import           Reflex.Dom

main :: IO ()
main = mainWidget $ App.main $ App.IniState Nothing
