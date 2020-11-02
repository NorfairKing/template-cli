{-# LANGUAGE LambdaCase #-}

module Foo.Bar.Cli
  ( fooBarCli,
  )
where

import Foo.Bar.Cli.Commands

fooBarCli :: IO ()
fooBarCli = do
  Instructions disp sets <- getInstructions
  runReaderT (dispatch disp) sets

dispatch :: Dispatch -> C ()
dispatch = \case
  DispatchGreet gs -> greet gs
