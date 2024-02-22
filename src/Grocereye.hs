module Grocereye (serve) where

import Database.PostgreSQL.Simple
import Grocereye.Image.Api
import Network.Wai.Middleware.RequestLogger
import Web.Scotty

localPG :: ConnectInfo
localPG =
  defaultConnectInfo
    { connectHost = "0.0.0.0",
      connectDatabase = "grocereye",
      connectUser = "grocereye",
      connectPassword = "changeme"
    }

serve :: IO ()
serve = do
  conn <- connect localPG
  routes conn

routes :: Connection -> IO ()
routes conn = scotty 3000 $ do
  middleware logStdoutDev
  post "/upload" $ do uploadImage conn
