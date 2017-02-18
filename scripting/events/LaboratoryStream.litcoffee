#  `/scripting/events/LaboratoryStream`  #

##  Usage  ##

>   ```javascript
>       //  Fires when a WebSocket stream is opened:
>       LaboratoryOpen({stream: …})
>       //  Fires when a WebSocket stream is closed:
>       LaboratoryClose({stream: …, code: …})
>       //  Fires when a WebSocket stream receives a message:
>       LaboratoryMessage({stream: …, data: …})
>       //  Fires when a WebSocket stream receives an error:
>       LaboratoryError({stream: …})
>   ```
>   - **`stream` :** A string identifying the stream which triggered the event.
>   - **`code` :** A numberic code issued when the stream was closed.
>   - **`data` :** The data contained in the message.

##  Imports  ##

The `getEventBuilder` function is used to create new event constructors.

    `import getEventBuilder from '../scripts/getEventBuilder'`

##  Events  ##

###  `LaboratoryOpen`:

The `LaboratoryOpen` event has a single property: the `stream` it was fired from.

    LaboratoryOpen = getEventBuilder 'LaboratoryOpen',
        stream: null

###  `LaboratoryClose`:

The `LaboratoryClose` event has two properties: the `stream` it was fired from, and the `code` issued when closing.

    LaboratoryClose = getEventBuilder 'LaboratoryClose',
        stream: null
        code: 1000

###  `LaboratoryMessage`:

The `LaboratoryMessage` event has two properties: the `stream` it was fired from, and the message's `data`.

    LaboratoryMessage = getEventBuilder 'LaboratoryMessage',
        stream: null
        data: null

###  `LaboratoryError`:

The `LaboratoryError` event has a single property: the `stream` it was fired from.

    LaboratoryError = getEventBuilder 'LaboratoryError',
        stream: null

##  Exports  ##

This package exports the events listed above.

    `export {
        LaboratoryOpen,
        LaboratoryClose,
        LaboratoryMessage,
        LaboratoryError
    };`
