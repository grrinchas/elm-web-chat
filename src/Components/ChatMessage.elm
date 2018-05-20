module Components.ChatMessage exposing (..)

import Css
import Html.Styled exposing (..)

import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick)
import Looks.Box as Box
import Looks.Colour as Colour
import Looks.Font as Font
import Looks.Common as Common
import Looks.Border as Border
import Messages exposing (ChatMsg(ChooseAnswer))
import Chat exposing (Adviser, Option)
import Strings


introduction: String -> Html msg
introduction name =
    let looks = css
         [ Font.smallerFontStyle
         , Font.defaultFontFamily
         , Css.textAlign Css.center
         , Box.fullWidth
         , Css.padding2 Box.halfScale Css.zero
         , Css.display Css.block
         ]
        nameLooks = css
         [ Css.color Colour.secondary
         ]
    in div [looks]
        [ span [] [text Strings.youAreTalkingWith]
        , span [nameLooks] [text name]
        ]


avatar: String -> Html msg
avatar url =
    let looks = css
         [ Box.circle Box.tripleScale
         ]
    in img [src url, looks] []



fromAdviser: Adviser -> String -> Html msg
fromAdviser adviser msg =
    let looks = css
         [ Font.normalFontStyle
         , Font.defaultFontFamily
         , Font.wordBreak
         , Box.fullWidth
         , Css.display Css.block
         , Css.margin2 Box.halfScale Css.zero
         ]
        metaLooks = css
         [ Font.smallerFontStyle
         , Css.marginTop Box.quarterScale
         ]
        msgLooks = css
         [ Css.backgroundColor Colour.secondaryLight
         , Css.borderRadius Border.defaultBorderRadius
         , Css.padding Box.halfScale
         ]
        msgContainer = css
         [ Css.displayFlex
         , Css.flexDirection Css.column
         , Css.paddingLeft Box.defaultScale
         ]
    in div [looks, class "Ahas"]
        [ div [css [Css.displayFlex]]
            [ avatar adviser.avatar
            , div [msgContainer]
                [ span [metaLooks] [ text adviser.name ]
                , span [msgLooks] [text msg]
                ]
            ]
        ]


option: Option -> Html ChatMsg
option {msg, id} =
    let looks = css
         [ Font.normalFontStyle
         , Font.defaultFontFamily
         , Css.margin2 Box.defaultScale Css.zero
         , Css.textAlign Css.right
         , Font.wordBreak
         ]
        msgLooks = css
         [ Css.color Colour.secondary
         , Border.secondary
         , Css.padding2 Box.quarterScale Box.halfScale
         , Css.borderRadius Border.hugeBorderRadius
         , Common.clickable
         ]
    in div [looks]
        [ span [msgLooks, onClick <| ChooseAnswer id] [text msg]
        ]


fromCustomer: String -> Html ChatMsg
fromCustomer msg =
    let looks = css
         [ Font.normalFontStyle
         , Font.defaultFontFamily
         , Css.margin2 Box.halfScale Css.zero
         , Css.textAlign Css.right
         , Font.wordBreak
         ]
        msgLooks = css
         [ Css.color Colour.white
         , Css.backgroundColor Colour.secondary
         , Css.padding2 Box.quarterScale Box.halfScale
         , Css.borderRadius Border.defaultBorderRadius
         ]
    in div [looks]
        [ span [msgLooks] [text msg]
        ]


waiting:  Html msg
waiting =
    let looks = css
         [ Font.smallerFontStyle
         , Font.defaultFontFamily
         , Css.textAlign Css.center
         , Box.fullWidth
         , Css.padding2 Box.halfScale Css.zero
         , Css.display Css.block
         ]
    in div [looks]
        [ span [] [text Strings.connecting]
        ]

