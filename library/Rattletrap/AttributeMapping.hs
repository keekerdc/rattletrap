module Rattletrap.AttributeMapping where

import Rattletrap.Type.Word32
import Rattletrap.Decode.Word32
import Rattletrap.Encode.Word32

import qualified Data.Binary as Binary

data AttributeMapping = AttributeMapping
  { attributeMappingObjectId :: Word32
  , attributeMappingStreamId :: Word32
  } deriving (Eq, Ord, Show)

getAttributeMapping :: Binary.Get AttributeMapping
getAttributeMapping = do
  objectId <- getWord32
  streamId <- getWord32
  pure (AttributeMapping objectId streamId)

putAttributeMapping :: AttributeMapping -> Binary.Put
putAttributeMapping attributeMapping = do
  putWord32 (attributeMappingObjectId attributeMapping)
  putWord32 (attributeMappingStreamId attributeMapping)
