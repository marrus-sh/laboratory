#  `动.Stream`  #

##  Usage  ##

>   ```javascript
>       //  Fires when a WebSocket stream is opened:
>       Stream.Open({stream: …})
>       //  Fires when a WebSocket stream is closed:
>       Stream.Close({stream: …, code: …})
>       //  Fires when a WebSocket stream receives a message:
>       Stream.Message({stream: …, data: …})
>       //  Fires when a WebSocket stream receives an error:
>       Stream.Error({stream: …})
>   ```
>   - **`stream` :** A string identifying the stream which triggered the event.
>   - **`code` :** A numberic code issued when the stream was closed.
>   - **`data` :** The data contained in the message.

##  Object Initialization  ##

    此 = 动.Stream = {}

##  Events  ##

###  `Stream.Open`:

The `Stream.Open` event has a single property: the `stream` it was fired from.

    此.Open = 动.newBuilder 'LaboratoryStreamOpen',
        stream: null

###  `Stream.Close`:

The `Stream.Close` event has two properties: the `stream` it was fired from, and the `code` issued when closing.

    此.Close = 动.newBuilder 'LaboratoryStreamClose',
        stream: null
        code: 1000

###  `Stream.Message`:

The `Stream.Message` event has two properties: the `stream` it was fired from, and the message's `data`.

    此.Message = 动.newBuilder 'LaboratoryStreamMessage',
        stream: null
        data: null

###  `Stream.Error`:

The `Stream.Error` event has a single property: the `stream` it was fired from.

    此.Error = 动.newBuilder 'LaboratoryStreamError',
        stream: null

##  Object Freezing  ##

    冻 此
