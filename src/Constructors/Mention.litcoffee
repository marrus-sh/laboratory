#  THE MENTION CONSTRUCTOR  #

The `Mention()` constructor creates a unique, read-only object which represents a user mention.
Its properties are summarized below, alongside their Mastodon API equivalents:

|    Property    | API Response  | Description |
| :------------: | :-----------: | :---------- |
|      `id`      |     `id`      | The id of the mentioned account |
|     `href`     |     `url`     | The url of the mentioned account's profile |
|   `username`   |  `username`   | The mentioned account's username |
|   `account`    | Not provided  | The mentioned account's username, followed by their domain |
| `localAccount` |    `acct`     | The mentioned account's username, followed by their domain for remote users only |

##  Implementation  ##

###  The constructor:

The `Mention()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.
It uses the `origin` argument to help fill out account handles.

    Constructors.Mention = (data, origin) ->

        return unless this and (this instanceof Constructors.Mention) and data?

        @id = data.id
        @href = data.url
        @username = data.username
        @account = data.acct + (if origin? and data.acct.indexOf("@") is -1 then origin else "")
        @localAccount = data.acct

        return Object.freeze this

###  The prototype:

The `Mention` prototype just inherits from `Object`.

    Object.defineProperty Constructors.Mention, "prototype",
        value: Object.freeze {}
