{-# LANGUAGE OverloadedStrings #-}

module Foo.Bar.Cli.Commands.GreetSpec
  ( spec,
  )
where

import Control.Monad.Reader
import Foo.Bar.Cli.Commands.Greet
import Foo.Bar.Cli.OptParse
import Test.Hspec

spec :: Spec
spec =
  describe "greet" $
    it "does not crash" $
      runReaderT
        ( greet GreetSettings {greetSettingGreeting = Just "Hello"}
        )
        (Settings {settingPolite = True})
