{-# LANGUAGE TemplateHaskell #-}

module Rattletrap.Type.GameModeAttribute
  ( GameModeAttribute(..)
  ) where

import Rattletrap.Type.Common

import qualified Data.Word as Word

data GameModeAttribute = GameModeAttribute
  { gameModeAttributeNumBits :: Int
  , gameModeAttributeWord :: Word.Word8
  } deriving (Eq, Ord, Show)

$(deriveJson ''GameModeAttribute)
