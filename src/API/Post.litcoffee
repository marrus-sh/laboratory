<p align="right">_Laboratory_ <br> Source Code and Documentation <br> API Version: _0.3.1_</p>

#  POST EVENTS  #

>   File location: `API/Post.litcoffee`

 - - -

##  Description  ##

The __Post__ module of the Laboratory API is comprised of those events which are related to Mastodon accounts.

###  Quick reference:

| Event | Description |
| :---- | :---------- |
| `LaboratoryPostRequested` | Requests a `Laboratory.Post` for a specified status or notification |
| `LaboratoryPostReceived` | Fires when a `Laboratory.Post` has been processed |
| `LaboratoryPostFailed` | Fires when a `Laboratory.Post` fails to process |
| `LaboratoryPostCreation` | Petitions the Mastodon server to create a new status |
| `LaboratoryPostDeletion` | Petitions the Mastodon server to delete the provided status |
| `LaboratoryPostSetReblog` | Petitions the Mastodon server to reblog or unreblog the provided status |
| `LaboratoryPostSetFavourite` | Petitions the Mastodon server to favourite or unfavourite the provided status |

###  Requesting a status:

>   - __API equivalent :__ `/api/v1/statuses/:id`, `/api/v1/notifications/:id`
>   - __Request parameters :__
>       - __`id` :__ The id of the status or notification to request
>       - __`type` :__ A `Post.Type` (default: `Post.Type.STATUS`)
>   - __Request :__ `LaboratoryPostRequested`
>   - __Response :__ `LaboratoryPostReceived`
>   - __Failure :__ `LaboratoryPostFailed`

Laboratory Post events are used to request [`Post`](../Constructors/Post.litcoffee)s containing data on a specified status or notification.
The request, `LaboratoryPostRequested`, takes an object whose `id` parameter specifies the account to fetch and whose `type` specifies whether the post is a status or notification.

Laboratory keeps track of all of the `Post`s it receives in its internal store.
If there is already information on the requested `Post` in the Laboratory store, it will fire `LaboratoryPostReceived` immediately, and then again once the server request completes.
However, Laboratory will only fire as many responses as necessary; if nothing has changed from the stored value, then only one response will be given.

###  Creating and deleting posts:

>   - __API equivalent :__ `/api/v1/statuses`, `/api/v1/statuses/:id`
>   - __Miscellaneous events :__
>       - `LaboratoryPostCreation`
>       - `LaboratoryPostDeletion`

The `LaboratoryPostCreation` event attempts to create a new status on the Mastodon server.
It should be fired with a `detail` containing the following properties:

- __`text` :__ The text of the post
- __`visibility` :__ A `Post.Visibility` (default: `Post.Visibility.PRIVATE`)
- __`inReplyTo` :__ A status id if the post is a reply
- __`attachments` :__ An array of `Attachment`s
- __`message` :__ A content/spoiler warning
- __`makeNSFW` :__ Whether or not the attached media contains NSFW content (default: `true`)

The `LaboratoryPostDeletion` event attempts to delete an existing status from the Mastodon server.
The `id` property of its `detail` should provide the id of the status to delete.

###  Favouriting and reblogging posts:

>   - __API equivalent :__ `/api/v1/statuses/:id/reblog`, `/api/v1/statuses/:id/unreblog`, `/api/v1/statuses/:id/favourite`, `/api/v1/statuses/:id/unfavourite`
>   - __Miscellanous events :__
>       - `LaboratoryPostSetReblog`
>       - `LaboratoryPostSetFavourite`

The `LaboratoryPostSetReblog` and `LaboratoryPostSetFavourite` events can be used to set the reblog or favourite status of posts.
They should be fired with a `detail` which has two properties: `id`, which gives the id of the account, and `value`, which should be `true` if the post should be favourited/reblogged, or `false` if it should be unfavourited/unreblogged.

 - - -

##  Implementation  ##

###  Creating the events:

Here we create the events as per our specifications.

    LaboratoryEvent
        .create "LaboratoryPostRequested",
            id: undefined
            type: Post.Type.STATUS
        .create "LaboratoryPostReceived", Post
        .create "LaboratoryPostFailed", Failure
        .associate "LaboratoryPostRequested", "LaboratoryPostReceived", "LaboratoryPostFailed"

        .create "LaboratoryPostCreation",
            text: ""
            visibility: Post.Visibility.PRIVATE
            inReplyTo: undefined
            attachments: undefined
            message: undefined
            makeNSFW: yes
        .create "LaboratoryPostDeletion",
            id: undefined

        .create "LaboratoryPostSetReblog",
            id: undefined
            value: on
        .create "LaboratoryPostSetFavourite",
            id: undefined
            value: on

###  Handling the events:

Laboratory provides handlers for the following Authorization events:

- `LaboratoryPostRequested`
- `LaboratoryPostReceived`
- `LaboratoryPostCreation`
- `LaboratoryPostDeletion`
- `LaboratoryPostSetReblog`
- `LaboratoryPostSetFavourite`

####  `LaboratoryPostRequested`.

The `LaboratoryPostRequested` event requests a status or notification from the Mastodon API, processes it, and fires a `LaboratoryPostReceived` event with the resultant `Post`.

        .handle "LaboratoryPostRequested", (event) ->

            unless isFinite id = Number event.detail.id
                dispatch "LaboratoryPostFailed", new Failure "Unable to fetch post; no id specified", "LaboratoryPostRequested"
                return
            unless (type = event.detail.type) instanceof Post.Type
                dispatch "LaboratoryPostFailed", new Failure "Unable to fetch post; no type specified", "LaboratoryPostRequested"
                return
            isANotification = type & Post.Type.Notification

If we already have information for the specified post loaded into our `Store`, we can go ahead and fire a `LaboratoryPostReceived` event with that information now.

            dispatch "LaboratoryPostReceived", Store.statuses[id] if not isANotification and Store.statuses[id]?
            dispatch "LaboratoryPostReceived", Store.notifications[id] if isANotification and Store.notifications[id]?

When our new post data is received, we'll process it and do the same—*if* something has changed.

            onComplete = (response, data, params) ->
                unless response.id is id
                    dispatch "LaboratoryPostFailed", new Failure "Unable to fetch post; returned post did not match requested id", "LaboratoryPostRequested"
                    return
                post = new Post response
                unless (post.type & Post.Type.NOTIFICATION) is isANotification
                    dispatch "LaboratoryPostFailed", new Failure "Unable to fetch post; returned post was not of specified type", "LaboratoryPostRequested"
                    return
                store = if isANotification then Store.notifications else Store.statuses
                dispatch "LaboratoryPostReceived", post unless post.compare store[id]
                return

If something goes wrong, then we need to throw an error.

            onError = (response, data, params) ->
                dispatch "LaboratoryPostFailed", new Failure response.error, "LaboratoryPostRequested", params.status
                return

Finally, we can make our server request.

            serverRequest "GET", Store.auth.origin + (if isANotification then "/api/v1/notifications/" else "/api/v1/statuses/") + id, null, Store.auth.accessToken, onComplete, onError

            return

####  `LaboratoryPostReceived`.

The `LaboratoryPostReceived` event simply adds a received post to our store.

        .handle "LaboratoryPostReceived", (event) ->
            return unless event.detail instanceof Post and event.detail.type instanceof Post.Type and isFinite id = Number event.detail.id
            (if event.detail.type & Post.Type.NOTIFICATION then Store.notifications else Store.statuses)[id] = event.detail
            return

####  `LaboratoryPostCreation`.

The `LaboratoryPostCreation` event attempts to create a new status, and fires a `LaboratoryPostReceived` event with the new `Post` if it succeeds.

        .handle "LaboratoryPostCreation", (event) ->

            onComplete = (response, data, params) ->
                dispatch "LaboratoryPostReceived", new Post response
                return

            onError = (response, data, params) ->
                dispatch "LaboratoryPostFailed", new Failure response.error, "LaboratoryPostCreation", params.status
                return

            serverRequest "POST", Store.auth.origin + "/api/v1/statuses/", (
                status: event.detail.text
                in_reply_to_id: if (inReplyTo = event.detail.inReplyTo) > 0 and isFinite inReplyTo then inReplyTo else undefined
                media_ids: if (attachments = event.detail.attachments) instanceof Array then (attachment.id for attachment in attachments when attachment instanceof Attachment) else undefined
                sensitive: if event.detail.makeNSFW then "true" else undefined
                spoiler_text: if (message = event.detail.message) then String message else undefined
                visibility: switch event.detail.visibility
                    when Post.Visibility.PUBLIC then "public"
                    when Post.Visibility.REBLOGGABLE then "unlisted"
                    else "private"
            ), Store.auth.accessToken, onComplete, onError

####  `LaboratoryPostDeletion`.

The `LaboratoryPostDeletion` event attempts to delete an existing status.

        .handle "LaboratoryPostDeletion", (event) ->

            unless isFinite id = Number event.detail.id
                dispatch "LaboratoryPostFailed", new Failure "Unable to delete post; no id specified", "LaboratoryPostDeletion"
                return

            onComplete = ->
            onError = (response, data, params) ->
                dispatch "LaboratoryPostFailed", new Failure response.error, "LaboratoryPostDeletion", params.status
                return

            serverRequest "DELETE", Store.auth.origin + "/api/v1/statuses/" + id, null, Store.auth.accessToken, onComplete, onError

####  `LaboratoryPostSetReblog`.

The `LaboratoryPostSetReblog` event attempts to set the reblog status of a post according to the specified `value`.
It will fire a new `LaboratoryPostReceived` event updating the post's information if it succeeds.

        .handle "LaboratoryPostSetReblog", (event) ->

Obviously we need an `id` and `value` to do our work.

            dispatch "LaboratoryPostFailed", new Failure "Cannot set reblog status for post: Either value or id is missing", "LaboratoryPostSetReblog" unless (value = !!event.detail.value)? and isFinite id = Number event.detail.id

Here we handle the server response for our relationship setting:

            onComplete = (response, data, params) ->
                dispatch "LaboratoryPostReceived", new Post response
                return

            onError = (response, data, params) ->
                dispatch "LaboratoryPostFailed", new Failure response.error, "LaboratoryPostSetReblog", params.status
                return

If we already have a post for the specified id loaded into our `Store`, then we can test its current reblog value to avoid unnecessary requests.
We'll only send the request if the values differ.

            serverRequest "POST", Store.auth.origin + "/api/v1/statuses/" + id + (if value then "/reblog" else "/unreblog"), null, Store.auth.accessToken, onComplete, onError unless Store.statuses[id]?.isReblogged is value

            return

####  `LaboratoryPostSetFavourite`.

The `LaboratoryPostSetFavourite` event attempts to set the favourite status of a post according to the specified `value`.
It will fire a new `LaboratoryPostReceived` event updating the post's information if it succeeds.

        .handle "LaboratoryPostSetFavourite", (event) ->

Obviously we need an `id` and `value` to do our work.

            dispatch "LaboratoryPostFailed", new Failure "Cannot set favourite status for post: Either value or id is missing", "LaboratoryPostSetFavourite" unless (value = !!event.detail.value)? and isFinite id = Number event.detail.id

Here we handle the server response for our relationship setting:

            onComplete = (response, data, params) ->
                dispatch "LaboratoryPostReceived", new Post response
                return

            onError = (response, data, params) ->
                dispatch "LaboratoryPostFailed", new Failure response.error, "LaboratoryPostSetFavourite", params.status
                return

If we already have a post for the specified id loaded into our `Store`, then we can test its current favourite value to avoid unnecessary requests.
We'll only send the request if the values differ.

            serverRequest "POST", Store.auth.origin + "/api/v1/statuses/" + id + (if value then "/favourite" else "/unfavourite"), null, Store.auth.accessToken, onComplete, onError unless Store.statuses[id]?.isFavourited is value

            return
