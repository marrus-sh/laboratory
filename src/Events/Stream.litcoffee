#  `Laboratory.Events.Stream`  #

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

    Laboratory.Events.Stream = {}

##  Events  ##

###  `Stream.Open`:

The `Stream.Open` event has a single property: the `stream` it was fired from.

    Laboratory.Events.Stream.Open = Laboratory.Events.newBuilder 'LaboratoryStreamOpen',
        stream: null

###  `Stream.Close`:

The `Stream.Close` event has two properties: the `stream` it was fired from, and the `code` issued when closing.

    Laboratory.Events.Stream.Close = Laboratory.Events.newBuilder 'LaboratoryStreamClose',
        stream: null
        code: 1000

###  `Stream.Message`:

The `Stream.Message` event has two properties: the `stream` it was fired from, and the message's `data`.

    Laboratory.Events.Stream.Message = Laboratory.Events.newBuilder 'LaboratoryStreamMessage',
        stream: null
        data: null

###  `Stream.Error`:

The `Stream.Error` event has a single property: the `stream` it was fired from.

    Laboratory.Events.Stream.Error = Laboratory.Events.newBuilder 'LaboratoryStreamError',
        stream: null

##  Object Freezing  ##

    Object.freeze Laboratory.Events.Stream
