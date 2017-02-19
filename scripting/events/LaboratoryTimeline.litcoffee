#  `研.events.LaboratoryTimeline`  #

##  Usage  ##

>   ```javascript
>       //  Fires when a status is added to the stream:
>       LaboratoryTimeline.StatusLoaded({stream: …, payload: …})
>       //  Fires when a status is deleted from the stream:
>       LaboratoryTimeline.StatusDeleted({stream: …, payload: …})
>   ```
>   - **`stream` :** A string identifying the stream which triggered the event.
>   - **`payload` :** The payload associated with the event.

##  Object Initialization  ##

    此 = 研.events.LaboratoryTimeline = {}

##  Events  ##

###  `LaboratoryTimeline.StatusLoaded`:

The `LaboratoryTimeline.StatusLoaded` event has two properties: the `stream` it was fired from, and the `payload` it was issued with.

    此.StatusLoaded = getEventBuilder 'LaboratoryStatusLoaded',
        stream: null,
        payload: null

###  `LaboratoryTimeline.StatusDeleted`:

The `LaboratoryTimeline.StatusDeleted` event has two properties: the `stream` it was fired from, and the `payload` it was issued with.

    此.StatusDeleted = getEventBuilder 'LaboratoryStatusDeleted',
        stream: null,
        payload: null

##  Object Freezing  ##

    Object.freeze 此
