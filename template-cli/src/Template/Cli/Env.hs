module Template.Cli.Env where

import Control.Monad.Reader
import Template.Cli.OptParse

type C a = ReaderT Settings IO a
