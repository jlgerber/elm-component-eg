module SwankyB.Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, id, style)
import Html.Events exposing (onClick,onMouseDown, onMouseUp)
import Random exposing (..)
import Color
import Styles exposing (..)
import Debug 
import Keyboard 
import Char 
import String 

buttonStyle :  Style
buttonStyle = 
    [ "width"  => px 60
    , "height" => px 40
    , "margin" => px 10
    , "background-color" => "lightgrey"
    , "border-radius"    => px 5
    , "display"          => "flex"
    , "justify-content"  => "center"
    , "align-items"      => "center"
    , "user-select"      => "none"
    , "cursor"           => "pointer"
    ]

releaseStyle : Style 
releaseStyle = [ "box-shadow" => "2px 2px 4px 3px rgba(0,0,0,0.65)"]

pressStyle : Style 
pressStyle = []

boxStyle :  Style 
boxStyle =
    [ "width"  => px 40
    , "height"  => px 40
    , "border"  => "1px solid black"
    , "margin"  => px 10
    , "display" => "flex"
    , "justify-content" => "center"
    , "align-items"     => "center"
    , "cursor"          => "not-allowed"
    ]

containerStyle :  Style 
containerStyle =
    [ "display" => "flex"
    ]


type Msg 
    = Click
    | MouseKeyDown Bool 
    | RandColor Color.Color 
    | KeyPress Keyboard.KeyCode

-- model 
type alias Model = { rgba: Color.Color
                   , key : String
                   , mousedown : Bool
                   }

init : (Model, Cmd Msg) 
init = ( {rgba = Color.white, key = "", mousedown = False }, Cmd.none)

colorToString : Color.Color -> String 
colorToString color =
    let {red, green, blue, alpha } = (Color.toRgb color)
    in 
        "rgba(" ++ (toString red )++ ", " ++ (toString green) 
                ++ ", " ++ (toString blue) ++ ", " ++(toString alpha) ++ ")"

-- view 
view : Model -> Html Msg
view model =
    let 
        {hue, saturation, lightness, alpha } = (Color.toHsl model.rgba )
        textcolorstyle  = 
            if lightness > 0.5 
            then ["color" => "black"] 
            else ["color" =>  "white"]

        padcolor = colorToString model.rgba
        padcolorstyle = [ "background-color" =>  padcolor]
        (bs, txt) = 
            case model.mousedown of 
                True -> (buttonStyle, "Thanks")
                False -> (buttonStyle ++ releaseStyle, "pressme")
    in 
        div [ class "swankyb-container", style containerStyle ] 
            [ div [ class "swankyb-button"
                  , onClick Click
                  , onMouseDown (MouseKeyDown True)
                  , onMouseUp (MouseKeyDown False)
                  , style bs] [text txt]
            , div [ class "colorpad"
                  , style  (boxStyle ++ padcolorstyle ++ textcolorstyle)
                  ] [text model.key]
            ]


-- update 
rgb : Generator Color.Color
rgb =
  map3 Color.rgb (int 0 255) (int 0 255) (int 0 255)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of 
        Click -> (model, (Random.generate RandColor rgb) )
        
        RandColor color -> ({model | rgba = Debug.log "setcolor" color}, Cmd.none)

        KeyPress keycode -> ({model | key = (String.fromChar <| Char.fromCode keycode)}, Cmd.none)

        MouseKeyDown yesno-> ({model | mousedown = yesno}, Cmd.none)


subscriptions : Model -> Sub Msg 
subscriptions  model =
  Keyboard.downs KeyPress


-- NOTES

{-
In the main file we do the following 
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.map SwankyBMsg (SwankyB.subscriptions model)

SwankyBMsg is defined as a main Msg which takes a SwankyB.Msg 

in SwankyB define subscriptions
Here SwankyB is also a type defined as 
type SwankyB context = SwankyB {state : }
subscriptions : SwankyB context -> Sub (Msg context)
subscriptions (SwankyB model) =
  Sub.batch
    [ if shouldCloseOnClick model.openState then
        Mouse.downs (\_ -> Close)
      else
        Sub.none
    ]

-}

