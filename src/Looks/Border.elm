module Looks.Border exposing (..)

import Css exposing (..)
import Looks.Colour as Colour


defaultBorderRadius = px 10
hugeBorderRadius = px 20

secondary: Style
secondary =
    batch
        [ border3 (px 1) solid Colour.secondary
        ]


defaultBorderTop: Style
defaultBorderTop =
    batch
        [ borderTop3 (px 1) solid Colour.grey
        ]
