<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.4.0</i> <br> <code>Constructors/Timeline.litcoffee</code></p>

#  THE TIMELINE CONSTRUCTOR  #

 - - -

##  Description  ##

The `Timeline()` constructor creates a unique, read-only object which represents a Mastodon timeline.
Its properties are summarized below, alongside their Mastodon API equivalents:

| Property  |  API Response  | Description |
| :-------: | :------------: | :---------- |
|  `posts`  | [The response] | An ordered array of posts in the timeline, in reverse-chronological order |
| `length`  | *Not provided* | The length of the timeline |

###  Timeline types:

The possible `Timeline.Type`s are as follows:

| Enumeral | Hex Value | Description |
| :------: | :----------: | :---------- |
| `Timeline.Type.UNDEFINED` | `0x00` | No type is defined |
| `Timeline.Type.PUBLIC` | `0x10` | A public timeline |
| `Timeline.Type.HOME` | `0x20` | A user's home timeline |
| `Timeline.Type.NOTIFICATIONS` | `0x21` | A user's notifications |
| `Timeline.Type.FAVOURITES` | `0x22` | A list of a user's favourites |
| `Timeline.Type.ACCOUNT` | `0x40` | A timeline of an account's posts |
| `Timeline.Type.HASHTAG` | `0x80` | A hashtag search |

###  Prototype methods:

####  `join()`.

>   ```javascript
>       Laboratory.Timeline.prototype.join(data);
>   ```
>
>   - __`data` :__ A `Post`, array of `Post`s, or a `Timeline`

The `join()` prototype method joins the `Post`s of a timeline with that of the provided `data`, and returns a new `Timeline` of the results.

####  `remove()`.

>   ```javascript
>       Laboratory.Timeline.prototype.remove(data);
>   ```
>
>   - __`data` :__ A `Post`, array of `Post`s, or a `Timeline`

The `remove()` prototype method collects the `Post`s of a timeline except for those of the provided `data`, and returns a new `Timeline` of the results.

 - - -

##  Implementation  ##

###  The constructor:

The `Timeline()` constructor takes a `data` object and uses it to construct a timeline.
`data` can be either an API response or an array of `Post`s.

    Laboratory.Timeline = Timeline = (data) ->

        unless this and this instanceof Timeline
            throw new Error "Laboratory Error : `Timeline()` must be called as a constructor"
        unless data?
            throw new Error "Laboratory Error : `Timeline()` was called without any `data`"

Mastodon keeps track of ids for notifications separately from ids for posts, as best as I can tell, so we have to verify that our posts are of matching type before proceeding.
Really all we care about is whether the posts are notifications, so that's all we test.

        isNotification = (object) -> !!(
            (
                switch
                    when object instanceof Post then object.type
                    when object.type? then Post.Type.NOTIFICATION  #  This is an approximation
                    else Post.Type.STATUS
            ) & Post.Type.NOTIFICATION
        )

We'll use the `getPost()` function in our post getters.

        getPost = (id, isANotification) ->
            if isANotification then Store.notifications[id] else Store.statuses[id]

We sort our data according to when they were created, unless two posts were created at the same time.
Then we use their ids.

>   __Note :__
>   Until/unless Mastodon starts assigning times to notifications, there are a few (albeit extremely unlikely) edge-cases where the following `sort()` function will cease to be well-defined.
>   Regardless, attempting to create a timeline out of both notifications and statuses will likely result in a very odd sorting.

        data.sort (first, second) ->
            if not (isNotification first) and not (isNotification second) and (
                a = Number first instanceof Post and first.datetime or Date first.created_at
            ) isnt (
                b = Number second instanceof Post and second.datetime or Date second.created_at
            ) then -1 + 2 * (a > b) else second.id - first.id

Next we walk the array and look for any duplicates, removing them.

>   __Note :__
>   Although `Timeline()` purports to remove all duplicate `Post`s, this behaviour is only guaranteed for *contiguous* `Post`s—given our sort algorithm, this means posts whose `datetime` values are also the same.
>   If the same post ends up sorted to two different spots, `Timeline()` will leave both in place.
>   (Generally speaking, if you find yourself with two posts with identical `id`s but different `datetime`s, this is a sign that something has gone terribly wrong.)

        prev = null
        for index in [data.length - 1 .. 0]
            currentID = (current = data[index]).id
            if prev? and currentID is prev.id and
                (isNotification prev) is (isNotification current)
                    data.splice index, 1
                    continue
            prev = current

Finally, we implement our list of `posts` as getters such that they always return the most current data.
**Note that this will likely prevent optimization of the `posts` array, so it is recommended that you make a static copy (using `Array.prototype.slice()` or similar) before doing intensive array operations with it.**

>   __[Issue #28](https://github.com/marrus-sh/laboratory/issues/28) :__
>   At some point in the future, `Timeline` might instead be implemented using a linked list.

        @posts = []
        Object.defineProperty @posts, index, {
            enumerable: yes
            get: getPost.bind(this, value.id, isNotification value)
        } for value, index in data
        Object.freeze @posts

        @length = data.length

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
                return this unless data instanceof Post or data instanceof Array or
                    data instanceof Timeline
                combined = post for post in switch
                    when data instanceof Post then [data]
                    when data instanceof Timeline then data.posts
                    else data
                combined.push post for post in @posts
                return new Timeline combined

####  `remove()`.

The `remove()` function returns a new `Timeline` with the provided `Post`s removed.
Its `data` argument can be either a `Post`, an array thereof, or a `Timeline`.

            remove: (data) ->
                return this unless data instanceof Post or data instanceof Array or
                    data instanceof Timeline
                redacted = (post for post in @posts)
                redacted.splice index, 1 for post in (
                    switch
                        when data instanceof Post then [data]
                        when data instanceof Timeline then data.posts
                        else data
                ) when (index = redacted.indexOf post) isnt -1
                return new Timeline redacted

###  Defining timeline types:

Here we define our `Timeline.Type`s, as described above:

    Timeline.Type = Enumeral.generate
        UNDEFINED     : 0x00
        PUBLIC        : 0x10
        HOME          : 0x20
        NOTIFICATIONS : 0x21
        FAVOURITES    : 0x22
        ACCOUNT       : 0x40
        HASHTAG       : 0x80
