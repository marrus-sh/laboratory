<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.4.0</i> <br> <code>API/Authorization.litcoffee</code></p>

#  AUTHORIZATION REQUESTS  #

 - - -

##  Description  ##

The __Authorization__ module of the Laboratory API is comprised of those requests which are related to OAuth registration of the Laboratory client with the Mastodon server.

###  Quick reference:

####  Requests.

| Request | Description |
| :------ | :---------- |
| `Authorization.Request()` | Requests authorization from the Mastodon server. |

####  Events.

| Event | Description |
| :---- | :---------- |
| `LaboratoryAuthorizationReceived` | Fires when an access token has been received from the OAuth server |

>   __[Issue #50](https://github.com/marrus-sh/laboratory/issues/50) :__
>   Authorization events may not fire in the future.

###  Requesting authorization:

>   ```javascript
>   request = new Laboratory.Authorization.Request(data);
>   ```
>
>   - __API equivalent :__ `/oauth/token`, `/api/v1/verify_credentials`
>   - __Data parameters :__
>       - __`name` :__ The name of the client application (default: `"Laboratory"`)
>       - __`origin` :__ The location of the Mastodon server (default: `"/"`)
>       - __`redirect` :__ The base url for the application (default: `""`)
>       - __`scope` :__ An `Authorization.Scope` (default: `Authorization.Scope.READ`)
>       - __`accessToken` :__ If provided, Laboratory should attempt to use the given access token instead of fetching a new one of its own.
>   - __Response :__ An [`Authorization`](../Constructors/Authorization.litcoffee)

`Authorization.Request()` is used to request an access token for use with OAuth.
This will likely be the first request you make when interacting with Laboratory.
This data will be made available through the `Laboratory` object, so you probably don't need to keep track of its response yourself.

The OAuth request for authorization needs to take place in a separate window; you can specify this by passing it as an argument to `request.start()`.
If unspecified, Laboratory will try to open a window on its own (named `LaboratoryOAuth`); note that popup blockers will likely block this though.
You don't need to specify a `window` if you're passing through an `accessToken`.

 - - -

##  Examples  ##

###  Getting authorization:

>   ```javascript
>   function requestCallback(event) {
>       if (event.response instanceof Laboratory.Authorization) startMyApplication();
>   }
>
>   var request = new Laboratory.Authorization.Request({
>       name: "My Application",
>       origin: "https://myinstance.social",
>       redirect: "/",
>       scope: Laboratory.Authorization.Scope.READWRITEFOLLOW
>   });
>   request.addEventListener("response", requestCallback);
>   request.start(authWindow);
>   ```

###  Using a predetermined access token:

>   ```javascript
>   function requestCallback(event) {
>       if (event.response instanceof Laboratory.Authorization) startMyApplication();
>   }
>
>   var request = new Laboratory.Authorization.Request({
>       origin: "https://myinstance.social",
>       accessToken: myAccessToken
>       scope: Laboratory.Authorization.Scope.READWRITEFOLLOW
>   });
>   request.addEventListener("response", requestCallback);
>   request.start();
>   ```

 - - -

##  Implementation  ##

###  Making the request:

This code is very complex because OAuth is very complex lol.
It is split among a number of functions because it depends on several asynchronous calls.

    Object.defineProperty Authorization, "Request",
        configurable: no
        enumerable: yes
        writable: no
        value: do ->

####  Stopping an existing request.

The `stopRequest()` function closes out of any existing request.
We explicitly return nothing because `stopRequest` is actually made transparent to the window.

            stopRequest = ->

                unless this?.currentRequest instanceof Authorization.Request
                    throw new TypeError "No defined AuthorizationRequest"

                do @wrapup if typeof @wrapup is "function"
                do @waitingRequest.stop if typeof @waitingRequest?.stop is "function"
                do @window.close if @window instanceof Window
                @waitingRequest = @callback = @window = undefined
                return

####  Starting a new request.

The `startRequest()` function starts a new request.
Its `this` value is an object which contains the request parameters and will get passed along the entire request.

            startRequest = (window) ->

                unless this?.currentRequest instanceof Authorization.Request
                    throw new TypeError "No defined AuthorizationRequest"
                do @currentRequest.stop
                @window = window if window? and not window.closed

We can only make our request once we have been registered as a client.
Laboratory stores its client and authorization data in `localStorage`.
Here we try to access that data if present:

                [storedRedirect, @clientID, @clientSecret, storedScope, storedAccessToken] =
                    if localStorage?.getItem "Laboratory | " + @origin
                        (localStorage.getItem "Laboratory | " + @origin).split " ", 5
                    else []

If we have an access token which supports our `scope` then we can immediately try using it.
We'll just forward it to `finishRequest()`.
It is important that we `return` here or else we'll end up requesting another token anyway.

                if (accessToken = @accessToken) or (accessToken = storedAccessToken) and
                    (@scope & storedScope) is +@scope
                        finishRequest.call this,
                            access_token: accessToken
                            created_at: NaN
                            scope: (
                                scopeList = []
                                scopeList.push "read" if @scope & Authorization.Scope.READ
                                scopeList.push "write" if @scope & Authorization.Scope.WRITE
                                scopeList.push "follow" if @scope & Authorization.Scope.FOLLOW
                                scopeList.join " "
                            )
                            token_type: "bearer"
                        return

If we have client credentials and they are properly associated with our `redirect` and `scope`, we can go ahead and `makeRequest()`.

                if storedRedirect is @redirect and (@scope & storedScope) is +@scope and
                    @clientID and @clientSecret then makeRequest.call this

Otherwise, we need to get new client credentials before proceeding.

                else

                    handleClient = (event) =>
                        return unless (client = event.detail.response) instanceof Client and
                            @currentRequest and client.origin is @origin and
                            (@scope & client.scope) is +@scope and client.redirect is @redirect and
                            client.clientID and client.clientSecret
                        [@clientID, @clientSecret] = [client.clientID, client.clientSecret]
                        localStorage.setItem "Laboratory | " + @origin, [
                            client.redirect,
                            client.clientID,
                            client.clientSecret,
                            +client.scope
                        ].join " "
                        clearTimeout timeout
                        @wrapup = undefined
                        @waitingRequest.removeEventListener "response", handleClient
                        makeRequest.call this

                    @waitingRequest = new Client.Request {@name, @origin, @redirect, @scope}

                    @waitingRequest.addEventListener "response", handleClient
                    @wrapup = => @waitingRequest.removeEventListener "response", handleClient
                    do @waitingRequest.start

If we aren't able to acquire a client ID within 30 seconds, we timeout.

                    timeout = setTimeout (
                        ->
                            do @currentRequest.stop
                            @dispatchEvent new CustomEvent "failure",
                                request: this
                                response: new Failure "Unable to authorize client"
                    ), 30000

Again, we have to explicitly return nothing because the window can see us.

                return

####  Requesting a token.

The `makeRequest()` function will request our token once we acquire a client id and secret.
Of course, it is possible that we already have these.

            makeRequest = ->

                unless this?.currentRequest instanceof Authorization.Request
                    throw new TypeError "No defined AuthorizationRequest"

The actual token requesting takes place after authorization has been granted by the popup window (see the script at the beginning of [README](../README.litcoffee)); but we open it up here.

>   __Note :__
>   This window **will be blocked** by popup blockers unless it has already been opened previously in response to a click or keyboard event.

                location = @origin + "/oauth/authorize?" + (
                    (
                        (encodeURIComponent key) + "=" + (encodeURIComponent value) for key, value of {
                            client_id: @clientID
                            response_type: "code"
                            redirect_uri: @redirect
                            scope: (
                                scopeList = []
                                scopeList.push "read" if @scope & Authorization.Scope.READ
                                scopeList.push "write" if @scope & Authorization.Scope.WRITE
                                scopeList.push "follow" if @scope & Authorization.Scope.FOLLOW
                                scopeList.join " "
                            )
                        }
                    ).join "&"
                )
                if @window then @window.location = location
                else @window = window.open location, "LaboratoryOAuth"

Now we wait for a message from the popup window containing its key.

                callback = (event) =>
                    return unless event.source is @window and event.origin is window.location.origin
                    getToken.call this, event.data
                    do event.source.close
                    @window = null
                    @wrapup = undefined
                    window.removeEventListener "message", callback
                    callback = undefined

                window.addEventListener "message", callback
                @wrapup = -> window.removeEventListener "message", callback

####  Getting an access token.

The `getToken()` function takes a code received from a Laboratory popup and uses it to request a new access token from the server.

            getToken = (code) ->

                unless this?.currentRequest instanceof Authorization.Request
                    throw new TypeError "No defined AuthorizationRequest"

                do @waitingRequest.stop if typeof @waitingRequest?.stop is "function"

                do (
                    @waitingRequest = new Request "POST", @origin + "/oauth/token", {
                        client_id: @clientID
                        client_secret: @clientSecret
                        redirect_uri: @redirect
                        grant_type: "authorization_code"
                        code: code
                    }, null, finishRequest.bind this
                ).start

####  Finishing the request.

The `finishRequest()` function takes the server response from a token request and uses it to verify our token, and complete our authorization request.
During verification, the Mastodon server will provide us with the current user's data, which we will dispatch via a `LaboratoryProfileReceived` event to our store.

            finishRequest = (result) ->

                unless this?.currentRequest instanceof Authorization.Request
                    throw new TypeError "No defined AuthorizationRequest"

                do @waitingRequest.stop if typeof @waitingRequest?.stop is "function"
                location = @origin + "/api/v1/accounts/verify_credentials"
                @accessToken = String result.access_token

                do (
                    @waitingRequest = new Request "GET", location, null, @accessToken, (mine) =>
                        decree => @currentRequest.response = police =>
                            new Authorization result, @origin, mine.id
                        dispatch "LaboratoryAuthorizationReceived", @currentRequest.response
                        localStorage.setItem "Laboratory | " + @origin, [
                            @redirect
                            @clientID
                            @clientSecret
                            Authorization.Scope.READ *
                                ("read" in (scopes = result.scope.split /[\s\+]+/g)) +
                                Authorization.Scope.WRITE * ("write" in scopes) +
                                Authorization.Scope.FOLLOW * ("follow" in scopes)
                            @accessToken
                            ].join " "
                        dispatch "LaboratoryProfileReceived", new Profile mine
                        do @currentRequest.stop
                ).start

####  Defining the `Authorization.Request()` constructor.

            AuthorizationRequest = (data) ->

                unless this and this instanceof AuthorizationRequest
                    throw new TypeError "this is not an AuthorizationRequest"

If we weren't provided with a scope, we'll default to `READ`.
We store all our provided properties in an object called `recalled`, which we will pass along our entire request.

                recalled =
                    currentRequest: this
                    waitingRequest: undefined
                    callback: undefined
                    scope:
                        if data.scope instanceof Authorization.Scope then data.scope
                        else Authorization.Scope.READ
                    name: if data.name? then String data.name else "Laboratory"
                    accessToken:
                        if data.accessToken? then String data.accessToken
                        else undefined
                    window: undefined
                    clientID: undefined
                    clientSecret: undefined

We need to do some work to normalize our origin and get our final redirect URI.

                    origin: (
                        a = document.createElement "a"
                        a.href = data.origin or "/"
                        a.origin
                    )
                    redirect: (
                        a.href = data.redirect or ""
                        a.href
                    )

We now set up our `Request()`—although we won't actually use it to talk to the server.
Instead, the `start()` and `stop()` functions will handle this.

                Request.call this

                Object.defineProperties this,
                    start:
                        enumerable: no
                        value: startRequest.bind recalled
                    stop:
                        enumerable: no
                        value: stopRequest.bind recalled

                Object.freeze this

Our `Authorization.Request.prototype` just inherits from `Request`.

            Object.defineProperty AuthorizationRequest, "prototype",
                configurable: no
                enumerable: no
                writable: no
                value: Object.freeze Object.create Request.prototype,
                    constructor:
                        enumerable: no
                        value: AuthorizationRequest

            return AuthorizationRequest

###  Creating the events:

Here we create the events as per our specifications.

>   __[Issue #50](https://github.com/marrus-sh/laboratory/issues/50) :__
>   Authorization events may not fire in the future.

        LaboratoryEvent

            .create "LaboratoryAuthorizationReceived", Authorization

###  Handling the events:

Laboratory provides handlers for the following Authorization events:

- `LaboratoryAuthorizationReceived`

####  `LaboratoryAuthorizationReceived`.

The `LaboratoryAuthorizationReceived` handler just saves the provided `Authorization` to the `Store`.
It also exposes it to the window through `Exposed`.

>   __[Issue #36](https://github.com/marrus-sh/laboratory/issues/36) :__
>   Right now Laboratory is only set up to allow one active signin at a given time.
>   This may change in the future.

            .handle "LaboratoryAuthorizationReceived", (event) ->
                if event.detail instanceof Authorization
                    do reset
                    Exposed.auth = Store.auth = event.detail
