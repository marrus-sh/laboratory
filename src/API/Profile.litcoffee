<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.4.0</i> <br> <code>API/Profile.litcoffee</code></p>

#  PROFILE REQUESTS  #

 - - -

##  Description  ##

The __Profile__ module of the Laboratory API is comprised of those events which are related to Mastodon accounts.

###  Quick reference:

####  Requests.

| Request | Description |
| :------ | :---------- |
| `Profile.Request()` | Requests a `Profile` from the Mastodon server |
| `Profile.SetFollow()` | Petitions the Mastodon server to follow or unfollow the provided account |
| `Profile.SetBlock()` | Petitions the Mastodon server to block or unblock the provided account |
| `Profile.SetMute()` | Petitions the Mastodon server to mute or unmute the provided account |

####  Events.

| Event | Description |
| :---- | :---------- |
| `LaboratoryProfileReceived` | Fires when a `Profile` has been processed |

###  Requesting a profile:

>   ```javascript
>   request = new Laboratory.Profile.Request(data, isLive, useCached);
>   ```
>
>   - __API equivalent :__ `/api/v1/accounts/:id`, `/api/v1/accounts/relationships`
>   - __Request parameters :__
>       - __`id` :__ The id of the profile to request
>   - __Response :__ A [`Profile`](../Constructors/Profile.litcoffee)

Laboratory Profile events are used to request [`Profile`](../Constructors/Profile.litcoffee)s containing data on a specified account.
The request takes an object whose `id` parameter specifies the account to fetch.

Profile requests may be either __static__ or __live__.
Static profile requests don't update their responses when new information is received from the server, whereas live profile requests do.
This behaviour is controlled by the `isLive` argument, which defaults to `true`.

>   __Note :__
>   You can call `request.stop()` to stop a live `Profile.Request`, and `request.start()` to start it up again.
>   Always call `request.stop()` when you are finished using a live request to allow it to be freed from memory.

Laboratory Profile requests automatically retrieve up-to-date relationship information for the accounts they fetch.
However, this can only happen if `isLive` is `true`.
Otherwise, the profile relationship will likely end up as `Profile.Relationship.UNKNOWN`.

Laboratory keeps track of all of the `Profile`s it receives in its internal store.
If the `useCached` argument is `true` (the default), then it will immediately load the stored value into its response if available.
It will still request the server for updated information unless `isLive` is `false`.

A summary of these options is provided by the table below:

| `isLive` | `useCached` | Description |
| :------: | :---------: | :---------- |
|  `true`  |   `true`    | Laboratory will respond with the cached value if available, then query the server for both updated account information and relationship status. It will continue to update its response as new information becomes available. |
|  `true`  |   `false`   | Laboratory will not use the cached value, but will query the server for both updated account information and relationship status. It will continue to update its response as new information becomes available. |
| `false`  |   `true`    | Laboratory will respond with the cached value if available, and only query the server if it doesn't have the account in its cache. It won't check for updated relationship information or update its response over time. |
| `false`  |   `false`   | Laboratory will query the server once for the account information, but won't check for relationship information or update its response afterwards. In this case, the relationship will always be either `Profile.Relationship.SELF` or `Profile.Relationship.UNKNOWN`. |

###  Changing relationship status:

>   ```javascript
>       followRequest = new Laboratory.Profile.SetFollow(data);
>       blockRequest = new Laboratory.Profile.SetBlock(data);
>       muteRequest = new Laboratory.Profile.SetMute(data);
>   ```
>
>   - __API equivalent :__ `/api/v1/accounts/follow`, `/api/v1/accounts/unfollow`, `/api/v1/accounts/block`, `/api/v1/accounts/unblock`, `/api/v1/accounts/mute`, `/api/v1/accounts/unmute`
>   - __Request parameters :__
>       - __`id` :__ The id of the account to change the relationship of
>       - __`value` :__ A `Profile.Relationship` specifying the new relationship.
>   - __Response :__ A [`Profile`](../Constructors/Profile.litcoffee)

`Profile.SetFollow()`, `Profile.SetBlock()`, and `Profile.SetMute()` can be used to modify the relationship status for an account.
They should be fired with two parameters: `id`, which gives the id of the account, and `value`, which should indicate whether to follow/block/mute an account, or do the opposite.

 - - -

##  Examples  ##

###  Requesting a profile's data:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the profile
>   }
>
>   var request = new Laboratory.Profile.Request({id: profileID});
>   request.addEventListener("response", requestCallback);
>   request.start();
>   ```

###  Following a profile:

>   ```javascript
>   function requestCallback(event) {
>       if (event.detail.response.relationship & Laboratory.Profile.Relationship.FOLLOWING) success();
>   }
>
>   var request = new Laboratory.Profile.SetRelationship({
>       id: someProfile.id,
>       value: someProfile.relationship & Laboratory.Profile.Relationship.FOLLOWING
>   });
>   request.addEventListener("response", requestCallback);
>   request.start();
>   ```

###  Unmuting a profile:

>   ```javascript
>   function requestCallback(event) {
>       if (event.detail.response.relationship & ~Laboratory.Profile.Relationship.MUTING) success();
>   }
>
>   var request = new Laboratory.Profile.SetRelationship({
>       id: someProfile.id,
>       value: someProfile.relationship & ~Laboratory.Profile.Relationship.MUTING
>   });
>   request.addEventListener("response", requestCallback);
>   request.start();
>   ```

 - - -

##  Implementation  ##

###  Making the requests:

    Object.defineProperties Profile,

####  `Profile.Request`s.

        Request:
            configurable: no
            enumerable: yes
            writable: no
            value: do ->

                ProfileRequest = (data, isLive = yes, useCached = yes) ->

                    unless this and this instanceof ProfileRequest
                        throw new TypeError "this is not a ProfileRequest"
                    unless Infinity > (profileID = Math.floor data?.id) > 0
                        throw new TypeError "Unable to request profile; no id provided"

This `callback()` updates our `Profile.Request` if Laboratory receives another `Profile` with the same `id`.

                    callback = (event) =>
                        response = event.detail
                        if response instanceof Profile and response.id is profileID
                            (decree => @response = response) unless response.compare @response
                            do @stop unless isLive

We can now create our request.
We dispatch a failure unless the received profile matches the requested `profileID`, and `stop()` unless our request `isLive`.

                    Request.call this, "GET",
                        Store.auth.origin + "/api/v1/accounts/" + profileID,
                        null, Store.auth.accessToken, (result) =>
                            unless result.id is profileID
                                @dispatchEvent new CustomEvent "failure",
                                    id: @id
                                    request: this
                                    response: new Failure "Unable to fetch profile; returned
                                        profile did not match requested id"
                                return
                            dispatch "LaboratoryProfileReceived", new Profile result
                            do relationshipRequest.start

If this `isLive`, then we also need to create a `Request` for our relationships.

                    relationshipRequest = new Request "GET",
                        Store.auth.origin + "/api/v1/accounts/relationships", {id: postID},
                        Store.auth.accessToken, (result) =>
                            relationships = response[0]
                            relID = relationships.id
                            relationship = Profile.Relationship.fromValue (
                                Profile.Relationship.FOLLOWER * relationships.followed_by +
                                Profile.Relationship.FOLLOWING * relationships.following +
                                Profile.Relationship.REQUESTED * relationships.requested +
                                Profile.Relationship.BLOCKING * relationships.blocking +
                                Profile.Relationship.MUTING * relationships.muting +
                                Profile.Relationship.SELF * (relID is Store.auth.me)
                            ) or Profile.Relationship.UNKNOWN
                            unless Store.profiles[relID]?.relationship is relaltionship
                                dispatch "LaboratoryProfileReceived",
                                    new Profile (
                                        Store.profiles[relID] or {id: relID}
                                    ), relationship

We store the default `Request` `start()` and `stop()` values and then overwrite them with our own.
This allows us to handle our `useCached` and `isLive` arguments.

                    requestStart = @start
                    requestStop = @stop

                    Object.defineProperties this,
                        start:
                            enumerable: no
                            value: ->
                                if useCached and Store.profiles[profileID] instanceof Profile
                                    decree => @response = Store.profiles[profileID]
                                    return unless isLive
                                document.addEventListener "LaboratoryProfileReceived", callback
                                do requestStart
                        stop:
                            enumerable: no
                            value: ->
                                document.removeEventListener "LaboratoryProfileReceived",
                                    callback
                                do requestStop
                                do relationshipRequest.stop

                    Object.freeze this

Our `Profile.Request.prototype` just inherits from `Request`.

                Object.defineProperty ProfileRequest, "prototype",
                    configurable: no
                    enumerable: no
                    writable: no
                    value: Object.freeze Object.create Request.prototype,
                        constructor:
                            enumerable: no
                            value: ProfileRequest

                return ProfileRequest

####  `Post.SetFollow`s.

        SetFollow:
            configurable: no
            enumerable: yes
            writable: no
            value: do ->

                ProfileSetFollow = (data) ->

                    unless this and this instanceof ProfileSetFollow
                        throw new TypeError "this is not a ProfileSetFollow"
                    unless Infinity > (profileID = Math.floor data?.id) > 0
                        throw new TypeError "Unable to follow account; no id provided"
                    value = if data.value then !!data.value else on

`Profile.SetFollow()` is mostly just an API request.

                    Request.call this, "POST",
                        Store.auth.origin + "/api/v1/accounts/" + profileID + (
                            if value then "/follow" else "/unfollow"
                        ), null, Store.auth.accessToken, (result) =>
                            dispatch "LaboratoryProfileReceived", decree =>
                                @response = police -> new Profile result

                    Object.freeze this

Our `Profile.SetFollow.prototype` just inherits from `Request`.

                Object.defineProperty ProfileSetFollow, "prototype",
                    configurable: no
                    enumerable: no
                    writable: no
                    value: Object.freeze Object.create Request.prototype,
                        constructor:
                            enumerable: no
                            value: ProfileSetFollow

                return ProfileSetFollow

####  `Post.SetBlock`s.

        SetBlock:
            configurable: no
            enumerable: yes
            writable: no
            value: do ->

                ProfileSetBlock = (data) ->

                    unless this and this instanceof ProfileSetBlock
                        throw new TypeError "this is not a ProfileSetBlock"
                    unless Infinity > (profileID = Math.floor data?.id) > 0
                        throw new TypeError "Unable to block account; no id provided"
                    value = if data.value then !!data.value else on

`Profile.SetBlock()` is mostly just an API request.

                    Request.call this, "POST",
                        Store.auth.origin + "/api/v1/accounts/" + profileID + (
                            if value then "/block" else "/unblock"
                        ), null, Store.auth.accessToken, (result) =>
                            dispatch "LaboratoryProfileReceived", decree =>
                                @response = police -> new Profile result

                    Object.freeze this

Our `Profile.SetBlock.prototype` just inherits from `Request`.

                Object.defineProperty ProfileSetBlock, "prototype",
                    configurable: no
                    enumerable: no
                    writable: no
                    value: Object.freeze Object.create Request.prototype,
                        constructor:
                            enumerable: no
                            value: ProfileSetBlock

                return ProfileSetBlock

####  `Post.SetFollow`s.

        SetMute:
            configurable: no
            enumerable: yes
            writable: no
            value: do ->

                ProfileSetMute = (data) ->

                    unless this and this instanceof ProfileSetMute
                        throw new TypeError "this is not a ProfileSetMute"
                    unless Infinity > (profileID = Math.floor data?.id) > 0
                        throw new TypeError "Unable to mute account; no id provided"
                    value = if data.value then !!data.value else on

`Profile.SetMute()` is mostly just an API request.

                    Request.call this, "POST",
                        Store.auth.origin + "/api/v1/accounts/" + profileID + (
                            if value then "/mute" else "/unmute"
                        ), null, Store.auth.accessToken, (result) =>
                            dispatch "LaboratoryProfileReceived", decree =>
                                @response = police -> new Profile result

                    Object.freeze this

Our `Profile.SetMute.prototype` just inherits from `Request`.

                Object.defineProperty ProfileSetMute, "prototype",
                    configurable: no
                    enumerable: no
                    writable: no
                    value: Object.freeze Object.create Request.prototype,
                        constructor:
                            enumerable: no
                            value: ProfileSetMute

                return ProfileSetMute

###  Creating the events:

Here we create the events as per our specifications.

    LaboratoryEvent
        .create "LaboratoryProfileReceived", Profile

###  Handling the events:

Laboratory provides handlers for the following Authorization events:

- `LaboratoryProfileReceived`

####  `LaboratoryProfileReceived`.

The `LaboratoryProfileReceived` event simply adds a received profile to our store.

        .handle "LaboratoryProfileReceived", (event) ->
            if (profile = event.detail) instanceof Profile and
                Infinity > (id = Math.floor profile.id) > 0
                    Store.profiles[id] = profile
