module Foobar.CliSpec (spec) where

import Foobar.Cli
import System.Environment
import Test.Hspec

spec :: Spec
spec =
  it "'Just works'" $
    withArgs ["greet", "--greeting", "Hello", "--polite"] foobarCli
