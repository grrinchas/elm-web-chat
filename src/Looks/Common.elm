module Looks.Common exposing (..)

import Css exposing (..)
import Looks.Colour as Colour
import Looks.Font as Font


clickable: Style
clickable =
    batch
        [ hover
            [ cursor pointer
            ]
        ]

resetStyle: Style
resetStyle =
    batch
        [ important <| border zero
        , important <| outline none
        , important <| boxShadow none
        , boxSizing borderBox
        , padding zero
        , margin zero
        , property "-webkit-appearance" "none"
        , property "-moz-appearance" "none"
        , property "-ms-appearance" "none"
        , property "-o-appearance" "none"
        ]

defaultPlaceholder: Style
defaultPlaceholder =
    let looks =
       [ Css.color Colour.grey
       , Font.defaultFontFamily
       , Font.normalFontStyle
       , Css.fontWeight Css.bold
       ]
    in batch
        [ pseudoElement "placeholder" looks
        , pseudoClass "ms-input-placeholder" looks
        , pseudoElement "ms-input-placeholder" looks
        ]

