#  THE FOLLOW CONSTRUCTOR  #

The `Follow()` constructor creates a unique, read-only object which represents a follow by another user.
Its properties are summarized below, alongside their Mastodon API equivalents:

|  Property  | API Response | Description |
| :--------: | :----------: | :---------- |
|    `id`    |     `id`     | The id of follow notification |
| `follower` |  `account`   | The account who issued the follow |

##  Implementation  ##

###  The constructor:

The `Follow()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.
In order to ensure that `Follow`s always have the most recent account data, they will calculate their `account` parameter on-demand by looking up the account's id from a list of `accounts`.
(This should be a list of `Profile`s, although this is not enforced.)

    Constructors.Follow = (data, accounts) ->

        return unless this and (this instanceof Constructors.Follow) and data?

        @follower = data.account.id

        @id = data.id
        Object.defineProperty this, "follower",
            get: -> accounts[author]
            enumerable: yes

        return Object.freeze this

###  The prototype:

The `Follow` prototype just inherits from `Object`.

    Object.defineProperty Constructors.Follow, "prototype",
        value: Object.freeze {}
