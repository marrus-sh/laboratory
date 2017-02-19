#  `研.events.LaboratoryStream`  #

##  Usage  ##

>   ```javascript
>       //  Fires when a WebSocket stream is opened:
>       LaboratoryStream.Open({stream: …})
>       //  Fires when a WebSocket stream is closed:
>       LaboratoryStream.Close({stream: …, code: …})
>       //  Fires when a WebSocket stream receives a message:
>       LaboratoryStream.Message({stream: …, data: …})
>       //  Fires when a WebSocket stream receives an error:
>       LaboratoryStream.Error({stream: …})
>   ```
>   - **`stream` :** A string identifying the stream which triggered the event.
>   - **`code` :** A numberic code issued when the stream was closed.
>   - **`data` :** The data contained in the message.

##  Object Initialization  ##

    此 = 研.events.LaboratoryStream = {}

##  Events  ##

###  `LaboratoryStream.Open`:

The `LaboratoryStream.Open` event has a single property: the `stream` it was fired from.

    此.Open = getEventBuilder 'LaboratoryOpen',
        stream: null

###  `LaboratoryStream.Close`:

The `LaboratoryStream.Close` event has two properties: the `stream` it was fired from, and the `code` issued when closing.

    此.Close = getEventBuilder 'LaboratoryClose',
        stream: null
        code: 1000

###  `LaboratoryStream.Message`:

The `LaboratoryStream.Message` event has two properties: the `stream` it was fired from, and the message's `data`.

    此.Message = getEventBuilder 'LaboratoryMessage',
        stream: null
        data: null

###  `LaboratoryStream.Error`:

The `LaboratoryStream.Error` event has a single property: the `stream` it was fired from.

    此.Error = getEventBuilder 'LaboratoryError',
        stream: null

##  Object Freezing  ##

    Object.freeze 此
