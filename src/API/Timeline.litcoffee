<p align="right">_Laboratory_ <br> Source Code and Documentation <br> API Version: _0.3.1_</p>

#  TIMELINE EVENTS  #

>   File location: `API/Timeline.litcoffee`

 - - -

##  Description  ##

The __Timeline__ module of the Laboratory API is comprised of those events which are related to timelines of Mastodon accounts.

###  Quick reference:

| Event | Description |
| :---- | :---------- |
| `LaboratoryTimelineRequested` | Requests a `Laboratory.Timeline` for a specified query |
| `LaboratoryTimelineReceived` | Fires when a `Laboratory.Timeline` has been processed |
| `LaboratoryTimelineFailed` | Fires when a `Laboratory.Timeline` fails to process |

###  Requesting a timeline:

>   - __API equivalent :__ `/api/v1/timelines/home`, `/api/v1/timelines/public`, `/api/v1/timelines/tag/:hashtag`, `/api/v1/notifications/`, `/api/v1/favourites`
>   - __Request parameters :__
>       - __`type` :__ The [`Laboratory.Timeline.Type`](../Constructors/Timeline.litcoffee) of the `Timeline`
>       - __`query` :__ The associated query
>       - __`before` :__ The id at which to end the timeline
>       - __`after` :__ The id at which to begin the timeline
>   - __Request :__ `LaboratoryTimelineRequested`
>   - __Response :__ `LaboratoryTimelineReceived`
>   - __Failure :__ `LaboratoryTimelineFailed`

Laboratory Timeline events are used to request lists of [`Post`](../Constructors/Post.litcoffee)s according to the specified `type` and `query`.
If the `type` is `Timeline.Type.HASHTAG`, then `query` should provide the hashtag; in the case of `Timeline.Type.ACCOUNT`, then `query` should provide the account id; otherwise, no `query` is required.

The `before` and `after` parameters can be used to change the range of statuses returned.

 - - -

##  Implementation  ##

###  Creating the events:

Here we create the events as per our specifications.

    LaboratoryEvent
        .create "LaboratoryTimelineRequested",
            type: Timeline.Type.HOME
            query: ""
            before: undefined
            after: undefined
        .create "LaboratoryTimelineReceived", Timeline
        .create "LaboratoryTimelineFailed", Failure
        .associate "LaboratoryTimelineRequested", "LaboratoryTimelineReceived", "LaboratoryTimelineFailed"

###  Handling the events:

Laboratory provides handlers for the following Authorization events:

- `LaboratoryTimelineRequested`

####  `LaboratoryTimelineRequested`.

The `LaboratoryTimelineRequested` event requests an account from the Mastodon API, processes it, and fires a `LaboratoryTimelineReceived` event with the resultant `Timeline`.

        .handle "LaboratoryTimelineRequested", (event) ->

            query = String event.detail.query
            before = null unless isFinite before = Number event.detail.before
            after = null unless isFinite after = Number event.detail.after
            unless (type = event.detail.type) instanceof Timeline.Type and type isnt Timeline.Type.UNDEFINED
                dispatch "LaboratoryTimelineFailed", new Failure "Unable to fetch timeline; no type specified", "LaboratoryTimelineRequested"
                return

When our list of accounts is received, we'll process it and call a `LaboratoryTimelineReceived` event with the resulting `Timeline`.
We'll also dispatch a `LaboratoryPostReceived` event with each post contained in the response, and a `LaboratoryProfileReceived` containing the profile data of each post author and mention.

>   __Note :__
>   In order to prevent duplicates, `LaboratoryPostReceived` only fires for unique ids in the API response.
>   While it is possible for a status to have the same id as a (different) notification, we don't need to worry about this since statuses and notifications are never grouped together by the Mastodon API.

>   __Note :__
>   Note that the account data provided by mentions is not as complete as that which would be in a normal API response.

            onComplete = (response, data, params) ->
                acctIDs = []
                mentions = []
                mentionIDs = []
                ids = []
                for status in response when (ids.indexOf status.id) is -1 and ids.push status.id
                    dispatch "LaboratoryProfileReceived", new Profile status.account if (acctIDs.indexOf status.account.id) is -1 and acctIDs.push status.account.id
                    dispatch "LaboratoryProfileReceived", new Profile status.status.account if status.status?.account? and (acctIDs.indexOf status.status.account.id) is -1 and acctIDs.push status.status.account.id
                    dispatch "LaboratoryProfileReceived", new Profile status.reblog.account if status.reblog?.account? and (acctIDs.indexOf status.reblog.account.id) is -1 and acctIDs.push status.reblog.account.id
                    if status.mentions instanceof Array
                        for account in status.mentions when (mentionIDs.indexOf account.id) is -1
                            mentionIDs.push account.id
                            mentions.push account
                    dispatch "LaboratoryPostReceived", new Post status
                dispatch "LaboratoryProfileReceived", new Profile mention for mention in mentions when (acctIDs.indexOf mention.id) is -1 and not Store.profiles[mention.id]?
                dispatch "LaboratoryTimelineReceived", new Timeline response,
                    type: type
                    query: query
                    before: ((params.prev.match /.*since_id=([0-9]+)/) or [])[1]
                    after: ((params.next.match /.*max_id=([0-9]+)/) or [])[1]
                return

If something goes wrong, then we need to throw an error.

            onError = (response, data, params) ->
                dispatch "LaboratoryTimelineFailed", new Failure response.error, "LaboratoryTimelineRequested", params.status
                return

Finally, we can make our server request.
Note that `serverRequest` ignores data parameters which have a value of `undefined` or `null`.

            serverRequest "GET", Store.auth.origin + (
                switch type
                    when Timeline.Type.HASHTAG then "/api/v1/timelines/tag/" + query
                    when Timeline.Type.LOCAL then "/api/v1/timelines/public"
                    when Timeline.Type.GLOBAL then "/api/v1/timelines/public"
                    when Timeline.Type.HOME then "/api/v1/timelines/home"
                    when Timeline.Type.NOTIFICATIONS then "/api/v1/notifications"
                    when Timeline.Type.FAVOURITES then "/api/v1/favourites"
                    when Timeline.Type.ACCOUNT then "/api/v1/accounts/" + query + "/statuses"
                    else "/api/v1"
            ), (
                switch type
                    when Timeline.Type.LOCAL
                        local: yes
                        max_id: before
                        since_id: after
                    else
                        max_id: before
                        since_id: after
            ), Store.auth.accessToken, onComplete, onError

            return
