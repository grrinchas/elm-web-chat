module Chat exposing (..)

import Html.Styled exposing (Html)
import Json.Decode exposing (Decoder)
import Json.Encode
import List.Extra
import Messages exposing (..)
import WebSocket
import WebSocket.LowLevel exposing (WebSocket)


type State
    = Maximised
    | Minimised


type alias Chat =
    { state: State
    , conversation: Conversation
    , typedMessage: String
    , socket: String
    , authenticated: Bool
    }

type alias Adviser =
    { avatar: String
    , name: String
    , isBot: Bool
    }

type alias Option =
    { id: String
    , msg: String
    }

type ChatMessage
    = Introduction String
    | Choice (List Option)
    | FromAdviser Adviser String
    | FromCustomer String
    | Waiting


subscribe: String -> Sub ChatMsg
subscribe sock =
    WebSocket.listen sock NewRemoteMessage


type alias Conversation =
    List ChatMessage


initial: String -> (Chat, Cmd ChatMsg)
initial sock =
    ( { state = Maximised
      , conversation = []
      , typedMessage = ""
      , socket = sock
      , authenticated = False
      }
      , WebSocket.send sock <| encodeJson "CONNECTION_TYPE" "CUSTOMER"
    )


update: ChatMsg -> Chat -> (Chat, Cmd ChatMsg)
update msg ({state, conversation, socket, authenticated, typedMessage} as chat) =
    case msg of
        Maximise ->
            {chat | state = Maximised}
                |> flip (,) Cmd.none

        Minimise ->
            {chat | state = Minimised}
                |> flip (,) Cmd.none

        ChooseAnswer identity ->
            let op = \type_ ->
                 case type_ of
                    Choice options ->
                        List.Extra.find (\{id} -> id == identity) options
                            |> Maybe.map .msg
                            |> Maybe.map FromCustomer
                            |> Maybe.withDefault type_
                    _ -> type_
            in List.Extra.updateAt (List.length conversation - 1) op conversation
                |> (\con -> ({chat | conversation = con}, WebSocket.send socket <| encodeJson "CHOICE" identity))

        OnInput str ->
            {chat | typedMessage =  str}
                |> flip (,) Cmd.none

        NewConversation ->
            {chat | authenticated = False, conversation = []}
                |> flip (,) (WebSocket.send socket <| encodeJson "NEW_CONVERSATION" "")

        SendMessage ->
            case authenticated of
                True ->
                    { chat | typedMessage = "" , conversation = conversation ++ [FromCustomer typedMessage] }
                        |> flip (,) (WebSocket.send socket <| encodeJson "FROM_CUSTOMER" typedMessage)
                False ->
                    {chat | authenticated = True, typedMessage ="", conversation = conversation ++ [FromCustomer typedMessage]}
                        |> flip (,) (WebSocket.send socket <| encodeJson "NAME" typedMessage)


        NewRemoteMessage str ->
            case Json.Decode.decodeString decodeChatMessage str of
                Ok result ->
                    {chat | conversation = conversation ++ [result]}
                        |> flip (,) Cmd.none

                Err err ->
                    {chat | conversation = conversation ++ [FromCustomer err]}
                        |> flip (,) Cmd.none



encodeJson: String -> String -> String
encodeJson type_ msg =
    "{\"msg\":\""++ msg ++"\",\"type\":\"" ++ type_ ++"\"}"



decodeChatMessage: Decoder ChatMessage
decodeChatMessage =
    Json.Decode.field "type" Json.Decode.string
        |> Json.Decode.andThen decodeType


decodeType: String -> Decoder ChatMessage
decodeType str =
    let adviserDecoder =
          Json.Decode.map3 Adviser
              (Json.Decode.field "avatar" Json.Decode.string)
              (Json.Decode.field "name" Json.Decode.string)
              (Json.Decode.field "isBot" Json.Decode.bool)
        fromAdviserDecoder =
          Json.Decode.map2 FromAdviser
              (Json.Decode.field "adviser" adviserDecoder)
              (Json.Decode.field "msg" Json.Decode.string)
        optionDecoder =
          Json.Decode.map2 Option
              (Json.Decode.field "id" Json.Decode.string)
              (Json.Decode.field "msg" Json.Decode.string)
    in case str of
        "INTRODUCTION" ->
            Json.Decode.field "msg" Json.Decode.string
                |> Json.Decode.map Introduction

        "FROM_ADVISER" ->
            Json.Decode.field "msg" fromAdviserDecoder

        "CHOICE" ->
            Json.Decode.field "msg" (Json.Decode.list optionDecoder)
                |> Json.Decode.map Choice
        "LOOKING_FOR_ADVISER" ->
            Json.Decode.succeed Waiting
        _ ->
            Json.Decode.fail <| "Can't resolve message type: " ++ str



