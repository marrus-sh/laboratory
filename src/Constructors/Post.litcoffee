#  THE POST CONSTRUCTOR  #

The `Post()` constructor creates a unique, read-only object which represents an account's profile information.
Its properties are summarized below, alongside their Mastodon API equivalents:

|      Property      |    API Response     | Description |
| :----------------: | :-----------------: | :---------- |
|       `type`       |    Not provided     | A [`Laboratory.PostType`](../Enumerals/PostType.litcoffee) |
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
|    `visibility`    |    `visibility`     | A [`Laboratory.Visibility`](../Enumerals/Visibility.litcoffee) |
| `mediaAttachments` | `media_attachments` | An array of [`Laboratory.MediaAttachment`](MediaAttachment.litcoffee)s |
|     `mentions`     |     `mentions`      | An array of [`Laboratory.Mention`](Mention.litcoffee)s |
|   `application`    |   `application`     | A [`Laboratory.Application`](Application.litcoffee) identifying the application which created the post |
|   `rebloggedBy`    |    Not provided     | The id of the account who reblogged the post; only set for reblog notifications |
|   `favouritedBy`   |    Not provided     | The id of the account who favourited the post; only set for favourite notifications |

##  Implementation  ##

###  The constructor:

The `Post()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.
In order to ensure that `Post`s always have the most recent account data, they will calculate their `account` parameter on-demand by looking up the account's id from a list of `accounts`.
(This should be a list of `Profile`s, although this is not enforced.)

    Constructors.Post = (data, accounts) ->

        return unless this and (this instanceof Constructors.Post) and data?

The `Post()` constructor can be called with either a status response or a notification one.
We can check this fairly readily by checking for the presence of the `status` attibute.
If `data` has an associated `status`, then it must be a notification.
We pull the notification data and then overwrite `data` to just show the post.

        if data.status
            @type = Enumerals.PostType.NOTIFICATION
            @id = data.id
            switch data.type
                when "reblog"
                    Object.defineProperty this, "rebloggedBy",
                        get: -> accounts[data.account.id]
                        enumerable: yes
                when "favourite"
                    Object.defineProperty this, "favouritedBy",
                        get: -> accounts[data.account.id]
                        enumerable: yes
                # when "mention" then the mentioner is just the author of the post :P
            data = data.status

If our `data` isn't a notification then we can use its `id` like normal.

        else
            @type = Enumerals.PostType.STATUS
            @id = data.id

That said, it is possible our `data` is a normal (non-notification) reblog.
In which case, we want to use the original post for extracting our data.

            if data.reblog
                Object.defineProperty this, "rebloggedBy",
                    get: -> accounts[data.account.id]
                    enumerable: yes
                data = data.reblog

Now we can set the rest of our properties.

        @uri = data.uri
        @href = data.url
        Object.defineProperty this, "author",
            get: -> accounts[data.account.id]
            enumerable: yes
        @inReplyTo = data.in_reply_to_id
        @content = data.content
        @datetime = data.created_at
        @reblogCount = data.reblogs_count
        @favouriteCount = data.favourites_count
        @isReblogged = data.reblogged
        @isFavourited = data.favourited
        @isNSFW = data.sensitive
        @message = data.spoiler_text
        @visibility = {
            private: Enumerals.Visibility.PRIVATE
            unlisted: Enumerals.Visibility.UNLISTED
            public: Enumerals.Visibility.PUBLIC
        }[data.visibility] || Enumerals.Visibility.UNLISTED
        @mediaAttachments = (new Constructors.MediaAttachment item for item in data.media_attachments)
        @mentions = (new Constructors.Mention item for item in data.mentions)
        @application = new Constructors.Application data.application

        return Object.freeze this

###  The prototype:


The `Post` prototype has one function.

    Object.defineProperty Constructors.Post, "prototype",
        value: Object.freeze

`compare` does a quick comparison between two `Post`s, and tells whether or not they are equivalent.
For efficiency's sake, if the ids of the two posts are the same, it only compares those values which should be considered mutable.

            compare: (other) ->

                return false unless other instanceof Constructors.Post

                return (
                    @type is other.type and
                    @id is other.id and
                    @reblogCount is other.reblogCount and
                    @favouriteCount is other.favouriteCount and
                    @isReblogged is other.isReblogged and
                    @isFavourited is other.isFavourited
                )
