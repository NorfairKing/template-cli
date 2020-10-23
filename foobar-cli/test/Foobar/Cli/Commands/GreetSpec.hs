{-# LANGUAGE OverloadedStrings #-}

module Foobar.Cli.Commands.GreetSpec
  ( spec,
  )
where

import Control.Monad.Reader
import Foobar.Cli.Commands.Greet
import Foobar.Cli.OptParse
import Test.Hspec

spec :: Spec
spec =
  describe "greet"
    $ it "does not crash"
    $ runReaderT
      ( greet GreetSettings {greetSettingGreeting = Just "Hello"}
      )
      (Settings {settingPolite = True})
