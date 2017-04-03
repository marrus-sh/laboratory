<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.4.0</i> <br> <code>Constructors/Client.litcoffee</code></p>

#  THE CLIENT CONSTRUCTOR  #

 - - -

##  Description  ##

The `Client()` constructor creates a unique, read-only object which represents a registered Mastodon client.
It is unlikely you will ever need to call this constructor yourself.
Its properties are summarized below, alongside their Mastodon API equivalents:

|    Property    |  API Response   | Description |
| :------------: | :-------------: | :---------- |
|    `origin`    | *Not provided*  | The origin of the API request |
|     `name`     | *Not provided*  | The name of the client |
|      `id`      |      `id`       | The internal id for the client|
|   `clientID`   |   `client_id`   | The public id of the client |
| `clientSecret` | `client_secret` | The private (secret) id of the client |
|    `scope`     | *Not provided*  | The [`Authorization.Scope`](Authorization.litcoffee) associated with the client |
|   `redirect`   | `redirect_uri`  | The redirect URL associated with the client |

 - - -

##  Examples  ##

>   __[Issue #53](https://github.com/marrus-sh/laboratory/issues/53) :__
>   Usage examples for constructors are forthcoming.

 - - -

##  Implementation  ##

###  The constructor:

The `Client()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.
It also takes a couple of other arguments.

>   __[Issue #37](https://github.com/marrus-sh/laboratory/issues/37) :__
>   The `Client()` constructor may be modified to be more user-friendly in the future.

    Laboratory.Client = Client = (data, origin, name, scope) ->

        unless this and this instanceof Client
            throw new TypeError "this is not a Client"
        unless data?
            throw new TypeError "Unable to create Client; no data provided"

        @origin = origin
        @name = name
        @id = data.id
        @clientID = data.client_id
        @clientSecret = data.client_secret
        @scope = scope
        @redirect = data.redirect_uri

        return Object.freeze this

###  The prototype:

The `Client` prototype just inherits from `Object`.

    Object.defineProperty Client, "prototype",
        value: Object.freeze {}
