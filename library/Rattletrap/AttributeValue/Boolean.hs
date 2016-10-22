module Rattletrap.AttributeValue.Boolean where

import qualified Data.Binary.Bits.Get as BinaryBit
import qualified Data.Binary.Bits.Put as BinaryBit

data BooleanAttributeValue = BooleanAttributeValue
  { booleanAttributeValueFlag :: Bool
  } deriving (Eq, Ord, Show)

getBooleanAttributeValue :: BinaryBit.BitGet BooleanAttributeValue
getBooleanAttributeValue = do
  flag <- BinaryBit.getBool
  pure (BooleanAttributeValue flag)

putBooleanAttributeValue :: BooleanAttributeValue -> BinaryBit.BitPut ()
putBooleanAttributeValue booleanAttributeValue =
  BinaryBit.putBool (booleanAttributeValueFlag booleanAttributeValue)