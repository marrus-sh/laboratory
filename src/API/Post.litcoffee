<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.4.0</i> <br> <code>API/Post.litcoffee</code></p>

#  POST REQUESTS  #

 - - -

##  Description  ##

The __Post__ module of the Laboratory API is comprised of those requests which are related to Mastodon statuses and notifications.

###  Quick reference:

####  Requests.

| Request | Description |
| :------ | :---------- |
| `Post.Request()` | Requests a `Post` from the Mastodon server |
| `Post.Create()` | Petitions the Mastodon server to create a new status |
| `Post.Delete()` | Petitions the Mastodon server to delete an existing status |
| `Post.SetReblog()` | Petitions the Mastodon server to reblog or unreblog the provided status |
| `Post.SetFavourite()` | Petitions the Mastodon server to favourite or unfavourite the provided status |

####  Events.

| Event | Description |
| :---- | :---------- |
| `LaboratoryPostReceived` | Fires when a `Post` has been processed |
| `LaboratoryPostDeleted` | Fires when a `Post` has been deleted |

###  Requesting a post:

>   ```javascript
>   request = new Laboratory.Post.Request(data, isLive, useCached);
>   ```
>
>   - __API equivalent :__ `/api/v1/statuses/:id`, `/api/v1/notifications/:id`
>   - __Data parameters :__
>       - __`id` :__ The id of the status or notification to request
>       - __`type` :__ A `Post.Type` (default: `Post.Type.STATUS`)
>   - __Response :__ A [`Post`](../Constructors/Post.litcoffee)

Laboratory `Post.Request`s are used to request [`Post`](../Constructors/Post.litcoffee)s containing data on a specified status or notification.
The request takes an object whose `id` parameter specifies the account to fetch and whose `type` specifies whether the post is a status or notification.

Post requests may be either __static__ or __live__.
Static post requests don't update their responses when new information is received from the server, whereas live post requests do.
This behaviour is controlled by the `isLive` argument, which defaults to `true`.

>   __Note :__
>   You can call `request.stop()` to stop a live `Post.Request`, and `request.start()` to start it up again.
>   Always call `request.stop()` when you are finished using a live request to allow it to be freed from memory.

Laboratory keeps track of all of the `Post`s it receives in its internal store.
If the `useCached` argument is `true` (the default), then it will immediately load the stored value into its response if available.
It will still request the server for updated information unless `isLive` is `false`.

###  Creating new statuses:

>   ```javascript
>   request = new Laboratory.Post.Create(data);
>   ```
>
>   - __API equivalent :__ `/api/v1/statuses`
>   - __Data parameters :__
>       - __`text` :__ The text of the post
>       - __`visibility` :__ A `Post.Visibility` (default: `Post.Visibility.PRIVATE`)
>       - __`inReplyTo` :__ A status id if the post is a reply
>       - __`attachments` :__ An array of `Attachment`s
>       - __`message` :__ A content/spoiler warning
>       - __`makeNSFW` :__ Whether or not the attached media contains NSFW content (default: `true`)
>   - __Response :__ A [`Post`](../Constructors/Post.litcoffee)

`Post.Create()` attempts to create a new status on the Mastodon server.
You can see the parameters it accepts above.

###  Deleting statuses:

>   ```javascript
>   request = new Laboratory.Post.Delete(data);
>   ```
>
>   - __API equivalent :__ `/api/v1/statuses`
>   - __Data parameters :__
>       - __`id` :__ The id of the post to delete
>   - __Response :__ `null`

`Post.Delete()` event attempts to delete an existing status from the Mastodon server.
The `id` parameter provides the id of the status to delete.

###  Reblogging and favouriting posts:

>   ```javascript
>   request = new Laboratory.Post.SetReblog(data);
>   request = new Laboratory.Post.SetFavourite(data);
>   ```
>
>   - __API equivalent :__ `/api/v1/statuses/:id/reblog`, `/api/v1/statuses/:id/unreblog`
>   - __Data parameters :__
>       - __`id` :__ The id of the status to reblog
>       - __`value` :__ `true` if the post should be reblogged/favourited, `false` if the post should be unreblogged/unfavourited
>   - __Response :__ A [`Post`](../Constructors/Post.litcoffee)

`Post.SetReblog()` and `Post.SetFavourite()` can be used to set the reblog/favourited status of posts.
They will respond with the updated post if they succeed.

 - - -

##  Examples  ##

###  Requesting a post's data:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the post
>   }
>
>   var request = new Laboratory.Post.Request({
>       id: postID,
>       type: Laboratory.Post.Type.STATUS
>   });
>   request.addEventListener("response", requestCallback);
>   request.start();
>   ```

###  Creating a new post:

>   ```javascript
>   var request = new Laboratory.Post.Create({
>       text: contents,
>       visibility: Laboratory.Post.Visibility.PUBLIC
>   });
>   request.start();
>   ```

###  Deleting a post:

>   ```javascript
>   var request = new Laboratory.Post.Delete({id: deleteThisID});
>   request.start();
>   ```

###  Reblogging a post:

>   ```javascript
>   function requestCallback(event) {
>       if (event.detail.response.isReblogged) success();
>   }
>
>   var request = new Laboratory.Post.SetReblog({
>       id: somePost.id,
>       value: true
>   });
>   request.addEventListener("response", requestCallback);
>   request.start();
>   ```

###  Unfavouriting a post:

>   ```javascript
>   function requestCallback(event) {
>       if (!event.detail.response.isFavourited) success();
>   }
>
>   var request = new Laboratory.Post.SetFavourite({
>       id: somePost.id,
>       value: false
>   });
>   request.addEventListener("response", requestCallback);
>   request.start();
>   ```

 - - -

##  Implementation  ##

###  Making the requests:

    Object.defineProperties Post,

####  `Post.Request`s.

        Request:
            configurable: no
            enumerable: yes
            writable: no
            value: do ->

                PostRequest = (data, isLive = yes, useCached = yes) ->

                    unless this and this instanceof PostRequest
                        throw new TypeError "this is not a PostRequest"

First we need to handle our variables.

                    unless Infinity > (postID = Math.floor data?.id) > 0
                        throw new TypeError "Unable to request post; no id provided"
                    type = Post.Type.STATUS unless (type = Post.Type.fromValue data.type) and
                        type isnt Post.Type.UNKNOWN
                    isNotification = type & Post.Type.NOTIFICATION
                    store = if isNotification then Store.notifications else Store.statuses

This `callback()` updates our `Post.Request` if Laboratory receives another `Post` with the same `id` and `type`.

                    callback = (event) =>
                        response = event.detail
                        if response instanceof Post and response.id is postID and
                            (response.type & Post.Type.NOTIFICATION) is isNotification
                                unless response.compare @response
                                    decree => @response = response
                                do @stop unless isLive

We can now create our request.
We dispatch a failure unless the received post matches the requested `postID` and `type`, and `stop()` unless our request `isLive`.

                    Request.call this, "GET", Store.auth.origin + (
                        if isNotification then "/api/v1/notifications/"
                        else "/api/v1/statuses/"
                    ) + postID, null, Store.auth.accessToken, (result) =>
                        unless result.id is postID
                            @dispatchEvent new CustomEvent "failure",
                                request: this
                                response: new Failure "Unable to fetch post; returned post did
                                    not match requested id"
                            return
                        post = new Post result
                        unless (post.type & Post.Type.NOTIFICATION) is isNotification
                            @dispatchEvent new CustomEvent "failure",
                                request: this
                                response: new Failure "Unable to fetch post; returned post was
                                    not of specified type"
                            return
                        dispatch "LaboratoryPostReceived", post

We store the default `Request` `start()` and `stop()` values and then overwrite them with our own.
This allows us to handle our `useCached` and `isLive` arguments.

                    requestStart = @start
                    requestStop = @stop

                    Object.defineProperties this,
                        start:
                            enumerable: no
                            value: ->
                                if useCached and store[postID] instanceof Post
                                    decree => @response = store[postID]
                                    return unless isLive
                                document.addEventListener "LaboratoryPostReceived", callback
                                do requestStart
                        stop:
                            enumerable: no
                            value: ->
                                document.removeEventListener "LaboratoryPostReceived", callback
                                do requestStop

                    Object.freeze this

Our `Post.Request.prototype` just inherits from `Request`.

                Object.defineProperty PostRequest, "prototype",
                    configurable: no
                    enumerable: no
                    writable: no
                    value: Object.freeze Object.create Request.prototype,
                        constructor:
                            enumerable: no
                            value: PostRequest

                return PostRequest

####  `Post.Create`s.

        Create:
            configurable: no
            enumerable: yes
            writable: no
            value: do ->

                PostCreate = (data) ->

                    unless this and this instanceof PostCreate
                        throw new TypeError "this is not a PostCreate"

First we need to handle our variables.

                    unless data?.text
                        throw new TypeError "Unable to create post; no text provided"
                    text = String data.text
                    unless visibility = Post.Visibility.fromValue data.visibility
                        visibility = Post.Visibility.PRIVATE
                    unless Infinity > (inReplyTo = Math.floor data.inReplyTo) > 0
                        inReplyTo = undefined
                    attachments = (
                        if data.attachments instanceof Array then data.attachments
                        else undefined
                    )
                    message = if data.message? then String data.message else undefined
                    makeNSFW = if data.makeNSFW? then !!data.makeNSFW else undefined

We can now create our request.
This is just a simple `POST` request to the mastodon server.

                    Request.call this, "POST", Store.auth.origin + "/api/v1/statuses/", {
                        status: text
                        in_reply_to_id: inReplyTo
                        media_ids: if attachments then (
                            for attachment in attachments when attachment instanceof Attachment
                                attachment.id
                        ) else undefined
                        sensitive: if makeNSFW then "true" else undefined
                        spoiler_text: message
                        visibility: switch visibility
                            when Post.Visibility.PUBLIC then "public"
                            when Post.Visibility.REBLOGGABLE then "unlisted"
                            else "private"
                    }, Store.auth.accessToken, (result) =>
                        dispatch "LaboratoryPostReceived", decree =>
                            @response = police -> new Post result

                    Object.freeze this

Our `Post.Create.prototype` just inherits from `Request`.

                Object.defineProperty PostCreate, "prototype",
                    configurable: no
                    enumerable: no
                    writable: no
                    value: Object.freeze Object.create Request.prototype,
                        constructor:
                            enumerable: no
                            value: PostCreate

                return PostCreate

####  `Post.Delete`s.

>   __[Issue #21](https://github.com/marrus-sh/laboratory/issues/21) :__
>   There needs to be better responses and error checking with regards to post deletion.

        Delete:
            configurable: no
            enumerable: yes
            writable: no
            value: do ->

                PostDelete = (data) ->

                    unless this and this instanceof PostDelete
                        throw new TypeError "this is not a PostDelete"
                    unless Infinity > (postID = Math.floor data?.id) > 0
                        throw new TypeError "Unable to create post; no id provided"

`Post.Delete()` just sends a `DELETE` to the appropriate point in the Mastodon API.

                    Request.call this, "DELETE",
                        Store.auth.origin + "/api/v1/statuses/" + postID, null,
                        Store.auth.accessToken, (result) =>
                            dispatch "LaboratoryPostDeleted", {id: postID}

                    Object.freeze this

Our `Post.Delete.prototype` just inherits from `Request`.

                Object.defineProperty PostDelete, "prototype",
                    configurable: no
                    enumerable: no
                    writable: no
                    value: Object.freeze Object.create Request.prototype,
                        constructor:
                            enumerable: no
                            value: PostDelete

                return PostDelete

####  `Post.SetReblog`s.

        SetReblog:
            configurable: no
            enumerable: yes
            writable: no
            value: do ->

                PostSetReblog = (data) ->

                    unless this and this instanceof PostSetReblog
                        throw new TypeError "this is not a PostSetReblog"
                    unless Infinity > (postID = Math.floor data?.id) > 0
                        throw new TypeError "Unable to reblog post; no id provided"
                    value = if data.value then !!data.value else on

`Post.SetReblog()` is mostly just an API request.

                    Request.call this, "POST",
                        Store.auth.origin + "/api/v1/statuses/" + postID + (
                            if value then "/reblog" else "/unreblog"
                        ), null, Store.auth.accessToken, (result) =>
                            dispatch "LaboratoryPostReceived", decree =>
                                @response = police -> new Post result

                    Object.freeze this

Our `Post.SetReblog.prototype` just inherits from `Request`.

                Object.defineProperty PostSetReblog, "prototype",
                    configurable: no
                    enumerable: no
                    writable: no
                    value: Object.freeze Object.create Request.prototype,
                        constructor:
                            enumerable: no
                            value: PostSetReblog

                return PostSetReblog

####  `Post.SetFavourite`s.

        SetFavourite:
            configurable: no
            enumerable: yes
            writable: no
            value: do ->

                PostSetFavourite = (data) ->

                    unless this and this instanceof PostSetFavourite
                        throw new TypeError "this is not a PostSetFavourite"
                    unless Infinity > (postID = Math.floor data?.id) > 0
                        throw new TypeError "Unable to favourite post; no id provided"
                    value = if data.value then !!data.value else on

`Post.SetFavourite()` is mostly just an API request.

                    Request.call this, "POST",
                        Store.auth.origin + "/api/v1/statuses/" + postID + (
                            if value then "/favourite" else "/unfavourite"
                        ), null, Store.auth.accessToken, (result) =>
                            dispatch "LaboratoryPostReceived", decree =>
                                @response = police -> new Post result

                    Object.freeze this

Our `Post.SetFavourite.prototype` just inherits from `Request`.

                Object.defineProperty PostSetFavourite, "prototype",
                    configurable: no
                    enumerable: no
                    writable: no
                    value: Object.freeze Object.create Request.prototype,
                        constructor:
                            enumerable: no
                            value: PostSetFavourite

                return PostSetFavourite

###  Creating the events:

Here we create the events as per our specifications.

    LaboratoryEvent
        .create "LaboratoryPostReceived", Post
        .create "LaboratoryPostDeleted",
            id: undefined

###  Handling the events:

Laboratory provides handlers for the following Authorization events:

- `LaboratoryPostReceived`
- `LaboratoryPostDeleted`

####  `LaboratoryPostReceived`.

The `LaboratoryPostReceived` event simply adds a received post to our store.

        .handle "LaboratoryPostReceived", (event) ->
            if (post = event.detail) instanceof Post and
                (type = post.type) instanceof Post.Type and
                Infinity > (id = Math.floor post.id) > 0
                    Store[["notifications", "statuses"][+!(
                        type & Post.Type.NOTIFICATION
                    )]][id] = post

####  `LaboratoryPostDeletion`.

The `LaboratoryPostDeleted` event removes the given post from our store.

        .handle "LaboratoryPostDeleted", (event) ->
            delete Store.statuses[id] if Infinity > (id = Math.floor event.detail.id) > 0
