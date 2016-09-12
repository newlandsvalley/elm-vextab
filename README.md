elm-vextab
==========

This is a simple Elm module that wraps [VexTab](http://www.vexflow.com/vextab/) which is a language for creating and editing musical scores. Vextab itself is an open-source [javascript project](https://github.com/0xfe/vextab) and is still in a pre-alpha stage.  

VexTab renders a score by side-effect.  You must create a __canvas__ tag in your web page, assign it an __id__ and initialise the module with the id name.  You can then can ask it to render some VexTab text - if it is valid then the score will appear in the canvas, otherwise an error will be returned.  You do __not__ need to incorporate the canvas into your elm view.

## Integrating the module

Because we are wrapping a javascript module, our only option is to use ports, and so the integration of the various pieces of javascript that go to make up a final web page have to be assembled by hand - see  examples/basic.html for an example.  

The module exposes the following:


```elm
    Model, Msg(RequestRenderScore), init, update, subscriptions 
``` 
    
This can be imported into a main elm program using the normal conventions. It is usually sensible to initialise vextab when the program starts. For example, here we have provided a canvas with an id of __vextab__:

```elm
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
```

The Model used by the module in fact only contains a possible error message which will be returned if the module cannot be initialised or if the text cannot be parsed.  
  
It exposes a single message - __RequestRenderScore__ which you use to request that sample text is rendered.  There are two subscriptions:

```elm
    initialisedSub
    renderedSub
``` 

although normally there is no need to register these - instead, you may simply check for any error in the vextab model after either initialising or after requesting a score rendering.