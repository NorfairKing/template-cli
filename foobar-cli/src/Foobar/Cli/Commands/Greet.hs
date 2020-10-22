{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Foobar.Cli.Commands.Greet where

import Data.Maybe
import Foobar.Cli.Commands.Import

greet :: GreetSettings -> C ()
greet GreetSettings {..} = do
  let greeting = fromMaybe "Hello" greetSettingGreeting
  polite <- asks settingPolite
  let politenessSuffix = if polite then ", Sir or madam" else ""
  liftIO $ print $ greeting <> politenessSuffix
