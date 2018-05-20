module Looks.Position exposing (..)

import Css exposing (..)

import Maybe.Extra


positioned: Maybe Rem -> Maybe Rem -> Maybe Rem -> Maybe Rem -> Style
positioned l t r b =
    batch <| Maybe.Extra.values <|
        [ Maybe.map (\x -> left x) l
        , Maybe.map (\x -> top x) t
        , Maybe.map (\x -> right x) r
        , Maybe.map (\x -> bottom x) b
        ]

fixedAt: Maybe Rem -> Maybe Rem -> Maybe Rem -> Maybe Rem-> Style
fixedAt l t r b =
    batch
        [ positioned l t r b
        , position fixed
        ]

absoluteAt: Maybe Rem -> Maybe Rem -> Maybe Rem -> Maybe Rem-> Style
absoluteAt l t r b =
    batch
        [ positioned l t r b
        , position absolute
        ]

relativeAt: Maybe Rem -> Maybe Rem -> Maybe Rem -> Maybe Rem-> Style
relativeAt l t r b =
    batch
        [ positioned l t r b
        , position relative
        ]


centerYAndSpaceBetween: Style
centerYAndSpaceBetween =
    batch
        [ displayFlex
        , alignItems center
        , justifyContent spaceBetween
        ]


centerXY: Style
centerXY =
    batch
        [ displayFlex
        , alignItems center
        , justifyContent center
        ]

