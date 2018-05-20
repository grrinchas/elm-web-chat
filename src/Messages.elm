module Messages exposing (..)


type ChatMsg
    = Maximise
    | Minimise

    | ChooseAnswer String
    | OnInput String
    | SendMessage
    | NewConversation

    | NewRemoteMessage String



