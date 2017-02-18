#  `/scripting/events/LaboratoryTimeline`  #

##  Usage  ##

>   ```javascript
>       //  Fires when a status is added to the stream:
>       LaboratoryStatusLoaded({stream: …, payload: …})
>       //  Fires when a status is deleted from the stream:
>       LaboratoryStatusDeleted({stream: …, payload: …})
>   ```
>   - **`stream` :** A string identifying the stream which triggered the event.
>   - **`payload` :** The payload associated with the event.

##  Imports  ##

The `getEventBuilder` function is used to create new event constructors.

    `import getEventBuilder from '../scripts/getEventBuilder'`

##  Events  ##

###  `LaboratoryStatusLoaded`:

The `LaboratoryStatusLoaded` event has two properties: the `stream` it was fired from, and the `payload` it was issued with.

    LaboratoryStatusLoaded = getEventBuilder 'LaboratoryStatusLoaded',
        stream: null,
        payload: null

###  `LaboratoryStatusDeleted`:

The `LaboratoryStatusDeleted` event has two properties: the `stream` it was fired from, and the `payload` it was issued with.

    LaboratoryStatusDeleted = getEventBuilder 'LaboratoryStatusDeleted',
        stream: null,
        payload: null

##  Exports  ##

This package exports the events listed above.

    `export {
        LaboratoryStatusLoaded,
        LaboratoryStatusDeleted
    };`
