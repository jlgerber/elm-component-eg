module Styles exposing (..)

type alias Style = List (String, String)

(=>) : a -> b -> ( a, b )
(=>) = (,)

px : Int -> String 
px sz =
    (toString sz) ++ "px"

colorCmp : Int -> String 
colorCmp c = 
    toString c ++ ", "

rgb : Int -> Int -> Int -> String 
rgb r g b =
    "rgb(" ++ colorCmp r ++ colorCmp g ++ toString b ++ ")"

padColor : Style 
padColor = ["color" => (rgb 200 200 200)]

