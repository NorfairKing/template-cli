module Foobar.Cli.Env where

import Control.Monad.Reader
import Foobar.Cli.OptParse

type C a = ReaderT Settings IO a
