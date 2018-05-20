module Components.Chat exposing (minimised, maximised)

import Css
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (class, css, disabled, placeholder, value)
import Html.Styled.Events exposing (keyCode, on, onClick, onInput)
import Json.Decode
import List.Extra
import Messages exposing (..)

import Looks.Box as Box
import Looks.Colour as Colour
import Looks.Font as Font
import Looks.Position as Position
import Looks.Common as Common
import Looks.Shadow as Shadow
import Looks.Border as Border

import Components.ChatMessage as ChatMessage
import Chat exposing (..)
import Strings

simpleIcon: String -> List (Attribute msg) -> Html msg
simpleIcon val attr =
    let looks = css
         [
         ]
    in i (attr ++ [class "material-icons", looks])
         [ text val
         ]


chatIcon: String -> List (Attribute ChatMsg) -> ChatMsg -> Html ChatMsg
chatIcon ic attr msg =
    let looks = css
         [ Box.circle Box.doubleScale
         , Css.backgroundColor Colour.secondary
         , Position.centerXY
         , Common.clickable
         , Shadow.normalShadow
         , Css.marginLeft Box.defaultScale
         ]
        iconLooks = css
         [ Css.color Colour.white
         ]
    in div (attr ++ [looks,onClick msg])
         [ simpleIcon ic [iconLooks]
         ]

chatWrapper: List (Html msg) -> Html msg
chatWrapper children =
    let looks = css
         [ Position.absoluteAt Nothing Nothing (Just Box.defaultScale) (Just Box.defaultScale)
         ]
    in div [looks] children


minimised: Html ChatMsg
minimised =
    chatWrapper [chatIcon "chat_bubble" [] Maximise]


maximised: Chat -> Html ChatMsg
maximised ({conversation} as chat) =
    let looks = css
         [ Css.position Css.relative
         , Css.displayFlex
         , Css.flexDirection Css.column
         ]
        iconLooks = css
            [ Css.alignSelf Css.flexEnd
            , Css.displayFlex
            ]
        bodyLooks = css
         [ Shadow.largeShadow
         , Css.marginBottom Box.defaultScale
         ]
    in
    chatWrapper
        [ div [looks]
              [ div [ bodyLooks ]
                [ chatBody conversation
                , chatInput chat
                ]
              , div [iconLooks]
                [ chatIcon "clear" [css [Css.backgroundColor Colour.error]] NewConversation
                , chatIcon "remove" [] Minimise
                ]
              ]
        ]



chatInput: Chat -> Html ChatMsg
chatInput chat =
    let looks = css
         [ Border.defaultBorderTop
         ]
    in div [looks]
        [ handleInput chat
        ]



handleInput: Chat -> Html ChatMsg
handleInput {conversation, authenticated, typedMessage} =
    let inputLooks = css
         [ Common.resetStyle
         , Box.fullWidth
         , Font.normalFontStyle
         , Font.defaultFontFamily
         , Common.defaultPlaceholder
         , Css.padding Box.defaultScale
         ]
        defaultInput = \attr -> input (attr ++[inputLooks, onInput OnInput, value typedMessage, handleEnter]) []
    in case List.Extra.last conversation of
         Nothing -> defaultInput [ placeholder Strings.yourMessage]
         Just msg ->
             case msg of
                 Choice options ->
                     input [ placeholder Strings.chooseAnOption , inputLooks , disabled True ] []
                 FromAdviser _ _ ->
                     case authenticated of
                         True ->
                            defaultInput [ placeholder Strings.yourMessage]
                         False ->
                            defaultInput [ placeholder Strings.enterYourName]
                 _ ->
                    defaultInput [ placeholder Strings.yourMessage]


handleEnter =
    let isEnter code =
         if code == 13 then
             Json.Decode.succeed SendMessage
         else
             Json.Decode.fail "not ENTER"
    in
        on "keydown" (Json.Decode.andThen isEnter keyCode)



chatBody: Conversation -> Html ChatMsg
chatBody conversation =
    let looks = css
         [
          Css.borderRadius Border.defaultBorderRadius
         , Css.height <| Box.customScale 27
         , Css.width <| Box.customScale 17
         , Css.padding Box.defaultScale
         , Css.displayFlex
         , Css.flexDirection Css.column
         , Css.overflowY Css.scroll
         ]
    in div [looks] <|
        List.map chatMessage conversation



chatMessage: ChatMessage -> Html ChatMsg
chatMessage msg =
    case msg of
        Introduction name ->
            ChatMessage.introduction name
        FromAdviser adviser msg ->
            ChatMessage.fromAdviser adviser msg
        Choice options ->
            div [] <| List.map ChatMessage.option options
        FromCustomer str ->
            ChatMessage.fromCustomer str
        Waiting  ->
            ChatMessage.waiting


