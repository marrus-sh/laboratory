<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.4.0</i> <br> <code>Constructors/Authorization.litcoffee</code></p>

#  THE AUTHORIZATION CONSTRUCTOR  #

 - - -

##  Description  ##

The `Authorization()` constructor creates a unique, read-only object which represents a successful authorization request.
Its properties are summarized below, alongside their Mastodon API equivalents:

|   Property    |  API Response  | Description |
| :-----------: | :------------: | :---------- |
|   `origin`    | *Not provided* | The origin of the API request |
| `accessToken` | `access_token` | The access token received by the authorization |
|  `datetime`   |  `created_at`  | The `Date` the token was created |
|    `scope`    |    `scope`     | The `Authorization.Scope` associated with the access token |
|  `tokenType`  |  `token_type`  | Should always be the string `"bearer"` |
|     `me`      | *Not provided* | The id of the currently-signed-in account |

###  Scopes:

The possible `Authorization.Scope`s are as follows:

| Enumeral | Binary Value | Description |
| :------: | :----------: | :---------- |
| `Authorization.Scope.NONE` | `000` | No scope is defined |
| `Authorization.Scope.READ` | `001` | The scope is `"read"` |
| `Authorization.Scope.WRITE` | `010` | The scope is `"write"` |
| `Authorization.Scope.READWRITE` | `011` | The scope is `"read write"` |
| `Authorization.Scope.FOLLOW` | `100` | The scope is `"follow"` |
| `Authorization.Scope.READFOLLOW` | `101` | The scope is `"read follow"` |
| `Authorization.Scope.WRITEFOLLOW` | `110` | The scope is `"write follow"` |
| `Authorization.Scope.READWRITEFOLLOW` | `111` | The scope is `"read write follow"` |

 - - -

##  Implementation  ##

###  The constructor:

The `Authorization()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.
We also need to provide it with an `origin`.

    Laboratory.Authorization = Authorization = (data, origin, me) ->

        unless this and this instanceof Authorization
            throw new TypeError "this is not an Authorization"
        unless data?
            throw new TypeError "Unable to create Authorization; no data provided"

        @origin = String origin
        @accessToken = String data.access_token
        @datetime = new Date data.created_at
        @scope = Authorization.Scope.fromValue Authorization.Scope.READ *
            ("read" not in (scopes = (String data.scope).split /[\s\+]+/g)) +
            Authorization.Scope.WRITE * ("write" not in scopes) +
            Authorization.Scope.FOLLOW * ("follow" not in scopes)
        @tokenType = String data.tokenType
        @me = +me

        return Object.freeze this

###  The prototype:

The `Authorization` prototype just inherits from `Object`.

    Object.defineProperty Authorization, "prototype",
        value: Object.freeze {}

###  Defining our scopes:

Here we define our `Authorization.Scope`s, as described above:

    Authorization.Scope = Enumeral.generate
        NONE            : 0b000
        READ            : 0b001
        WRITE           : 0b010
        READWRITE       : 0b011
        FOLLOW          : 0b100
        READFOLLOW      : 0b101
        WRITEFOLLOW     : 0b110
        READWRITEFOLLOW : 0b111
