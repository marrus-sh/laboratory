#  `动.Timeline`  #

##  Usage  ##

>   ```javascript
>       //  Fires when a status is added to the stream:
>       Timeline.StatusLoaded({stream: …, payload: …})
>       //  Fires when a status is deleted from the stream:
>       Timeline.StatusDeleted({stream: …, payload: …})
>       //  Fires when a new timeline is requested:
>       Timeline.Requested({name: …, component: …})
>       //  Fires when a timeline is removed:
>       Timeline.Removed({name: …, component: …})
>   ```
>   - **`stream` :** A string identifying the stream which triggered the event.
>   - **`payload` :** The payload associated with the event.
>   - **`component` :** A timeline component.

##  Object Initialization  ##

    此 = 动.Timeline = {}

##  Events  ##

###  `Timeline.StatusLoaded`:

The `Timeline.StatusLoaded` event has two properties: the `stream` it was fired from, and the `payload` it was issued with.

    此.StatusLoaded = 动.newBuilder 'LaboratoryTimelineStatusLoaded',
        stream: null,
        payload: null

###  `Timeline.StatusDeleted`:

The `Timeline.StatusDeleted` event has two properties: the `stream` it was fired from, and the `payload` it was issued with.

    此.StatusDeleted = 动.newBuilder 'LaboratoryTimelineStatusDeleted',
        stream: null,
        payload: null

###  `Timeline.Requested`:

The `Timeline.Requested` event has two properties: the `name` of the requested timeline and the `component` that it will be rendered in.

    此.Requested = 动.newBuilder 'LaboratoryTimelineRequested',
        name: null,
        component: null

###  `Timeline.Removed`:

The `Timeline.Removed` event has two properties: the `name` of the timeline and the `component` that was removed.

    此.Removed = 动.newBuilder 'LaboratoryTimelineRemoved',
        name: null,
        component: null

##  Object Freezing  ##

    冻 此
