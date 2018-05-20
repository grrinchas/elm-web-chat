module Looks.Box exposing (..)

import Css exposing (..)
import Looks.Font as Font


type Scale
    = Quarter
    | Half
    | ThreeFourths
    | Default
    | OneAndHalf
    | Double
    | Triple
    | Custom Float
    | Golden



scale: Scale -> Rem
scale sc =
    let answer = \multiplier -> Css.rem (Font.baseHeight * multiplier)
    in case sc of
        Quarter -> answer 0.25
        Half -> answer 0.5
        ThreeFourths -> answer 0.75
        Default -> answer 1
        OneAndHalf -> answer 1.5
        Double -> answer 2
        Triple -> answer 3
        Custom i -> answer  i
        Golden -> answer 1.618


quarterScale = scale Quarter
halfScale = scale Half
threeFourthsScale = scale ThreeFourths
defaultScale = scale Default
oneAndHalfScale = scale OneAndHalf
doubleScale = scale Double
tripleScale = scale Triple
goldenScale = scale Golden
customScale int = scale (Custom int)


fullWidth = width <| pct 100
fullHeight = height <| pct 100


rect: Rem -> Rem -> Style
rect w h =
    batch
        [ width  w
        , height h
        , minWidth w
        , minHeight h
        ]


square: Rem -> Style
square size = rect size size


circle: Rem -> Style
circle size =
    batch
        [ square size
        , borderRadius <| pct 50
        ]

