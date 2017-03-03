#  STATUS HANDLERS  #

    Handlers.Status = Object.freeze

##  `LaboratoryStatusRequested`  ##

When a `LaboratoryStatusRequested` event is fired, we send the server a request for a status and pass the result simultaneously to our callback and to `LaboratoryStatusReceived`.

        Requested: handle Events.Status.Requested, (event) ->

            return unless isFinite(id = Number event.detail.id)
            callback = null unless typeof (callback = event.detail.callback) is "function"

            serverRequest "GET", @auth.api + "/statuses/" + id, null, @auth.accessToken, (response) ->
                Events.Status.Received response
                callback Constructors.Post response.data if callback

            return

##  `LaboratoryStatusReceived`  ##

The `LaboratoryStatusReceived` event attempts to update any timelines which contain a given status with new information.
We just call a `LaboratoryTimelineReceived` event for each affected timeline with an array containing the status.

        Received: handle Events.Status.Received, (event) ->

            timelinesToUpdate = (name for name, timeline of @timelines when event.detail.data.id in timeline.postOrder)
            Events.Timeline.Received {data: [event.detail.data], params: {name}} for name in timelinesToUpdate

            return

##  `LaboratoryStatusReblogs`  ##

When a `LaboratoryStatusReblogs` event is fired, we simply petition the server for a list of users who reblogged the given status, and pass this to our callback.
We wrap the callback in a function which formats the user list for us.

        Reblogs: handle Events.Status.Reblogs, (event) ->

            return unless isFinite(id = Number event.detail.id) and typeof (callback = event.detail.callback) is "function"

            query = ""
            query += "?max_id=" + Number event.detail.before if isFinite event.detail.before
            query += (if query then "&" else "?") + "since_id=" + Number event.detail.after if isFinite event.detail.after

            serverRequest "GET", @auth.api + "/statuses/" + id + "/reblogged_by" + query, null, @auth.accessToken, (response) -> callback(Constructors.Profile(data) for data in response.data)

##  `LaboratoryStatusFavourites`  ##

When a `LaboratoryStatusFavourites` event is fired, we simply petition the server for a list of users who favourited the given status, and pass this to our callback.
We wrap the callback in a function which formats the list for us.

        Favourites: handle Events.Status.Favourites (event) ->

            return unless isFinite(id = Number event.detail.id) and typeof (callback = event.detail.callback) is "function"

            query = ""
            query += "?max_id=" + Number event.detail.before if isFinite event.detail.before
            query += (if query then "&" else "?") + "since_id=" + Number event.detail.after if isFinite event.detail.after

            serverRequest "GET", @auth.api + "/statuses/" + id + "/favourited_by" + query, null, @auth.accessToken, (response) -> callback(Constructors.Profile(data) for data in response.data)

##  `LaboratoryStatusSetReblog`  ##

When a `LaboratoryStatusSetReblog` event is fired, we send the server a request to reblog/unreblog the specified status.
We issue `Events.Status.Received()` as our callback function, with the response from the server.
This will be (in the case of a reblog) a new reblog-post, or (in the case of an unreblog) the original.

        Follow: handle Events.Status.SetReblog, (event) ->

            return unless isFinite(id = Number event.detail.id)

            serverRequest "POST", @auth.api + "/statuses/" + id + (if event.detail.value then "/reblog" else "/unreblog"), null, @auth.accessToken, Events.Status.Received

##  `LaboratoryStatusSetFavourite`  ##

When a `LaboratoryStatusSetFavourite` event is fired, we send the server a request to favourite/unfavourite the specified status.
We issue `Events.Status.Received()` as our callback function, since the result of this request should be an updated representation of the favourited status.

        SetFavourite: handle Events.Status.SetFavourite, (event) ->

            return unless isFinite(id = Number event.detail.id)

            serverRequest "POST", @auth.api + "/statuses/" + id + (if event.detail.value then "/favourite" else "/unfavourite"), null, @auth.accessToken, Events.Status.Received

##  `LaboratoryStatusDeletion`  ##

When a `LaboratoryStatusDeletion` event is fired, we send the server a request to delete the specified status.
We also need to update any timelines which used to contain the status such that they don't any longer.

        Deletion: handle Events.Status.Deletion, (event) ->

            return unless isFinite(id = Number event.detail.id)

            serverRequest "DELETE", @auth.api + "/statuses/" + id, null, @auth.accessToken

            timelinesToUpdate = (name for name, timeline of @timelines when id in timeline.postOrder)
            Events.Timeline.Received {data: [{id}], params: {name}} for name in timelinesToUpdate
