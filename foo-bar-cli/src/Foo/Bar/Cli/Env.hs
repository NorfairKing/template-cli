module Foo.Bar.Cli.Env where

import Control.Monad.Reader
import Foo.Bar.Cli.OptParse

type C a = ReaderT Settings IO a
