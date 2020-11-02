{-# LANGUAGE LambdaCase #-}

module FooBar.Cli
  ( fooBarCli,
  )
where

import FooBar.Cli.Commands

fooBarCli :: IO ()
fooBarCli = do
  Instructions disp sets <- getInstructions
  runReaderT (dispatch disp) sets

dispatch :: Dispatch -> C ()
dispatch = \case
  DispatchGreet gs -> greet gs
