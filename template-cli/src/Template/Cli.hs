{-# LANGUAGE LambdaCase #-}

module Template.Cli
  ( templateCli,
  )
where

import Template.Cli.Commands

templateCli :: IO ()
templateCli = do
  Instructions disp sets <- getInstructions
  runReaderT (dispatch disp) sets

dispatch :: Dispatch -> C ()
dispatch = \case
  DispatchGreet gs -> greet gs
