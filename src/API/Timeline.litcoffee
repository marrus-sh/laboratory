<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>API/Timeline.litcoffee</code></p>

#  TIMELINE REQUESTS  #

 - - -

##  Description  ##

The __Timeline__ module of the Laboratory API is comprised of those requests which are related to rolodexes of Mastodon accounts.

###  Quick reference:

####  Requests.

| Request | Description |
| :------ | :---------- |
| `Timeline.Request()` | Requests a `Timeline` from the Mastodon server |

###  Requesting a rolodex:

>   ```javascript
>   request = new Laboratory.Timeline.Request(data);
>   rangedRequest = new Laboratory.Timeline.Request(data, before, after);
>   ```
>
>   - __API equivalent :__ `/api/v1/timelines/home`, `/api/v1/timelines/public`, `/api/v1/timelines/tag/:hashtag`, `/api/v1/notifications/`, `/api/v1/favourites`
>   - __Request parameters :__
>       - __`type` :__ The [`Timeline.Type`](../Constructors/Timeline.litcoffee) of the `Timeline`
>       - __`query` :__ The associated query
>       - __`isLocal` :__ Whether to exclude federated posts (default: `false`)
>   - __Response :__ A [`Timeline`](../Constructors/Timeline.litcoffee)

Laboratory Rolodex events are used to request [`Timeline`](../Constructors/Timeline.litcoffee)s of accounts according to the specified `type` and `query`.
If the `type` is `Timeline.Type.HASHTAG`, then `query` should provide the hashtag; in the case of `Timeline.Type.ACCOUNT`, then `query` should provide the account id; otherwise, no `query` is required.

The `isLocal` parameter specifies whether to include federated posts in the resultant timeline; note however that this is only supported for some `Timeline.Type`s.

>   __[Issue #56](https://github.com/marrus-sh/laboratory/issues/56) :__
>   Future timelines should be able to limit their responses to just posts with media attachments.

>   __[Issue #57](https://github.com/marrus-sh/laboratory/issues/57) :__
>   Future timelines should be able to limit their responses to exclude posts with replies.

The `before` and `after` arguments can be used to modify the range of the `Timeline`, but generally speaking you shouldn't need to specify these directly—instead use the built-in update and pagination functions to do this for you.

####  Getting more entries.

The `update()` and `loadMore()` methods of a `Timeline.Request` can be used to update a `Timeline` with new entries, or older ones, respectively.

The `update()` method takes one argument: `keepGoing`, which tells Laboratory whether to keep loading new information until the `Timeline` is caught up to the present.
The default value for this argument is `true`.

####  Pagination.

If you want to get more entries, but don't want them all collapsed into a single `Timeline`, the `prev()` and `next()` methods can be used instead.
These return new `Timeline.Request`s which will respond with the previous and next page of entries, respectively.

 - - -

##  Examples  ##

###  Requesting an account's statuses:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the timeline
>   }
>
>   var request = new Laboratory.Timeline.Request({
>       type: Laboratory.Timeline.Type.ACCOUNT
>       query: someProfile.id
>   });
>   request.assign(requestCallback);
>   request.start();
>   ```

###  Getting posts for a hashtag:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the rolodex
>   }
>
>   var request = new Laboratory.Timeline.Request({
>       type: Laboratory.Timeline.Type.HASHTAG
>       query: "hashtag"
>   });
>   request.assign(requestCallback);
>   request.start();
>   ```

###  Getting the home timeline:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the rolodex
>   }
>
>   var request = new Laboratory.Timeline.Request({
>       type: Laboratory.Timeline.Type.HOME
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

    Object.defineProperty Timeline, "Request",

        configurable: no
        enumerable: yes
        writable: no
        value: do ->

            TimelineRequest = (data, before, after) ->

                unless this and this instanceof TimelineRequest
                    throw new TypeError "this is not a TimelineRequest"

First, we handle our `data`.

                unless (type = Timeline.Type.fromValue data.type) and
                    type isnt Timeline.Type.UNDEFINED
                        throw new TypeError "Unable to request rolodex; no type provided"
                query = if data.query? then String data.query else undefined
                isLocal = !!data.isLocal
                limit =
                    if Infinity > data.limit > 0 then Math.floor data.limit else undefined

`before` and `after` will store the next and previous pages for our `Timeline.Request`.

                before = undefined
                after = undefined

Next, we set up our `Request`.
Note that `Request()` ignores data parameters which have a value of `undefined` or `null`.

>   __[Issue #27](https://github.com/marrus-sh/laboratory/issues/27) :__
>   In the future, the events dispatched here may instead be dispatched from the `Timeline()` constructor directly.

>   __[Issue #56](https://github.com/marrus-sh/laboratory/issues/56) :__
>   Future timelines should be able to limit their responses to just posts with media attachments.

>   __[Issue #57](https://github.com/marrus-sh/laboratory/issues/57) :__
>   Future timelines should be able to limit their responses to exclude posts with replies.

                Request.call this, "GET", Store.auth.origin + (
                        switch type
                            when Timeline.Type.HASHTAG then "/api/v1/timelines/tag/" + query
                            when Timeline.Type.PUBLIC then "/api/v1/timelines/public"
                            when Timeline.Type.HOME then "/api/v1/timelines/home"
                            when Timeline.Type.NOTIFICATIONS then "/api/v1/notifications"
                            when Timeline.Type.FAVOURITES then "/api/v1/favourites"
                            when Timeline.Type.ACCOUNT then "/api/v1/accounts/" + query +
                                "/statuses"
                            else "/api/v1"
                    ), (
                        switch type
                            when isLocal
                                local: yes
                                max_id: before
                                since_id: after
                            else
                                max_id: before
                                since_id: after
                    ), Store.auth.accessToken, (result, params) =>
                        acctIDs = []
                        mentions = []
                        mentionIDs = []
                        ids = []
                        before = ((params.prev?.match /.*since_id=([0-9]+)/) or [])[1]
                        after = ((params.next?.match /.*max_id=([0-9]+)/) or [])[1]
                        for status in result when status.id not in ids
                            ids.push status.id
                            for account in [
                                status.account
                                status.status?.account
                                status.reblog?.account
                            ] when account
                                acctIDs.push account.id
                                dispatch "LaboratoryProfileReceived", new Profile account
                            if (
                                srcMentions = status.mentions or status.status?.mentions or
                                    status.reblog?.mentions
                            ) instanceof Array
                                for account in srcMentions when account.id not in mentionIDs
                                    mentionIDs.push account.id
                                    mentions.push account
                            dispatch "LaboratoryPostReceived", new Post status
                        for mention in mentions when mention.id not in acctIDs and
                            not Store.profiles[mention.id]?
                                dispatch "LaboratoryProfileReceived", new Profile mention
                        decree => @response = police -> new Timeline result

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
                        value: -> return new TimelineRequest {type, query, isLocal}, undefined, before
                    next:
                        enumerable: no
                        value: -> return new TimelineRequest {type, query, isLocal}, after
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

            Object.defineProperty TimelineRequest, "prototype",
                configurable: no
                enumerable: no
                writable: no
                value: Object.freeze Object.create Request.prototype,
                    constructor:
                        enumerable: no
                        value: TimelineRequest
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

            return TimelineRequest
