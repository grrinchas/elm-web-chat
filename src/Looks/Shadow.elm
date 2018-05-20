module Looks.Shadow exposing (..)

import Css exposing (..)


smallShadow: Style
smallShadow =
    batch
        [ boxShadow4 (px 0) (px 1) (px 2) (rgba 0 0 0 0.16)
        , boxShadow4 (px 0) (px 1) (px 3) (rgba 0 0 0 0.23)
        ]

normalShadow: Style
normalShadow =
    batch
        [ boxShadow4 (px 0) (px 2) (px 3) (rgba 0 0 0 0.16)
        , boxShadow4 (px 1) (px 2) (px 4) (rgba 0 0 0 0.30)
        ]

largeShadow: Style
largeShadow =
    batch
        [ boxShadow5 (px 2) (px 2) (px 30) (px 2) (rgba 0 0 0 0.1)
        ]
