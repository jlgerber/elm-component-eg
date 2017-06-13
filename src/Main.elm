module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, id, style)
import Styles exposing (..)

import SwankyB.Main exposing (..)

-- styles

bodstyle : Style 
bodstyle = [ "display" => "flex"
           , "flex-direction" => "column"
           , "width" => "100%"
           , "height" => "100%"
           , "justify-content" => "center"
           , "align-items" => "center"
           ]
-- model 
type alias Model =
    { swanky: SwankyB.Main.Model
    }

type Msg 
    = NoOp 
    | SwankyB SwankyB.Main.Msg  

-- init 
init : (Model, Cmd Msg)
init = 
    let 
        (swankybModel,msg) = SwankyB.Main.init 
    in
        {swanky = swankybModel } ! [Cmd.map SwankyB msg]

-- view
view : Model -> Html Msg 
view model =
    
    div [style bodstyle] [ div [ ] [text "A Contrived Example"] 
           -- We html map the results of calling the child's view with the child's model
           -- using the appropriate Msg constructor 
           , ( Html.map SwankyB (SwankyB.Main.view model.swanky) )
           ]
-- update

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of 
        NoOp -> (model, Cmd.none)
        -- we pattern match the result of calling the child update, and 
        -- Cmd.map the child cmd to the associated parent's Msg (with constructor taking child.cmd)
        SwankyB swmsg ->
             let
                (swmodel, cmd) =
          SwankyB.Main.update swmsg model.swanky
      in
        { model | swanky = swmodel } ! [ Cmd.map SwankyB cmd ]
-- subscriptions

subscriptions : Model -> Sub Msg 
subscriptions model = 
    Sub.map SwankyB (SwankyB.Main.subscriptions model.swanky)

-- main
main : Program Never Model Msg
main =
    Html.program 
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

