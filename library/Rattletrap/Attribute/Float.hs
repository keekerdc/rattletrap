module Rattletrap.Attribute.Float where

import Rattletrap.Type.Float32
import Rattletrap.Decode.Float32
import Rattletrap.Encode.Float32

import qualified Data.Binary.Bits.Get as BinaryBit
import qualified Data.Binary.Bits.Put as BinaryBit

newtype FloatAttribute = FloatAttribute
  { floatAttributeValue :: Float32
  } deriving (Eq, Ord, Show)

getFloatAttribute :: BinaryBit.BitGet FloatAttribute
getFloatAttribute = do
  value <- getFloat32Bits
  pure (FloatAttribute value)

putFloatAttribute :: FloatAttribute -> BinaryBit.BitPut ()
putFloatAttribute floatAttribute =
  putFloat32Bits (floatAttributeValue floatAttribute)
