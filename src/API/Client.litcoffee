<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.4.0</i> <br> <code>API/Client.litcoffee</code></p>

#  CLIENT EVENTS  #

 - - -

##  Description  ##

The __Client__ module of Laboratory Events is comprised of those events which are related to OAuth registration of the Laboratory client with the Mastodon server.

###  Quick reference:

| Event | Description |
| :-------------- | :---------- |
| `LaboratoryClientRequested` | Fires when a client id and secret should be requested from the OAuth server |
| `LaboratoryClientReceived` | Fires when a client id and secret have been received from the OAuth server |
| `LaboratoryClientFailed` | Fires when a request for a client id and secret from the OAuth server failed |

###  Requesting client authorization:

>   - __API equivalent :__ `/api/v1/apps`
>   - __Request parameters :__
>       - __`name` :__ The name of the client application (default: `"Laboratory"`)
>       - __`url` :__ The location of the Mastodon server (default: `"/"`)
>       - __`redirect` :__ The base url for the application (default: `""`)
>       - __`scope` :__ A `Laboratory.Authorization.Scope` (default: `Laboratory.Authorization.Scope.READWRITEFOLLOW`)
>   - __Request :__ `LaboratoryClientRequested`
>   - __Response :__ `LaboratoryClientReceived`
>   - __Failure :__ `LaboratoryClientFailed`

The `LaboratoryClientRequested` event requests a new client id for use with OAuth.
Laboratory will fire this event automatically as necessary during the handling of `LaboratoryAuthorizationRequested`, so it isn't something you usually need to worry about.
However, you can request this yourself if you find yourself needing new client authorization.

 - - -

##  Implementation  ##

###  Creating the events:

Here we create the events as per our specifications.

    LaboratoryEvent
        .create "LaboratoryClientRequested",
            name: "Laboratory"
            url: "/"
            redirect: ""
            scope: Authorization.Scope.READ
        .create "LaboratoryClientReceived", Client
        .create "LaboratoryClientFailed", Failure
        .associate "LaboratoryClientRequested", "LaboratoryClientReceived", "LaboratoryClientFailed"

###  Handling the events:

Laboratory provides handlers for the following Client events:

- `LaboratoryClientRequested`

####  `LaboratoryClientRequested`.

The `LaboratoryClientRequested` handler requests a new client id and secret from the API, and fires `LaboratoryClientReceived` when it is granted.

        .handle "LaboratoryClientRequested", (event) ->

If we weren't provided with a scope, we'll set it to the default.

            scope = Authorization.Scope.READ unless (scope = event.detail.scope) instanceof Authorization.Scope

First, we normalize our URL.
We also get our redirect URI at this point.

            a = document.createElement "a"
            a.href = event.detail.url
            origin = a.origin
            a.href = event.detail.redirect or ""
            redirect = a.href

If our request completes, then we want to respond with a `Client` object.

            onComplete = (response, data, params) -> dispatch "LaboratoryClientReceived", new Client response, data, origin

Otherwise, we need to generate a `Failure`.

            onError = (response, data, params) -> dispatch "LaboratoryClientFailed", new Failure response.error, "LaboratoryClientRequested", params.status

Now we can send our request.

            serverRequest "POST", origin + "/api/v1/apps", {
                client_name: event.detail.name
                redirect_uris: event.detail.redirect
                scopes: do ->
                    scope = event.detail.scope
                    scopeList = []
                    scopeList.push "read" if scope & Authorization.Scope.READ
                    scopeList.push "write" if scope & Authorization.Scope.WRITE
                    scopeList.push "follow" if scope & Authorization.Scope.FOLLOW
                    return scopeList.join " "
            }, null, onComplete, onError
