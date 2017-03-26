#  THE TIMELINE CONSTRUCTOR  #

##  Introduction  ##

The `Timeline()` constructor creates a unique, read-only object which represents a Mastodon timeline.
Its properties are summarized below, alongside their Mastodon API equivalents:

| Property |  API Response  | Description |
| :------: | :------------: | :---------- |
| `posts`  | [The response] | An ordered array of posts in the timeline, in reverse-chronological order |
|  `type`  | *Not provided* | A `Timeline.Type` |
| `query`  | *Not provided* | The minimum id of posts in the timeline |
| `before` | *Not provided* | The upper limit of the timeline |
| `after`  | *Not provided* | The lower limit of the timeline |

###  Timeline types:

The possible `Timeline.Type`s are as follows:

| Enumeral | Hex Value | Description |
| :------: | :----------: | :---------- |
| `Timeline.Type.UNDEFINED` | `0x00` | No type is defined |
| `Timeline.Type.HASHTAG` | `0x10` | A timeline of hashtags |
| `Timeline.Type.LOCAL` | `0x11` | A local timeline |
| `Timeline.Type.GLOBAL` | `0x12` | A global (whole-known-network) timeline |
| `Timeline.Type.HOME` | `0x22` | A user's home timeline |
| `Timeline.Type.NOTIFICATIONS` | `0x23` | A user's notifications |
| `Timeline.Type.FAVOURITES` | `0x24` | A list of a user's favourites |
| `Timeline.Type.ACCOUNT` | `0x40` | A timeline of an account's posts |

The `Timeline()` constructor does not use or remember its `Timeline.Type`, but these values are used when requesting new `Timeline`s using `LaboratoryTimelineRequested`.

##  Prototype Methods ##

###  `join()`:

>   ```javascript
>       Laboratory.Timeline.prototype.join(data);
>   ```
>
>   - __`data` :__ A `Post`, array of `Post`s, or a `Timeline`

The `join()` prototype method joins the `Post`s of a timeline with that of the provided `data`, and returns a new `Timeline` of the results.
When merging two `Timeline`s, the `type` and `query` parameters will only be preserved if they match across both; in this case, `before` and `after` will be adjusted such that both `Timeline`s are contained in the range.
Otherwise, the `type` of the resultant `Timeline` will be `Timeline.Type.UNDEFINED` and its `query` will be the empty string.

When joining a `Timeline` with a different data type, the `type`, `query`, `before`, and `after` parameters remain unchanged.

###  `remove()`:

>   ```javascript
>       Laboratory.Timeline.prototype.remove(data);
>   ```
>
>   - __`data` :__ A `Post`, array of `Post`s, or a `Timeline`

The `remove()` prototype method collects the `Post`s of a timeline except for those of the provided `data`, and returns a new `Timeline` of the results.
The `type`, `query`, `before`, and `after` parameters are preserved from the original.

##  Implementation  ##

###  The constructor:

The `Timeline()` constructor takes a `data` object and uses it to construct a timeline.
`data` can be either an API response or an array of `Post`s.
`params` provides additional information not given in `data`.

    Laboratory.Timeline = Timeline = (data, params) ->

        throw new Error "Laboratory Error : `Timeline()` must be called as a constructor" unless this and this instanceof Timeline
        throw new Error "Laboratory Error : `Timeline()` was called without any `data`" unless data?

This loads our `params`.

        @type = if params.type instanceof Timeline.Type then params.type else Timeline.Type.UNDEFINED
        @query = String params.query
        @before = Number params.before if isFinite params.before
        @after = Number params.after if isFinite params.after

Mastodon keeps track of ids for notifications separately from ids for posts, as best as I can tell, so we have to verify that our posts are of matching type before proceeding.
Really all we care about is whether the posts are notifications, so that's all we test.

        isNotification = (object) -> !!(
            (
                switch
                    when object instanceof Post then object.type
                    when object.type? then Post.Type.NOTIFICATION  #  This is an approximation; the post could be a reaction.
                    else Post.Type.STATUS
            ) & Post.Type.NOTIFICATION
        )

We'll use the `getPost()` function in our post getters.

        getPost = (id, isANotification) -> if isANotification then Store.notifications[id] else Store.statuses[id]

We sort our data according to when they were created, unless two posts were created at the same time.
Then we use their ids.

>   __Note :__
>   Until/unless Mastodon starts assigning times to notifications, there are a few (albeit extremely unlikely) edge-cases where the following `sort()` function will cease to be well-defined.
>   Regardless, attempting to create a timeline out of both notifications and statuses will likely result in a very odd sorting.

        data.sort (first, second) -> if not (isNotification first) and not (isNotification second) and (a = Number first instanceof Post and first.datetime or Date first.created_at) isnt (b = Number second instanceof Post and second.datetime or Date second.created_at) then -1 + 2 * (a > b) else second.id - first.id

Next we walk the array and look for any duplicates, removing them.

>   __Note :__
>   Although `Timeline()` purports to remove all duplicate `Post`s, this behaviour is only guaranteed for *contiguous* `Post`s—given our sort algorithm, this means posts whose `datetime` values are also the same.
>   If the same post ends up sorted to two different spots, `Timeline()` will leave both in place.
>   (Generally speaking, if you find yourself with two posts with identical `id`s but different `datetime`s, this is a sign that something has gone terribly wrong.)

        prev = null
        for index in [data.length - 1 .. 0]
            currentID = (current = data[index]).id
            if prev? and currentID is prev.id and (isNotification prev) is (isNotification current)
                data.splice index, 1
                continue
            prev = current

Finally, we implement our list of `posts` as getters such that they always return the most current data.
**Note that this will likely prevent optimization of the `posts` array, so it is recommended that you make a static copy (using `Array.prototype.slice()` or similar) before doing intensive array operations with it.**

        @posts = []
        Object.defineProperty @posts, index, {get: getPost.bind(this, value.id, isNotification value), enumerable: true} for value, index in data
        Object.freeze @posts

        return Object.freeze this

###  The prototype:

The `Timeline` prototype has two functions.

    Object.defineProperty Timeline, "prototype",
        value: Object.freeze

####  `join()`.

The `join()` function creates a new `Timeline` which combines the `Post`s of the original and the provided `data`.
Its `data` argument can be either a `Post`, an array thereof, or a `Timeline`.
We don't have to worry about duplicates here because the `Timeline()` constructor should take care of them for us.

            join: (data) ->
                return this unless data instanceof Post or data instanceof Array or data instanceof Timeline
                combined = post for post in switch
                    when data instanceof Post then [data]
                    when data instanceof Timeline then data.posts
                    else data
                combined.push post for post in @posts
                return new Timeline combined, (
                    if data instanceof Timeline
                        if data.type is @type and data.query is @query
                            type: @type
                            query: @query
                            before: switch
                                when data.before >= @before then data.before
                                when data.before <= @before then @before
                                else undefined
                            after: switch
                                when data.after <= @after then data.after
                                when data.after >= @after then @after
                                else undefined
                        else
                            type: if data.type is @type then @type else Timeline.Type.UNDEFINED
                            query: ""
                            before: undefined
                            after: undefined
                    else
                        type: @type
                        query: @query
                        before: @before
                        after: @after
                )

####  `remove()`.

The `remove()` function returns a new `Timeline` with the provided `Post`s removed.
Its `data` argument can be either a `Post`, an array thereof, or a `Timeline`.

            remove: (data) ->
                return this unless data instanceof Post or data instanceof Array or data instanceof Timeline
                redacted = (post for post in @posts)
                redacted.splice index, 1 for post in (
                    switch
                        when data instanceof Post then [data]
                        when data instanceof Timeline then data.posts
                        else data
                ) when (index = redacted.indexOf post) isnt -1
                return new Timeline redacted,
                    type: @type
                    query: @query
                    before: @before
                    after: @after

###  Defining timeline types:

Here we define our `Timeline.Type`s, as described above:

    Timeline.Type = Enumeral.generate
        UNDEFINED     : 0x00
        HASHTAG       : 0x10
        LOCAL         : 0x11
        GLOBAL        : 0x12
        HOME          : 0x22
        NOTIFICATIONS : 0x23
        FAVOURITES    : 0x24
        ACCOUNT       : 0x40
