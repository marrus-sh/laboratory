<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>Constructors/Timeline.litcoffee</code></p>

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

##  Examples  ##

>   __[Issue #53](https://github.com/marrus-sh/laboratory/issues/53) :__
>   Usage examples for constructors are forthcoming.

 - - -

##  Implementation  ##

    Laboratory.Timeline = Timeline = do ->

###  Helpers:

####  `getPost()`.

We'll use the `getPost()` function in our post getters.

        getPost = (id, isANotification) ->
            if isANotification then Store.notifications[id] else Store.statuses[id]
            
####  `sort()`.

The `sort()` function sorts our posts for us.

        sort = (chronological , first , second) ->
            return 0 unless chronological? and first? and second?
            if chronological and (a = Number first.datetime) isnt (b = Number second.datetime)
                -1 + 2 * (a > b)
            else second.id - first.id

###  The constructor:

The `Timeline()` constructor takes a `data` object and uses it to construct a timeline.
The `chronological` argument determines whether to sort the timeline by `datetime` or `id`.
`data` can be either an API response or an array of `Post`s.

        return (data , chronological) ->

            unless this and this instanceof Timeline
                throw new TypeError "this is not a Timeline"
            unless isArray data
                throw new TypeError "Unable to create Timeline; no data provided"

Here we process our `data`.
If we are given an array of ids, we assume them to be existing statuses, otherwise we receive the posts.

            posts = []
            for item in data then switch
                when item instanceof Post or item is Object item
                    post = new Post item
                    dispatch "LaboratoryPostReceived", post
                    posts.push post
                when Infinity > +item > 0 and Store.statuses[+item] instanceof Post
                    posts.push Store.statuses[+item]

If `chronological` was specified, we sort our data according to their id or when they were created, depending on its value:

            if chronological? and posts.length
                posts.sort sort.bind undefined , chronological

Next we walk the array and look for any duplicates, removing them.
There's no sense in doing this if we didn't sort our data.

>   __Note :__
>   Although `Timeline()` purports to remove all duplicate `Post`s, this behaviour is only guaranteed for *contiguous* `Post`s—for a chronological sort, this means posts whose `datetime` values are also the same.
>   If the same post ends up sorted to two different spots, `Timeline()` will leave both in place.
>   (Generally speaking, if you find yourself with two posts with identical `id`s but different `datetime`s, this is a sign that something has gone terribly wrong.)

                prev = null
                for index in [posts.length - 1 .. 0]
                    currentID = (post = posts[index]).id
                    if not currentID or prev? and currentID is prev.id and
                        ~(prev.type ^ post.type) & Post.Type.NOTIFICATION
                            posts.splice index, 1
                            continue
                    prev = post

Finally, we implement our list of `posts` as getters such that they always return the most current data.
**Note that this will likely prevent optimization of the `posts` array, so it is recommended that you make a static copy (using `Array.prototype.slice()` or similar) before doing intensive array operations with it.**

            @posts = []
            Object.defineProperty @posts , index , {
                enumerable : yes
                get        : getPost.bind this , post.id , post.type & Post.Type.NOTIFICATION
            } for post , index in posts
            Object.freeze @posts

            @length = @posts.length

            return Object.freeze this

###  The prototype:

The `Timeline` prototype has two functions.

    Object.defineProperty Timeline , "prototype" ,
        value : Object.freeze

####  `join()`.

The `join()` function creates a new `Timeline` which combines the `Post`s of the original and the provided `data`.
Its `data` argument can be either a `Post`, an array thereof, or a `Timeline`.

            join : (data , chronological) ->
                return this unless data instanceof Post or data instanceof Array or
                    data instanceof Timeline
                redacted = (post for post in @posts)
                combined.push post for post in (
                    switch
                        when data instanceof Post then [data]
                        when data instanceof Timeline then data.posts
                        else data
                ) when post instanceof Post
                return new Timeline combined , chronological

####  `remove()`.

The `remove()` function returns a new `Timeline` with the provided `Post`s removed.
Its `data` argument can be either a `Post`, an array thereof, or a `Timeline`.

            remove : (data , chronological) ->
                return this unless data instanceof Post or data instanceof Array or
                    data instanceof Timeline
                redacted = (post for post in @posts)
                redacted.splice index , 1 for post in (
                    switch
                        when data instanceof Post then [data]
                        when data instanceof Timeline then data.posts
                        else data
                ) when post instanceof Post and (index = redacted.indexOf post) isnt -1
                return new Timeline redacted , chronological
                
####  `sort()`.

The `sort()` function simply resorts a `Timeline`.

            sort : (chronological) -> new Timeline @posts , !!chronological

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
