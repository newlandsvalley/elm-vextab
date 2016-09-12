module VexTabBasic exposing (..)

import Html exposing (Html, Attribute, text, div, input, button, textarea, canvas)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, onInput)
import Html.App as Html
import VexTab.Module as VexTab


main =
    Html.program
        { init = init, update = update, view = view, subscriptions = subscriptions }


type Msg
    = VexText String
    | VexTabMsg VexTab.Msg
    | NoOp


type alias Model =
    { text : String
    , vextab : VexTab.Model
    }


{-| initialise the model and delegate the initial command to that of the vextab module
-}
init : ( Model, Cmd Msg )
init =
    let
        ( vextabModel, vextabCmd ) =
            VexTab.init "#vextab"
    in
        { text = sampleVexText
        , vextab = vextabModel
        }
            ! [ Cmd.map VexTabMsg vextabCmd ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        VexText s ->
            ( { model | text = s }
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )

        VexTabMsg vextabMsg ->
            let
                ( newVextab, cmd ) =
                    VexTab.update vextabMsg model.vextab
            in
                { model | vextab = newVextab } ! [ Cmd.map VexTabMsg cmd ]



-- overall subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ -- subscription from the vex tab module
          Sub.map VexTabMsg (VexTab.subscriptions model.vextab)
        ]



-- VIEW


viewParseError : Maybe String -> Html Msg
viewParseError mpe =
    case mpe of
        Just e ->
            text e

        _ ->
            text ""


view : Model -> Html Msg
view model =
    div []
        [ textarea
            [ placeholder "VexTab"
            , value model.text
            , onInput VexText
            , taStyle
            , cols 70
            , rows 16
            , autocomplete False
            , spellcheck False
            , autofocus True
            ]
            []
        , button
            [ onClick (VexTabMsg (VexTab.RequestRenderScore model.text))
            , id "elm-check-render-score"
            , btnStyle
            ]
            [ text "render VexTab score" ]
        , div []
            [ viewParseError model.vextab.error ]
        , div []
            [ canvas [ id "vextab" ]
                []
            ]
        ]



{- style a textarea -}


taStyle : Attribute Msg
taStyle =
    style
        [ ( "padding", "10px 0" )
        , ( "font-size", "1.5em" )
        , ( "text-align", "left" )
        , ( "align", "center" )
        , ( "display", "block" )
        , ( "margin-left", "auto" )
        , ( "margin-right", "auto" )
        , ( "background-color", "#f3f6c6" )
        , ( "font-family", "monospace" )
        ]


btnStyle : Attribute msg
btnStyle =
    style
        [ ( "font-size", "1em" )
        , ( "text-align", "center" )
        ]



{- sample text in the VexTAb language -}


sampleVexText : String
sampleVexText =
    "stave \n"
        ++ "notation=true \n"
        ++ "key=A time=4/4 \n"
        ++ "notes :q =|: (5/2.5/3.7/4) :8 7-5h6/3 ^3^ 5h6-7/5 ^3^ :q 7V/4 |"
