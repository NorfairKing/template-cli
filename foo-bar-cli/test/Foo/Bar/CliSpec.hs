module Foo.Bar.CliSpec (spec) where

import Foo.Bar.Cli
import System.Environment
import Test.Hspec

spec :: Spec
spec =
  it "'Just works'" $
    withArgs ["greet", "--greeting", "Hello", "--polite"] fooBarCli
