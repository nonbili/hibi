module App.Types where

import Hibi.Prelude

import Halogen as H

type Message = Void

type Query = Const Void

data Action
  = Init

type Slot = ()

type HTML = H.ComponentHTML Action Slot Aff

type DSL = H.HalogenM State Action Slot Message Aff

type State =
  { now :: { year :: Int, month :: Int, day :: Int }
  }

initialState :: State
initialState =
  { now: { year: 2020, month: 1, day: 1 }
  }
