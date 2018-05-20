module Looks.Colour exposing (white, primary, secondary, greyVeryLight, grey, secondaryLight, error)

import Color
import Css


type Palette
    = White
    | Primary
    | Secondary
    | SecondaryLight
    | GreyVeryLight
    | Grey
    | Error


toColor: Css.Color -> Color.Color
toColor {red, green, blue, alpha} = Color.rgba red green blue alpha


fromColor: Color.Color -> Css.Color
fromColor color =
    let {red, green, blue, alpha} = Color.toRgb color
    in Css.rgba red green blue alpha


palette: Palette -> Css.Color
palette pal =
    case pal of
       White ->  Css.hex "ffffff"
       Primary ->  Css.hex "1E252D"
       Secondary ->  Css.hex "c8900b"
       SecondaryLight ->  Css.hex "fdf5e0"
       GreyVeryLight ->  Css.hex "f5f5f5"
       Grey ->  Css.hex "b5b5b5"
       Error ->  Css.hex "BC0A2A"


white = palette White
primary = palette Primary
secondary = palette Secondary
greyVeryLight = palette GreyVeryLight
grey = palette Grey
secondaryLight = palette SecondaryLight
error = palette Error


