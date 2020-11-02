module FooBar.CliSpec (spec) where

import FooBar.Cli
import System.Environment
import Test.Hspec

spec :: Spec
spec =
  it "'Just works'" $
    withArgs ["greet", "--greeting", "Hello", "--polite"] fooBarCli
