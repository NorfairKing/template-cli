{-# LANGUAGE OverloadedStrings #-}

module FooBar.Cli.Commands.GreetSpec
  ( spec,
  )
where

import Control.Monad.Reader
import FooBar.Cli.Commands.Greet
import FooBar.Cli.OptParse
import Test.Hspec

spec :: Spec
spec =
  describe "greet"
    $ it "does not crash"
    $ runReaderT
      ( greet GreetSettings {greetSettingGreeting = Just "Hello"}
      )
      (Settings {settingPolite = True})
