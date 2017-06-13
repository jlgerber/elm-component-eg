module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, id, style)
{-
    Local Imports
-}
import Styles exposing (..)
import SwankyB.Main as SB exposing (..)


-- MODEL 

type alias Model =
    { swanky: SB.Model
    }


type Msg 
    = NoOp 
    | SwankyB SB.Msg  


-- INIT

init : (Model, Cmd Msg)
init = 
    let 
        (swankybModel,msg) = SB.init 
    in
        {swanky = swankybModel } ! [Cmd.map SwankyB msg]



-- VIEW

view : Model -> Html Msg 
view model =
    
    div [style bodstyle] [ div [ ] [text "A Contrived Example"] 
           -- We html map the results of calling the child's view with the child's model
           -- using the appropriate Msg constructor 
           , ( Html.map SwankyB (SB.view model.swanky) )
           ]



-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of 
        NoOp -> (model, Cmd.none)
        -- we pattern match the result of calling the child update, and 
        -- Cmd.map the child cmd to the associated parent's Msg (with constructor taking child.cmd)
        SwankyB swmsg ->
             let
                (swmodel, cmd) =
          SB.update swmsg model.swanky
      in
        { model | swanky = swmodel } ! [ Cmd.map SwankyB cmd ]


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg 
subscriptions model = 
    -- lets map over Sub SB.Msg transforming it into 
    -- Sub Msg (where Msg is SwankyB SB.Msg)
    Sub.map SwankyB (SB.subscriptions model.swanky)


-- MAIN

main : Program Never Model Msg
main =
    Html.program 
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- STYLES

bodstyle : Style 
bodstyle = [ "display" => "flex"
           , "flex-direction" => "column"
           , "width" => "100%"
           , "height" => "100%"
           , "justify-content" => "center"
           , "align-items" => "center"
           ]
