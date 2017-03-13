#  THE PROFILE CONSTRUCTOR  #

The `Profile()` constructor creates a unique, read-only object which represents an account's profile information.
Its properties are summarized below, alongside their Mastodon API equivalents:

|     Property     |    API Response   | Description |
| :--------------: | :---------------: | :---------- |
|       `id`       |       `id`        | The id of the account |
|    `username`    |    `username`     | The account's username |
|     `account`    |   Not provided    | The account's username, followed by their domain |
|  `localAccount`  |      `acct`       | The account's username, followed by their domain for remote users only |
|  `displayName`   |  `display_name`   | The account's display name |
|      `bio`       |      `note`       | The account's profile bio |
|      `href`      |      `url`        | The URL for the account's profile page |
|     `avatar`     |     `avatar`      | The URL for the account's avatar |
|     `header`     |     `header`      | The URL for the account's header |
|    `isLocked`    |     `locked`      | `true` if the account is locked; `false` otherwise |
| `followerCount`  | `followers_count` | The number of accounts following the given one |
| `followingCount` | `following_count` | The number of accounts that the given one is following |
|  `statusCount`   | `statuses_count`  | The number of statuses that the given account has posted |
|  `relationship`  |   Not provided    | A [`Laboratory.Relationship`](../Enumerals/Laboratory.Relationship) providing the relationship between the given account and the current user. |

##  Implementation  ##

###  The constructor:

The `Profile()` constructor takes a `data` object from an API response (or another `Profile` object) and reads its attributes into an instance's properties.
It uses the `origin` argument to help fill out account handles.
The `relationship` argument can be used to set the Profile relationship.

    Constructors.Profile = (data, origin, relationship) ->

        return unless this and (this instanceof Constructors.Profile) and data?

If our `data` is already a `Profile`, we can just copy its info over.

        if (data instanceof Constructors.Profile) then {@id, @username, @account, @localAccount, @displayName, @bio, @href, @avatar, @header, @isLocked, @followerCount, @followingCount, @statusCount, @relationship} = data

Otherwise, we have to change some variable names around.

        else
            @id = data.id
            @username = data.username
            @account = data.acct + (if origin? and data.acct.indexOf("@") is -1 then origin else "")
            @localAccount = data.acct
            @displayName = data.display_name
            @bio = data.note
            @href = data.url
            @avatar = data.avatar
            @header = data.header
            @isLocked = data.locked
            @followerCount = data.followers_count
            @followingCount = data.following_count
            @statusCount = data.statuses_count
            @relationship = Enumerals.Relationship.UNKNOWN

We set the relationship last, overwriting any previous relationship if one is provided.
This code will coerce the provided relationship into an Number and then back to an enumeral if possible.
Note that because enumerals are objects, they will always evaluate to `true` even if their value is `0x00`.

        @relationship = Enumerals.Relationship.fromValue(relationship) || @relationship if relationship?

        return Object.freeze this

###  The prototype:

The `Profile` prototype has one function.

    Object.defineProperty Constructors.Profile, "prototype",
        value: Object.freeze

`compare` does a quick comparison between two `Profile`s, and tells whether or not they are equivalent.
For efficiency's sake, it compares attributes with the most-likely-to-be-different ones first.

            compare: (other) ->

                return false unless other instanceof Constructors.Profile

                return (
                    @id is other.id and
                    @relationship is other.relationship and
                    @followerCount is other.followerCount and
                    @followingCount is other.followingCount and
                    @statusCount is other.statusCount and
                    @bio is other.bio and
                    @displayName is other.displayName and
                    @avatar is other.avatar and
                    @header is other.header and
                    @isLocked is other.isLocked and
                    @username is other.username and
                    @localAccount is other.localAccount and
                    @account is other.account and
                    @href is other.href
                )
