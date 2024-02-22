{-# LANGUAGE OverloadedStrings #-}

module Grocereye.Image.Api (uploadImage) where

import Control.Monad.IO.Class (liftIO)
import Database.PostgreSQL.Simple
import Grocereye.Image.ObjectDetection
import Network.HTTP.Types.Status (status200, status500)
import Network.Wai.Parse
import Safe
import Web.Scotty

uploadImage :: Connection -> ActionM ()
uploadImage _ = do
  fs <- files
  case headMay fs of
    Nothing -> pure ()
    Just (_, fi) -> do
      let fcontent = fileContent fi
      img <- liftIO (detectObjects fcontent)
      case img of
        Left err -> do
          liftIO $ putStrLn err
          status status500
        Right imgData -> do
          liftIO $ print imgData
          status status200
