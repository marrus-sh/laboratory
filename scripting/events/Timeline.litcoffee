#  `Laboratory.Events.Timeline`  #

##  Usage  ##

>   ```javascript
>       //  Fires when a new timeline is requested:
>       Timeline.Requested({name: …, component: …, before: …, since: …})
>       //  Fires when a timeline is received:
>       Timeline.Received({data: …, prev: …, next: …, params: …})
>       //  Fires when a timeline is removed:
>       Timeline.Removed({name: …, component: …})
>       //  Fires when a status is added to the stream:
>       Timeline.StatusLoaded({stream: …, payload: …})
>       //  Fires when a status is deleted from the stream:
>       Timeline.StatusDeleted({stream: …, payload: …})
>   ```
>   - **`stream` :** A string identifying the stream which triggered the event.
>   - **`payload` :** The payload associated with the event.
>   - **`name` :** The name of the timeline.
>   - **`component` :** A timeline component.
>   - **`before` :** Only show posts younger than this ID.
>   - **`since` :** Only show posts older than this ID.
>   - **`data` :** The JSON timeline data.
>   - **`prev` :** The url for the previous page of the request.
>   - **`next` :** The url for the next page of the request.
>   - **`params` :** Parameters passed through the request.

##  Object Initialization  ##

    current = Laboratory.Events.Timeline = {}

##  Events  ##

###  `Timeline.StatusLoaded`:

The `Timeline.StatusLoaded` event has two properties: the `stream` it was fired from, and the `payload` it was issued with.

    current.StatusLoaded = Laboratory.Events.newBuilder 'LaboratoryTimelineStatusLoaded',
        stream: null
        payload: null

###  `Timeline.StatusDeleted`:

The `Timeline.StatusDeleted` event has two properties: the `stream` it was fired from, and the `payload` it was issued with.

    current.StatusDeleted = Laboratory.Events.newBuilder 'LaboratoryTimelineStatusDeleted',
        stream: null
        payload: null

###  `Timeline.Requested`:

The `Timeline.Requested` event has two properties: the `name` of the requested timeline and the `component` that it will be rendered in.

    current.Requested = Laboratory.Events.newBuilder 'LaboratoryTimelineRequested',
        name: null
        component: null
        before: null
        since: null

###  `Timeline.Received`:

The `Timeline.Received` event has one property: the `data` of the response.

    current.Received = Laboratory.Events.newBuilder 'LaboratoryTimelineReceived',
        data: null
        params: null
        prev: null
        next: null

###  `Timeline.Removed`:

The `Timeline.Removed` event has two properties: the `name` of the timeline and the `component` that was removed.

    current.Removed = Laboratory.Events.newBuilder 'LaboratoryTimelineRemoved',
        name: null
        component: null

##  Object Freezing  ##

    Object.freeze current
