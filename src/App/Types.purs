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
  {}

initialState :: State
initialState =
  {}
