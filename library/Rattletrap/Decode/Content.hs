module Rattletrap.Decode.Content
  ( decodeContent
  ) where

import Rattletrap.Decode.Cache
import Rattletrap.Decode.ClassMapping
import Rattletrap.Decode.Common
import Rattletrap.Decode.Frame
import Rattletrap.Decode.KeyFrame
import Rattletrap.Decode.List
import Rattletrap.Decode.Mark
import Rattletrap.Decode.Message
import Rattletrap.Decode.Str
import Rattletrap.Decode.Word32le
import Rattletrap.Type.ClassAttributeMap
import Rattletrap.Type.Content
import Rattletrap.Type.Word32le
import Rattletrap.Utility.Bytes

import qualified Control.Monad.Trans.State as State
import qualified Data.Binary.Bits.Get as BinaryBit
import qualified Data.Binary.Get as Binary

decodeContent
  :: (Int, Int, Int)
  -- ^ Version numbers, usually from 'Rattletrap.Header.getVersion'.
  -> Int
  -- ^ The number of frames in the stream, usually from
  -- 'Rattletrap.Header.getNumFrames'.
  -> Word
  -- ^ The maximum number of channels in the stream, usually from
  -- 'Rattletrap.Header.getMaxChannels'.
  -> Decode Content
decodeContent version numFrames maxChannels = do
  (levels, keyFrames, streamSize) <-
    (,,) <$> getList getText <*> getList getKeyFrame <*> getWord32
  (stream, messages, marks, packages, objects, names, classMappings, caches) <-
    (,,,,,,,)
    <$> Binary.getLazyByteString (fromIntegral (word32leValue streamSize))
    <*> getList getMessage
    <*> getList getMark
    <*> getList getText
    <*> getList getText
    <*> getList getText
    <*> getList decodeClassMapping
    <*> getList decodeCache
  let
    classAttributeMap =
      makeClassAttributeMap objects classMappings caches names
    bitGet = State.evalStateT
      (getFrames version numFrames maxChannels classAttributeMap)
      mempty
    get = BinaryBit.runBitGet bitGet
  frames <- case Binary.runGetOrFail get (reverseBytes stream) of
    Left (_, _, problem) -> fail problem
    Right (_, _, frames) -> pure frames
  pure
    ( Content
      levels
      keyFrames
      streamSize
      frames
      messages
      marks
      packages
      objects
      names
      classMappings
      caches
    )
