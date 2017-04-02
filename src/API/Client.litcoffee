<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.4.0</i> <br> <code>API/Client.litcoffee</code></p>

#  CLIENT REQUESTS  #

 - - -

##  Description  ##

The __Client__ module of the Laboratory API is comprised of those requests which are related to the OAuth registration of the Laboratory client with the Mastodon server.
You shouldn't typically need to interact with this module directly.

###  Quick reference:

####  Requests.

| Request | Description |
| :------ | :---------- |
| `Client.Request()` | Requests authorization from the Mastodon server. |

####  Events.

| Event | Description |
| :---- | :---------- |
| `LaboratoryClientReceived` | Fires when a client id and secret have been received from the OAuth server |

###  Requesting a client:

>   ```javascript
>   request = new Laboratory.Client.Request(data);
>   ```
>
>   - __API equivalent :__ `/api/v1/apps`
>   - __Data parameters :__
>       - __`name` :__ The name of the client application (default: `"Laboratory"`)
>       - __`origin` :__ The location of the Mastodon server (default: `"/"`)
>       - __`redirect` :__ The base url for the application (default: `""`)
>       - __`scope` :__ A `Laboratory.Authorization.Scope` (default: `Laboratory.Authorization.Scope.READ`)
>   - __Response :__ A [`Client`](../Constructors/Client.litcoffee)

`Client.Request()` requests a new client id for use with OAuth.
Laboratory will fire this event automatically as necessary during its operation of `Authorization.Request()`, so this isn't something you usually need to worry about.
However, you can request this yourself if you find yourself needing new client authorization.

 - - -

##  Examples  ##

###  Requesting client authorization:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the response
>   }
>
>   var request = new Laboratory.Client.Request({
>       name: "My Application",
>       origin: "https://myinstance.social",
>       redirect: "/",
>       scope: Laboratory.Authorization.Scope.READWRITEFOLLOW
>   });
>   request.addEventListener("response", requestCallback);
>   request.start();
>   ```

 - - -

##  Implementation  ##

###  Making the request:

    Object.defineProperty Client, "Request",
        configurable: no
        enumerable: yes
        writable: no
        value: do ->

            ClientRequest = (data) ->

                unless this and this instanceof ClientRequest
                    throw new TypeError "this is not a ClientRequest"

If we weren't provided with a scope, we'll set it to the default.
We can set our default `name` here as well.

                name = (String data.name) or "Laboratory"
                scope =
                    if data.scope instance of Authorization.Scope then data.scope
                    else Authorization.Scope.READ

First, we normalize our URL.
We also get our redirect URI at this point.

                a = document.createElement "a"
                a.href = data.origin or "/"
                origin = a.origin
                a.href = data.redirect or ""
                redirect = a.href

This creates our request.

                Request.call this, "POST", origin + "/api/v1/apps", {
                    client_name: name
                    redirect_uris: redirect
                    scopes: (
                        scope = event.detail.scope
                        scopeList = []
                        scopeList.push "read" if scope & Authorization.Scope.READ
                        scopeList.push "write" if scope & Authorization.Scope.WRITE
                        scopeList.push "follow" if scope & Authorization.Scope.FOLLOW
                        scopeList.join " "
                    )
                }, null, (result) => dispatch "LaboratoryClientReceived", decree =>
                    @response = police -> new Client result, origin, name, scope

                Object.freeze this

We just let our prototype inherit from `Request`.

            Object.defineProperty ClientRequest, "prototype",
                configurable: no
                enumerable: no
                writable: no
                value: Object.freeze Object.create Request.prototype,
                    constructor:
                        enumerable: no
                        value: ClientRequest

            return ClientRequest

###  Creating the events:

Here we create the events as per our specifications.

    LaboratoryEvent
        .create "LaboratoryClientReceived", Client

###  Handling the events:

Laboratory Client events do not have handlers.
