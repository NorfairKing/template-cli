{-# LANGUAGE LambdaCase #-}

module Foobar.Cli
  ( foobarCli,
  )
where

import Foobar.Cli.Commands

foobarCli :: IO ()
foobarCli = do
  Instructions disp sets <- getInstructions
  runReaderT (dispatch disp) sets

dispatch :: Dispatch -> C ()
dispatch = \case
  DispatchGreet gs -> greet gs
