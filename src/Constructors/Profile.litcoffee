_Laboratory_<br>
Source Code and Documentation<br>
API Version: _0.3.1_

#  THE PROFILE CONSTRUCTOR  #

>   File location: `Constructors/Profile.litcoffee`

 - - -

##  Description  ##

The `Profile()` constructor creates a unique, read-only object which represents an account's profile information.
Its properties are summarized below, alongside their Mastodon API equivalents:

|     Property     |    API Response   | Description |
| :--------------: | :---------------: | :---------- |
|       `id`       |       `id`        | The id of the account |
|    `username`    |    `username`     | The account's username |
|     `account`    |  *Not provided*   | The account's username, followed by their domain |
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
|  `relationship`  |  *Not provided*   | A `Laboratory.Profile.Relationship`, providing the relationship between the given account and the current user. |

###  Profile relationiships:

The available `Profile.Relationship`s are as follows:

| Enumeral | Binary Value | Description |
| :------: | :----------: | :---------- |
| `Profile.Relationship.NOT_FOLLOWING` | `00000000` | Neither the account nor the user are following each other |
| `Profile.Relationship.FOLLOWER` | `00000001` | The user is being followed by the account |
| `Profile.Relationship.FOLLOWING` | `00000010` | The account is being followed by the user |
| `Profile.Relationship.MUTUAL` | `00000011` | The user and the account are following each other |
| `Profile.Relationship.REQUESTED` | `00000100` | The user has requested to follow the account |
| `Profile.Relationship.REQUESTED_MUTUAL` | `00000101` | The account follows the user, and the user has requested to follow the account |
| `Profile.Relationship.BLOCKING` | `00001000` | The user is blocking the account |
| `Profile.Relationship.MUTING` | `00010000` | The user is muting the account |
| `Profile.Relationship.MUTING_FOLLOWER` | `00010001` | The user is muting, and being followed by, the account |
| `Profile.Relationship.MUTING_FOLLOWING` | `00010010` | The user is muting and following the account |
| `Profile.Relationship.MUTING_MUTUAL` | `00010011` | The user and the account are following each other, but the user is muting the account |
| `Profile.Relationship.MUTING_REQUESTED` | `00010100` | The user is muting the account, but has also requested to follow it |
| `Profile.Relationship.MUTING_REQUESTED_MUTUAL` | `00010101` | The user is muting, and being followed by, the accoung, but has also requested to follow it |
| `Profile.Relationship.UNKNOWN` | `01000000` | The relationship between the user and the account is unknown |
| `Profile.Relationship.SELF` | `10000000` | The account is the user |

You can use bitwise comparisons on these enumerals to test for a specific relationship status.
Of course, many combinations are not possible.

|    Flag    | Enumeral | Meaning |
| :--------: | -------- | ------- |
| `00000001` | `Profile.Relationship.FOLLOWER` | The user is followed by the account |
| `00000010` | `Profile.Relationship.FOLLOWING` | The account is followed by the user |
| `00000100` | `Profile.Relationship.REQUESTED` | The user has sent a follow request to the account |
| `00001000` | `Profile.Relationship.BLOCKING` | The user is blocking the account |
| `00010000` | `Profile.Relationship.MUTING` | The user is muting the account |
| `00100000` | _Unused_ | Reserved for later use |
| `01000000` | `Profile.Relationship.UNKNOWN` | The relationship status between the user and the account is unknown |
| `10000000` | `Profile.Relationship.SELF` | The user is the same as the account |

###  Prototype methods:

####  `compare()`.

>   ```javascript
>       Laboratory.Profile.prototype.compare(profile);
>   ```
>
>   - __`profile` :__ A `Profile` to compare with

The `profile()` prototype method compares a `Profile` with another and returns `true` if they have the same properties.

 - - -

##  Implementation  ##

###  The constructor:

The `Profile()` constructor takes a `data` object from an API response (or another `Profile` object) and reads its attributes into an instance's properties.
Additionally, the `relationship` argument can be used to set the Profile relationship.

    Laboratory.Profile = Profile = (data, relationship) ->

        throw new Error "Laboratory Error : `Profile()` must be called as a constructor" unless this and this instanceof Profile
        throw new Error "Laboratory Error : `Profile()` was called without any `data`" unless data?
        
If the `relationship` isn't provided, we check to see if we already have one for this id in our `Store`.

        relationship = Store.profiles[data.id]?.relationship unless relationship?

If our `data` is already a `Profile`, we can just copy its info over.

        if data instanceof Profile then {@id, @username, @account, @localAccount, @displayName, @bio, @href, @avatar, @header, @isLocked, @followerCount, @followingCount, @statusCount, @relationship} = data

Otherwise, we have to change some variable names around.

        else
            @id = Number data.id
            @username = String data.username
            @account = String data.acct + (if (origin = Store.auth.origin)? and data.acct.indexOf("@") is -1 then "@" + origin else "")
            @localAccount = String data.acct
            @displayName = String data.display_name
            @bio = String data.note
            @href = String data.url
            @avatar = String data.avatar
            @header = String data.header
            @isLocked = !!data.locked
            @followerCount = Number data.followers_count
            @followingCount = Number data.following_count
            @statusCount = Number data.statuses_count
            @relationship = if data.id is Store.auth.me then Profile.Relationship.SELF else Profile.Relationship.UNKNOWN

We set the relationship last, overwriting any previous relationship if one is provided.
This code will coerce the provided relationship into an Number and then back to an enumeral if possible.
Remember that because enumerals are objects, they will always evaluate to `true` even if their value is `0x00`.

        @relationship = Profile.Relationship.fromValue(relationship) || @relationship if relationship?

        return Object.freeze this

###  The prototype:

The `Profile` prototype has one function.

    Object.defineProperty Profile, "prototype",
        value: Object.freeze

`compare` does a quick comparison between two `Profile`s, and tells whether or not they are equivalent.
For efficiency's sake, it compares attributes with the most-likely-to-be-different ones first.

            compare: (other) ->

                return false unless this instanceof Profile and other instanceof Profile

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

###  Defining profile relationships:

Here we define profile relationships, as specified above.

    Profile.Relationship = Enumeral.generate
        NOT_FOLLOWING           : 0b00000000
        FOLLOWER                : 0b00000001
        FOLLOWING               : 0b00000010
        MUTUAL                  : 0b00000011
        REQUESTED               : 0b00000100
        REQUESTED_MUTUAL        : 0b00000101
        BLOCKING                : 0b00001000
        MUTING                  : 0b00010000
        MUTING_FOLLOWER         : 0b00010001
        MUTING_FOLLOWING        : 0b00010010
        MUTING_MUTUAL           : 0b00010011
        MUTING_REQUESTED        : 0b00010100
        MUTING_REQUESTED_MUTUAL : 0b00010101
        UNKNOWN                 : 0b01000000
        SELF                    : 0b10000000
