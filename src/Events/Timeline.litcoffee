#  TIMELINE EVENTS  #

    Events.Timeline = Object.freeze

The __Timeline__ module of Laboratory Events is comprised of those events which are related to Mastodon timelines.
Laboratory makes no external distinction between timelines of statuses and timelines of notifications, and you can use these events to interface with both.

| Event / Builder | Description |
| :-------------- | :---------- |
| `LaboratoryTimelineRequested` / `Laboratory.Timeline.Requested` | Fires when a connection to a timeline is requested |
| `LaboratoryTimelineReceived` / `Laboratory.Timeline.Received` | Fires when information posts from a timeline have been received from the server. |
| `LaboratoryTimelineRemoved` / `Laboratory.Timeline.Removed` | Fires when a connection to a timeline should be removed |

##  `LaboratoryTimelineRequested`  ##

>   - __Builder :__ `Laboratory.Timeline.Requested`
>   - __Properties :__
>       - `name` – The name of the timeline.
>       - `callback` – The callback to associate with the timeline.
>       - `before` – The status id at which to end the timeline request.
>       - `after` – The status id at which to start the timeline request.

        Requested: new Constructors.LaboratoryEvent 'LaboratoryTimelineRequested',
            name: null
            callback: null
            before: null
            after: null

The `LaboratoryTimelineRequested` event requests a timeline's data, and associates a `callback` function to be called when the data is received.
You can optionally specify the range to pull the timeline from with `before` and `after`.

The `name` sent with the event is used to determine which timeline to fetch, and must take one of the following values:

- __`home` :__ Retrieves the user's home timeline.
- __`community` :__ Retrieves the local timeline.
- __`global` :__ Retrieves the global timeline.
- __`hashtag/…` :__ Retrieves the given hashtag.
- __`user/…` :__ Retrieves the timeline for the given user.
- __`notifications` :__ Retrieves the user's notifications timeline.

Timeline data is sent to callbacks via an immutable object with two properties.
The first, `postOrder`, is an array of the ids of every post in the timeline, in order from newest to oldest.
The second, `posts`, is an object whose properties are post ids and whose values are either [`Laboratory.Post`](../Constructors/Post.litcoffee) objects or (in the case of a notifications timeline) [`Laboratory.Follow`](../Constructors/Follow.litcoffee) objects.

##  `LaboratoryTimelineReceived`  ##

>   - __Builder :__ `Laboratory.Timeline.Received`
>   - __Properties :__
>       - `data` – The response from the server.
>       - `params` – Parameters passed through from the request.

        Received: new Constructors.LaboratoryEvent 'LaboratoryTimelineReceived',
            data: null
            params: null

The `LaboratoryTimelineReceived` event contains the server's response to a request for timeline data.
This data will be processed by the handler and sent to the associated callbacks, so it is unlikely you will need to interface with this event yourself.
The name of the timeline (see above) is stored in `params.name`, and the timeline data is stored as described in `data`.

When a timeline's data is processed, any embedded accounts will be dispatched to `LaboratoryAccountReceived`.
These will not necessarily be available in time for the callback itself (which is executed synchronously), but should be available in time for any asynchronous calls that the callback might trigger; for example, a call to the renderer.

##  `LaboratoryTimelineRemoved`  ##

>   - __Builder :__ `Laboratory.Timeline.Removed`
>   - __Properties :__
>       - `name` – The name of the timeline.
>       - `callback` – The callback to remove from the timeline.

        Removed: new Constructors.LaboratoryEvent 'LaboratoryTimelineRemoved',
            name: null
            callback: null

The `LaboratoryTimelineRemoved` event requests that a callback be removed from a timeline.
Unlike with accounts, timelines *must* have at least one callback associated with them or else their data will be deleted to free up memory.
Of course, this data can always be re-requested from the server at a later time.
