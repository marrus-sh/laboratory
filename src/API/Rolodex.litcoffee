<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>API/Rolodex.litcoffee</code></p>

#  ROLODEX REQUESTS  #

 - - -

##  Description  ##

The __Rolodex__ module of the Laboratory API is comprised of those requests which are related to rolodexes of Mastodon accounts.

###  Quick reference:

####  Requests.

| Request | Description |
| :------ | :---------- |
| `Rolodex.Request()` | Requests a `Rolodex` from the Mastodon server |

###  Requesting a rolodex:

>   ```javascript
>   request = new Laboratory.Rolodex.Request(data);
>   rangedRequest = new Laboratory.Rolodex.Request(data, before, after);
>   ```
>
>   - __API equivalent :__ `/api/v1/accounts/search`, `/api/v1/accounts/:id/followers`, `/api/v1/accounts/:id/following`, `/api/v1/statuses/:id/reblogged_by`, `/api/v1/statuses/:id/favourited_by`, `/api/v1/blocks`, `/api/v1/mutes`, `/api/v1/follow_requests`
>   - __Request parameters :__
>       - __`type` :__ The [`Rolodex.Type`](../Constructors/Rolodex.litcoffee) of the `Rolodex`
>       - __`query` :__ The associated query
>       - __`limit` :__ The number of accounts to show (for searches only)
>   - __Response :__ A [`Rolodex`](../Constructors/Rolodex.litcoffee)

Laboratory Rolodex events are used to request [`Rolodex`](../Constructors/Rolodex.litcoffee)es of accounts according to the specified `type` and `query`.
If the `type` is `Rolodex.Type.SEARCH`, then `query` should provide the string to search for; otherwise, `query` should be the id of the relevant account or status.
In the case of `Rolodex.Type.BLOCKS`, `Rolodex.Type.MUTES`, and `Rolodex.Type.FOLLOW_REQUESTS`, no `query` is required.

The `before` and `after` arguments can be used to modify the range of the `Rolodex`, but generally speaking you shouldn't need to specify these directly—instead use the built-in update and pagination functions to do this for you.

For `Rolodex.Type.SEARCH`es, the number of accounts to return can be specified using the `limit` parameter; for other `Rolodex.Type`s, this parameter is ignored.

####  Getting more entries.

The `update()` and `loadMore()` methods of a `Rolodex.Request` can be used to update a `Rolodex` with new entries, or older ones, respectively.

The `update()` method takes one argument: `keepGoing`, which tells Laboratory whether to keep loading new information until the `Rolodex` is caught up to the present.
The default value for this argument is `true`.

####  Pagination.

If you want to get more entries, but don't want them all collapsed into a single `Rolodex`, the `prev()` and `next()` methods can be used instead.
These return new `Rolodex.Request`s which will respond with the previous and next page of entries, respectively.

 - - -

##  Examples  ##

###  Requesting an account's followers:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the rolodex
>   }
>
>   var request = new Laboratory.Rolodex.Request({
>       type: Laboratory.Rolodex.Type.FOLLOWERS
>       query: someProfile.id
>   });
>   request.assign(requestCallback);
>   request.start();
>   ```

###  Searching for an account:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the rolodex
>   }
>
>   var request = new Laboratory.Rolodex.Request({
>       type: Laboratory.Rolodex.Type.SEARCH
>       query: "account"
>       limit: 5
>   });
>   request.assign(requestCallback);
>   request.start();
>   ```

###  Checking a user's blocks:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the rolodex
>   }
>
>   var request = new Laboratory.Rolodex.Request({
>       type: Laboratory.Rolodex.Type.BLOCKS
>   });
>   request.assign(requestCallback);
>   request.start();
>   ```

###  Updating a request:

>   ```javascript
>   request.update();  //  Will fire a "response" event for each update
>   ```

###  Paginating a request:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the rolodex
>   }
>
>   function loadNextPage (request) {
>       var newRequest = request.next();
>       newRequest.assign(requestCallback);
>       newRequest.start();
>       return newRequest;
>   }
>
>   function loadPrevPage (request) {
>       var newRequest = request.prev();
>       newRequest.assign(requestCallback);
>       newRequest.start();
>       return newRequest;
>   }
>   ```

 - - -

##  Implementation  ##

###  Making the request:

    Object.defineProperty Rolodex, "Request",

        configurable: no
        enumerable: yes
        writable: no
        value: do ->

            RolodexRequest = (data, before, after) ->

                unless this and this instanceof RolodexRequest
                    throw new TypeError "this is not a RolodexRequest"

First, we handle our `data`.

                unless (type = Rolodex.Type.fromValue data.type) and
                    type isnt Rolodex.Type.UNDEFINED
                        throw new TypeError "Unable to request rolodex; no type provided"
                query = if data.query? then String data.query else undefined
                limit =
                    if Infinity > data.limit > 0 then Math.floor data.limit else undefined

`before` and `after` will store the next and previous pages for our `Rolodex.Request`.

                before = undefined
                after = undefined

Next, we set up our `Request`.
Note that `Request()` ignores data parameters which have a value of `undefined` or `null`.

>   __[Issue #27](https://github.com/marrus-sh/laboratory/issues/27) :__
>   In the future, the events dispatched here may instead be dispatched from the `Rolodex()` constructor directly.

                Request.call this, "GET", Store.auth.origin + (
                        switch type
                            when Rolodex.Type.SEARCH then "/api/v1/accounts/search"
                            when Rolodex.Type.FOLLOWERS
                                "/api/v1/accounts/" + query + "/followers"
                            when Rolodex.Type.FOLLOWING
                                "/api/v1/accounts/" + query + "/following"
                            when Rolodex.Type.FAVOURITED_BY
                                "/api/v1/statuses/" + query + "/favourited_by"
                            when Rolodex.Type.REBLOGGED_BY
                                "/api/v1/statuses/" + query + "/reblogged_by"
                            when Rolodex.Type.BLOCKS then "/api/v1/blocks"
                            when Rolodex.Type.MUTES then "/api/v1/mutes"
                            when Rolodex.Type.FOLLOW_REQUESTS then "/api/v1/follow_requests"
                    ), (
                        switch type
                            when Rolodex.Type.SEARCH
                                q: query
                                limit: limit
                            else
                                max_id: before
                                since_id: after
                    ), Store.auth.accessToken, (result, params) =>
                        ids = []
                        before = ((params.prev?.match /.*since_id=([0-9]+)/) or [])[1]
                        after = ((params.next?.match /.*max_id=([0-9]+)/) or [])[1]
                        for account in result when account.id not in ids
                            ids.push account.id
                            dispatch "LaboratoryProfileReceived", new Profile account
                        decree => @response = police -> new Rolodex result

>   __[Issue #39](https://github.com/marrus-sh/laboratory/issues/39) :__
>   These functions should be declared outside of the constructor and then bound to their proper values.

                Object.defineProperties this,
                    before:
                        enumerable: yes
                        get: -> before
                    after:
                        enumerable: yes
                        get: -> after
                    prev:
                        enumerable: no
                        value: -> return new RolodexRequest {type, query, limit}, undefined, before
                    next:
                        enumerable: no
                        value: -> return new RolodexRequest {type, query, limit}, after
                    loadMore:
                        enumerable: no
                        value: =>
                            callback = (event) =>
                                after = next.after
                                decree => @response = police -> @response.join next.response
                                next.removeEventListener "response", callback
                            (next = do @next).addEventListener "response", callback
                            do next.start
                    update:
                        enumerable: no
                        value: (keepGoing) =>
                            callback = (event) =>
                                before = prev.before
                                decree => @response = police -> @response.join prev.response
                                prev.removeEventListener "response", callback
                                if keepGoing and prev.response.length
                                    (prev = do @prev).addEventListener "response", callback
                                    do prev.start
                            (prev = do @prev).addEventListener "response", callback
                            do prev.start

                Object.freeze this

Our `Rolodex.Request.prototype` inherits from `Request`, with additional dummy methods for the ones we define in our constructor.

            Object.defineProperty RolodexRequest, "prototype",
                configurable: no
                enumerable: no
                writable: no
                value: Object.freeze Object.create Request.prototype,
                    constructor:
                        enumerable: no
                        value: RolodexRequest
                    prev:
                        enumerable: no
                        value: ->
                    next:
                        enumerable: no
                        value: ->
                    loadMore:
                        enumerable: no
                        value: ->
                    update:
                        enumerable: no
                        value: ->

            return RolodexRequest
