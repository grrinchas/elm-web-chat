module Main exposing (main)

import Chat exposing (Chat)
import Html.Styled as Html
import Messages exposing (..)
import View


type Msg
    = None
    | OnChatMsg ChatMsg


type alias Model =
    { chat: Chat

    }


initialModel: (Model, Cmd Msg)
initialModel =
    Chat.initial "ws://127.0.0.1:8080"
        |> Tuple.mapFirst Model
        |> Tuple.mapSecond (Cmd.map OnChatMsg)



subscriptions: Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map OnChatMsg <| Chat.subscribe "ws://127.0.0.1:8080"
        ]


main : Program Never Model Msg
main = Html.program
    { init = initialModel
    , update = update
    , view = \{chat} -> Html.map OnChatMsg <| View.view chat
    , subscriptions = subscriptions
    }


update: Msg -> Model -> (Model, Cmd Msg)
update msg ({chat} as model) =
        case msg of
            None ->
                (model, Cmd.none)

            OnChatMsg chatMsg ->
                Chat.update chatMsg chat
                    |> Tuple.mapFirst Model
                    |> Tuple.mapSecond (Cmd.map OnChatMsg)
