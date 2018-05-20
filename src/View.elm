module View exposing (..)

import Components.Chat
import Html.Styled exposing (Html)
import Messages exposing (ChatMsg)
import Chat exposing (Chat, State(Maximised, Minimised))


view: Chat -> Html ChatMsg
view ({state} as chat) =
    case state of
        Minimised ->
            Components.Chat.minimised

        Maximised ->
            Components.Chat.maximised chat

