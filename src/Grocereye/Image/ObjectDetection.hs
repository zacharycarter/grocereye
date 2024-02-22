module Grocereye.Image.ObjectDetection (ObjectDetectionResponse, detectObjects) where

import Control.Monad.IO.Class (liftIO)
import Data.Aeson
import qualified Data.ByteString.Lazy as LBS
import qualified Data.ByteString.Lazy.Char8 as LB
import Data.Text as T
import qualified Data.Text.Lazy.Encoding as T
import GHC.Generics
import Network.HTTP.Client
import Network.HTTP.Client.MultipartFormData
  ( formDataBody,
    formDataBodyWithBoundary,
    partBS,
    partFileRequestBody,
    partFileSource,
    partLBS,
  )
import Network.HTTP.Client.TLS (tlsManagerSettings)
import Network.HTTP.Types.Status

data Tag = Tag
  { en :: Text
  }
  deriving (Show, Generic, ToJSON, FromJSON)

data DetectedObject = DetectedObject
  { confidence :: Float,
    tag :: Tag
  }
  deriving (Show, Generic, ToJSON, FromJSON)

data ObjectDetectionResult = ObjectDetectionResult
  { tags :: [DetectedObject]
  }
  deriving (Show, Generic, ToJSON, FromJSON)

data ObjectDetectionResponse = ObjectDetectionResponse
  { result :: ObjectDetectionResult
  }
  deriving (Show, Generic, ToJSON, FromJSON)

detectObjects :: LB.ByteString -> IO (Either String ObjectDetectionResponse)
detectObjects fc = withManager
  tlsManagerSettings
  -- { managerModifyResponse = \r -> do
  --     responseChunks <- brConsume $ responseBody r
  --     let fullResponse = mconcat responseChunks
  --     putStr "TRACE: RESPONSE: "
  --     putStrLn $ show fullResponse
  --     pure $ r {responseBody = pure fullResponse}
  -- }
  $ \m -> do
    req1 <- parseUrl "https://api.imagga.com/v2/tags"
    let formData = [partFileRequestBody "image" "foo.jpg" $ RequestBodyLBS fc]
    req2 <- formDataBody formData req1
    let req3 =
          req2
            { method = "POST",
              requestHeaders =
                [("Authorization", "Basic YWNjX2Y4ZTljNzMxZGU0MWFlZjplNzVmMGEzMWM5NjQyY2VhM2ZlZDhkZWY2YjIyYjcwZQ==")] ++ requestHeaders req2
            }
    res <- httpLbs req3 m
    return $ eitherDecode $ responseBody res
