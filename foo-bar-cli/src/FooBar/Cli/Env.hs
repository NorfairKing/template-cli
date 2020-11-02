module FooBar.Cli.Env where

import Control.Monad.Reader
import FooBar.Cli.OptParse

type C a = ReaderT Settings IO a
