module Grocereye.Image.Database where

import Control.Monad.Reader
import Data.Has
import Data.Maybe
import Data.Pool
import Data.String
import Data.Void
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.Migration
import System.Environment

type Env = Pool Connection

type PG r m = (MonadReader r m, Has Env r, MonadIO m)

init :: IO Env
init = do
  pool <- acquirePool
  migrateDb pool
  return pool

acquirePool :: IO (Pool Connection)
acquirePool = do
  envUrl <- lookupEnv "DATABASE_URL"
  let pgUrl = fromString $ fromMaybe "postgresql://localhost/realworld" envUrl
  createPool (connectPostgreSQL pgUrl) close 1 10 10

migrateDb :: Pool Connection -> IO ()
migrateDb pool = withResource pool $ \conn -> do
  result <- withTransaction conn (runMigration (ctx conn))
  case result of
    MigrationError err -> error err
    MigrationSuccess -> return ()
  where
    ctx = MigrationContext cmd False
    cmd = MigrationCommands [MigrationInitialization, MigrationDirectory "postgresql"]

withConn :: (PG r m) => (Connection -> IO a) -> m a
withConn action = do
  pool <- asks getter
  liftIO $ withResource pool action
