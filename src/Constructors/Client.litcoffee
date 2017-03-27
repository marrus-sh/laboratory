<p align="right">_Laboratory_ <br> Source Code and Documentation <br> API Version: _0.3.1_</p>

#  THE CLIENT CONSTRUCTOR  #

>   File location: `Constructors/Client.litcoffee`

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

##  Implementation  ##

###  The constructor:

The `Client()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.
We also need to provide it with the parameters of the API request, through the `params` object, and the origin of the request, through `origin`.

    Laboratory.Client = Client = (data, params, origin) ->

        throw new Error "Laboratory Error : `Client()` must be called as a constructor" unless this and this instanceof Client
        throw new Error "Laboratory Error : `Client()` was called without any `data`" unless data?

        @origin = origin
        @name = params.client_name
        @id = data.id
        @clientID = data.client_id
        @clientSecret = data.client_secret
        @scope = Authorization.Scope.fromValue Authorization.Scope.READ * (params.scopes.indexOf("read") isnt -1) + Authorization.Scope.WRITE * (params.scopes.indexOf("write") isnt -1) + Authorization.Scope.FOLLOW * (params.scopes.indexOf("follow") isnt -1)
        @redirect = data.redirect_uri

        return Object.freeze this

###  The prototype:

The `Client` prototype just inherits from `Object`.

    Object.defineProperty Client, "prototype",
        value: Object.freeze {}
