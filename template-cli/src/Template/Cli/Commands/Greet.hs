{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Template.Cli.Commands.Greet where

import Data.Maybe
import Template.Cli.Commands.Import

greet :: GreetSettings -> C ()
greet GreetSettings {..} = do
  let greeting = fromMaybe "Hello" greetSettingGreeting
  polite <- asks settingPolite
  let politenessSuffix = if polite then ", Sir or madam" else ""
  liftIO $ print $ greeting <> politenessSuffix
