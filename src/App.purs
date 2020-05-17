module App
  ( app
  ) where

import Hibi.Prelude

import App.Types (Action(..), DSL, HTML, Message, Query, State, initialState)
import Data.Int as Int
import Data.JSDate as JSDate
import Halogen as H
import Halogen.HTML as HH

render :: State -> HTML
render state =
  HH.div_
  [ HH.text "Hello Hibi"
  ]

app :: H.Component HH.HTML Query Unit Message Aff
app = H.mkComponent
  { initialState: const initialState
  , render
  , eval: H.mkEval $ H.defaultEval
      { handleAction = handleAction
      , initialize = Just Init
      }
  }

handleAction :: Action -> DSL Unit
handleAction = case _ of
  Init -> do
    d <- liftEffect JSDate.now
    year <- liftEffect $ JSDate.getFullYear d
    month <- liftEffect $ JSDate.getMonth d
    day <- liftEffect $ JSDate.getDate d
    H.modify_ $ _
      { now =
          { year: Int.ceil year
          , month: Int.ceil month + 1
          , day: Int.ceil day
          }
      }
