<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.4.0</i> <br> <code>Constructors/Post.litcoffee</code></p>

#  THE POST CONSTRUCTOR  #

 - - -

##  Description  ##

The `Post()` constructor creates a unique, read-only object which represents an account's profile information.
Its properties are summarized below, alongside their Mastodon API equivalents:

|      Property      |    API Response     | Description |
| :----------------: | :-----------------: | :---------- |
|       `type`       |   *Not provided*    | A `Post.Type` |
|       `id`         |        `id`         | The id of the post |
|       `uri`        |        `uri`        | A fediverse-unique identifier for the post |
|      `href`        |        `url`        | The url of the post's page |
|     `author`      |       `account`      | The account who made the post |
|    `inReplyTo`     |  `in_reply_to_id`   | The id of the account who made the post |
|     `content`      |      `content`      | The content of the status |
|     `datetime`     |    `created_at`     | The time when the post was created |
|   `reblogCount`    |   `reblogs_count`   | The number of reblogs the post has |
|  `favouriteCount`  | `favourites_count`  | The number of favourites the post has |
|   `isReblogged`    |     `reblogged`     | Whether or not the user has reblogged the post |
|   `isFavourited`   |    `favourited`     | Whether or not the user has favourited the post |
|      `isNSFW`      |     `sensitive`     | Whether or not the post's media contains sensitive content |
|     `message`      |   `spoiler_text`    | The message to hide the post behind, if any |
|    `visibility`    |    `visibility`     | A `Post.Visibility` |
| `mediaAttachments` | `media_attachments` | An array of [`Attachment`](Attachment.litcoffee)s |
|     `mentions`     |     `mentions`      | An array of [`Profile`](Profile.litcoffee)s |
|   `application`    |   `application`     | A [`Application`](Application.litcoffee) identifying the application which created the post |
|   `rebloggedBy`    |   *Not provided*    | The account who reblogged the post; only set for reblog notifications |
|   `favouritedBy`   |   *Not provided*    | The account who favourited the post; only set for favourite notifications |

`Post`s will not necessarily contain all of the above properties.
Follow notifcations will only have a `type`, `id`, and `author`, and the `rebloggedBy` and `favouritedBy` properties only show up on reblog and favourite reactions, respectively.
If a reaction has neither of these properties, then it must be a mention.

###  Post types:

The available `Post.Type`s are as follows:

| Enumeral | Hex Value | Description |
| :------: | :-------: | :---------- |
| `Post.Type.UNKNOWN` | `0x00` | The post type cannot be determined |
| `Post.Type.STATUS` | `0x10` | The post is an status |
| `Post.Type.NOTIFICATION` | `0x20` | The post is a notification |
| `Post.Type.FOLLOW` | `0x21` | The post is a notification |
| `Post.Type.REACTION` | `0x30` | The post is a notification responding to another post |
| `Post.Type.FAVOURITE` | `0x31` | The post is a notification responding to another post |
| `Post.Type.REBLOG` | `0x32` | The post is a notification responding to another post |
| `Post.Type.MENTION` | `0x33` | The post is a notification responding to another post |

Note that not all of the above types will necessarily ever appear on posts; `Post.Type.NOTIFICATION` and `Post.Type.REACTION` exist purely for use with binary comparison tests.

###  Post visibilities:

The available `Post.Visibility`s are as follows:

| Enumeral | Binary Value | Description |
| :------: | :-----------: | :---------- |
| `Post.Visibility.PRIVATE` | `00` | The post cannot be reblogged and appears as unlisted |
| `Post.Visibility.REBLOGGABLE` | `01` | The post is unlisted but can be reblogged |
| `Post.Visibility.LISTED` | `10` | The post is listed but can't be reblogged |
| `Post.Visibility.PUBLIC` | `11` | The post is listed and can be reblogged |

However, note that `Visibility.LISTED` (`0x02`) is not a valid visibility for a Mastodon post.

The visibility of the post can be evaluating using bitwise comparisons: `visibility & Post.Visibility.LISTED` will detect whether a post is listed or unlisted, for example.

###  Prototype methods:

####  `compare()`.

>   ```javascript
>       Laboratory.Post.prototype.compare(post);
>   ```
>
>   - __`post` :__ A `Post` to compare with

The `compare()` prototype method compares a `Post` with another and returns `true` if they have the same properties.
For efficiency, if two `Post`s have the same `id` then `compare()` will only test those properties which are likely to change.

 - - -

##  Implementation  ##

###  The constructor:

The `Post()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.

    Laboratory.Post = Post = (data) ->

        unless this and this instanceof Post
            throw new TypeError "this is not a Post"
        unless data?
            throw new TypeError "Unable to create Post; no data provided"

We'll use the `getProfile()` function in our various account getters.

        profiles = Store.profiles
        getProfile = (id) -> profiles[id]

The `Post()` constructor can be called with either a status response or a notification one.
We can check this fairly readily by checking for the presence of the `status` attibute.
If `data` has an associated `type`, then it must be a notification.
We pull the notification data and then overwrite `data` to just show the post.

        if data.type?
            @id = data.id
            fromID = data.account.id
            if data.status
                switch data.type
                    when "reblog"
                        @type = Post.Type.REBLOG
                        Object.defineProperty this, "rebloggedBy",
                            get: getProfile.bind this, fromID
                            enumerable: yes
                    when "favourite"
                        @type = Post.Type.FAVOURITE
                        Object.defineProperty this, "favouritedBy",
                            get: getProfile.bind this, fromID
                            enumerable: yes
                    when "mention" then @type = Post.Type.MENTION
                    else @type = Post.Type.REACTION
                data = data.status
            else
                Object.defineProperty this, "author",
                    get: getProfile.bind this, fromID
                    enumerable: yes
                switch data.type
                    when "follow" then @type = Post.Type.FOLLOW
                    else @type = Post.Type.NOTIFICATION
                return Object.freeze this


If our `data` isn't a notification then we can use its `id` like normal.

        else
            @type = Post.Type.STATUS
            @id = data.id

That said, it is possible our `data` is a normal (non-notification) reblog.
In which case, we want to use the original post for extracting our data.

            if data.reblog
                Object.defineProperty this, "rebloggedBy",
                    get: getProfile.bind this, data.account.id
                    enumerable: yes
                data = data.reblog

Now we can set the rest of our properties.

        @uri = String data.uri
        @href = String data.url
        Object.defineProperty this, "author",
            get: getProfile.bind this, data.account.id
            enumerable: yes
        @inReplyTo = Number data.in_reply_to_id
        @content = String data.content
        @datetime = new Date data.created_at
        @reblogCount = Number data.reblogs_count
        @favouriteCount = Number data.favourites_count
        @isReblogged = !!data.reblogged
        @isFavourited = !!data.favourited
        @isNSFW = !!data.sensitive
        @message = String data.spoiler_text
        @visibility = {
            private: Post.Visibility.PRIVATE
            unlisted: Post.Visibility.REBLOGGABLE
            public: Post.Visibility.PUBLIC
        }[data.visibility] or Post.Visibility.PRIVATE
        @mediaAttachments = (new Attachment item for item in data.media_attachments)
        @mentions = do =>
            mentions = []
            Object.defineProperty mentions, index, {
                enumerable: yes
                get: getProfile.bind(this, mention.id)
            } for mention, index in data.mentions
            return Object.freeze mentions
        @application = if data.application? then new Application data.application else null

        return Object.freeze this

###  The prototype:

The `Post` prototype has one function.

    Object.defineProperty Post, "prototype",
        value: Object.freeze

`compare` does a quick comparison between two `Post`s, and tells whether or not they are equivalent.
For efficiency's sake, if the ids of the two posts are the same, it only compares those values which should be considered mutable.

            compare: (other) ->

                return no unless this instanceof Post and other instanceof Post

                return (
                    @type is other.type and
                    @id is other.id and
                    @reblogCount is other.reblogCount and
                    @favouriteCount is other.favouriteCount and
                    @isReblogged is other.isReblogged and
                    @isFavourited is other.isFavourited
                )

###  Defining our enumerals:

Here we define our enumerals as described above.

    Post.Type = Enumeral.generate
        UNKNOWN      : 0x00
        STATUS       : 0x10
        NOTIFICATION : 0x20
        FOLLOW       : 0x21
        REACTION     : 0x30
        FAVOURITE    : 0x31
        REBLOG       : 0x32
        MENTION      : 0x33

    Post.Visibility = Enumeral.generate
        PRIVATE      : 0x00
        REBLOGGABLE  : 0x01
        LISTED       : 0x02
        PUBLIC       : 0x03

