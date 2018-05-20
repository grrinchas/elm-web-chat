module Looks.Font exposing (..)

import Css exposing (..)


type MajorThird
    = VerySmall
    | Smaller
    | Small
    | Normal
    | Large
    | Larger
    | VeryLarge
    | Largest


typeScale major =
    case major of
        VerySmall -> Css.rem 0.512
        Smaller -> Css.rem 0.75
        Small -> Css.rem 0.9
        Normal ->Css.rem 1
        Large -> Css.rem 1.25
        Larger -> Css.rem 1.563
        VeryLarge -> Css.rem 1.953
        Largest -> Css.rem 2.441


lineHeightScale: MajorThird -> Rem
lineHeightScale major =
    case major of
        Largest -> Css.rem (baseHeight * 2)
        VeryLarge -> Css.rem (baseHeight * 2)
        Larger -> Css.rem (baseHeight * 2)
        _ -> Css.rem baseHeight


fontStyle: MajorThird -> Style
fontStyle major =
    batch
        [ fontSize <| typeScale major
        , lineHeight <| lineHeightScale major
        ]


baseFont = 1
baseLineHeight = 1.5
baseHeight = baseFont * baseLineHeight


smallFontStyle = fontStyle Small
normalFontStyle = fontStyle Normal
smallerFontStyle = fontStyle Smaller
largeFontStyle = fontStyle Large
largerFontStyle = fontStyle Larger
verLargeFontStyle = fontStyle VeryLarge
largestFontStyle = fontStyle Largest


wordBreak = property "word-break" "break-word"

defaultFontFamily = fontFamilies ["Helvetica Neue", "Segoe UI", "sans-serif"]


