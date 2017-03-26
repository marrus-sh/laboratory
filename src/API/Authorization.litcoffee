#  AUTHORIZATION EVENTS  #

##  Introduction  ##

The __Authorization__ module of Laboratory Events is comprised of those events which are related to OAuth registration of the Laboratory client with the Mastodon server.

###  Quick reference:

| Event | Description |
| :-------------- | :---------- |
| `LaboratoryAuthorizationRequested` | Fires when a new access token should be requested from the OAuth server |
| `LaboratoryAuthorizationReceived` | Fires when an access token has been received from the OAuth server |
| `LaboratoryAuthorizationFailed` | Fires when a request for an access token failed |
| `LaboratoryAuthorizationGranted` | Fires when a popup receives an authorization code |

##  Requesting Authorization  ##

>   - __API equivalent :__ `/oauth/token`, `/api/v1/verify_credentials`
>   - __Request parameters :__
>       - __`name` :__ The name of the client application (default: `"Laboratory"`)
>       - __`url` :__ The location of the Mastodon server (default: `"/"`)
>       - __`redirect` :__ The base url for the application (default: `""`)
>       - __`scope` :__ An `Authorization.Scope` (default: `Authorization.Scope.READ`)
>   - __Request :__ `LaboratoryAuthorizationRequested`
>   - __Response :__ `LaboratoryAuthorizationReceived`
>   - __Failure :__ `LaboratoryAuthorizationFailed`
>   - __Miscellanous events :__
>       - `LaboratoryAuthorizationGranted`

The `LaboratoryAuthorizationRequested` event requests an access token for use with OAuth.
This will likely be the first request you make when interacting with Laboratory.
You probably don't need to keep track of its response, since this data will be made available through the `Laboratory` object.

The `LaboratoryAuthorizationGranted` event fires when a user has granted authorization through the OAuth popup.
Its `detail` will contain either a `code` or an `accessToken`, alongside an optional `window`, `origin` and `scope`.
If you have somehow acquired an access token from somewhere else, passing this value to `LaboratoryAuthorizationGranted` alongside its origin and scope will allow Laboratory to use it as well.
Alternatively, you can pass an `Authorization` object to `LaboratoryAuthorizationReceived`, but note that doing so requires more information.

##  Implementation  ##

###  Recalling the origin:

Only one authorization attempt can be made at a time, since it is made in a named window.
We recall the origin of this attempt using the local `recalledOrigin` variable.

    do ->
        recalledOrigin = null

###  Creating the events:

Here we create the events as per our specifications.

        LaboratoryEvent

            .create "LaboratoryAuthorizationRequested",
                name: "Laboratory"
                url: "/"
                redirect: ""
                scope: Authorization.Scope.READ
            .create "LaboratoryAuthorizationReceived", Authorization
            .create "LaboratoryAuthorizationFailed", Failure
            .associate "LaboratoryAuthorizationRequested", "LaboratoryAuthorizationReceived", "LaboratoryAuthorizationFailed"

            .create "LaboratoryAuthorizationGranted",
                code: undefined
                accessToken: undefined
                origin: undefined
                scope: Authorization.Scope.NONE
                window: undefined

###  Handling the events:

Laboratory provides handlers for the following Authorization events:

- `LaboratoryAuthorizationRequested`
- `LaboratoryAuthorizationGranted`
- `LaboratoryAuthorizationReceived`

####  `LaboratoryAuthorizationRequested`.

The `LaboratoryAuthorizationRequested` handler starts a request for a new access token from the API.
The code for this handler is very complex, largely because it takes place across multiple asynchronous requests and two separate windows.
`LaboratoryAuthorizationRequested` only handles the first half of the request; see `LaboratoryAuthorizationGranted` for the second half.

            .handle "LaboratoryAuthorizationRequested", (event) ->

If we weren't provided with a scope, we'll set it to the default.

                scope = Authorization.Scope.READ unless (scope = event.detail.scope) instanceof Authorization.Scope

First, we normalize our URL.
We also get our redirect URI at this point.

                a = document.createElement "a"
                a.href = event.detail.url
                origin = a.origin
                a.href = event.detail.redirect or ""
                redirect = a.href

The `makeRequest()` function will request our token once we acquire a client id and secret.
Of course, it is possible that we already have these.

                makeRequest = ->

The actual token requesting takes place after authorization has been granted by the popup window (see the script at the beginning of [README](../README.litcoffee)); but we open it up here.

>   __Note :__
>   This window **will be blocked** by popup blockers unless it has already been opened previously in response to a click or keyboard event.

                    window.open origin + "/oauth/authorize?" + (
                        (
                            (encodeURIComponent key) + "=" + (encodeURIComponent value) for key, value of {
                                client_id: clientID
                                response_type: "code"
                                redirect_uri: redirect
                                scope: do ->
                                    scopeList = []
                                    scopeList.push "read" if scope & Authorization.Scope.READ
                                    scopeList.push "write" if scope & Authorization.Scope.WRITE
                                    scopeList.push "follow" if scope & Authorization.Scope.FOLLOW
                                    return scopeList.join " "
                            }
                        ).join "&"
                    ), "LaboratoryOAuth"
                    recalledOrigin = origin
                    return

We can only make our request once we have been registered as a client.
Laboratory stores its client and authorization data in `localStorage`.
Here we try to access that data if present:

                [storedRedirect, clientID, clientSecret, storedScope, accessToken] = (localStorage.getItem "Laboratory | " + origin).split " ", 5 if localStorage?.getItem "Laboratory | " + origin

If we have an access token which supports our requested `scope` then we can immediately try using it.
We'll just forward it to `LaboratoryAuthorizationGranted`.

                dispatch "LaboratoryAuthorizationGranted", {
                    accessToken: accessToken
                    origin: origin
                    scope: scope
                } if accessToken and (scope & storedScope) is +scope

If we have client credentials and they are properly associated with our `redirect` and `scope`, we can go ahead and `makeRequest()`.

                if storedRedirect is redirect and (scope & storedScope) is +scope and clientID? and clientSecret? then do makeRequest

Otherwise, we need to get new client credentials before proceeding.

                else

                    handleClient = (e) ->
                        return unless (client = e.detail) instanceof Client and client.origin is origin and (scope & client.scope) is +scope and client.redirect is redirect and client.clientID? and client.clientSecret?
                        {clientID, clientSecret, scope} = client
                        localStorage.setItem "Laboratory | " + origin, [redirect, clientID, clientSecret, +scope].join " "
                        forget "LaboratoryClientReceived", handleClient
                        clearTimeout timeout
                        do makeRequest
                        return

                    listen "LaboratoryClientReceived", handleClient

                    dispatch "LaboratoryClientRequested",
                        name: event.detail.name
                        url: origin
                        redirect: redirect
                        scope: Authorization.Scope.fromValue scope

If we aren't able to acquire a client ID within 30 seconds, we timeout.

                    timeout = setTimeout (
                        ->
                            forget "LaboratoryClientReceived", handleClient
                            dispatch "LaboratoryAuthorizationFailed", new Failure "Unable to authorize client", "LaboratoryAuthorizationRequested"
                            return
                    ), 30000

                return

####  `LaboratoryAuthorizationGranted`.

The `LaboratoryAuthorizationGranted` handler does the *actual* requesting of an access token, using the authorization code in its `detail`.
It then attempts to verify the access token through a simple request to `/api/v1/accounts/verify_credentials`.
If this succeeds, then it will respond with the `Authorization`.

            .handle "LaboratoryAuthorizationGranted", (event) ->

                if event.detail.window then do event.detail.window.close

Our authorization must have an associated `origin`.
If it doesn't, we can't proceed.

                unless origin = event.detail.origin or recalledOrigin
                    dispatch "LaboratoryAuthorizationFailed", new Failure "Authorization data wasn't associated with an origin", "LaboratoryAuthorizationRequested"
                    return

We also initialize our `scope`, `datetime`, and `tokenType` variables now.
We'll only use these initial values if an `accessToken` was directly provided, otherwise we'll overwrite them using the server's response.

                scope = if event.detail.scope instanceof Authorization.Scope then (
                    do ->
                        scopeList = []
                        scopeList.push "read" if scope & Authorization.Scope.READ
                        scopeList.push "write" if scope & Authorization.Scope.WRITE
                        scopeList.push "follow" if scope & Authorization.Scope.FOLLOW
                        return scopeList.join " "
                ) else ""
                datetime = NaN
                tokenType = "bearer"

We use our `origin` to get our redirect, client id, and secret.
We only need these if we were provided with a `code`.

                [redirect, clientID, clientSecret] = (localStorage.getItem "Laboratory | " + origin).split " ", 5 if localStorage?.getItem "Laboratory | " + origin

The function `verify()` will attempt to verify our access token.
The response should be an account object.

                verify = ->

                    verifyComplete = (response, data, params) ->
                        dispatch "LaboratoryAuthorizationReceived", new Authorization {
                            access_token: String accessToken
                            created_at: String +datetime
                            scope: scope
                            token_type: tokenType
                        }, origin, response.id
                        localStorage.setItem "Laboratory | " + origin, [redirect, clientID, clientSecret, Authorization.Scope.READ * (((scopes = scope.split /[\s\+]+/g).indexOf "read") isnt -1) + Authorization.Scope.WRITE * ((scopes.indexOf "write") isnt -1) + Authorization.Scope.FOLLOW * ((scopes.indexOf "follow") isnt -1), accessToken].join " "
                        dispatch "LaboratoryProfileReceived", new Profile response
                        return

                    verifyError = (response, data, params) ->
                        dispatch "LaboratoryAuthorizationFailed", new Failure response.error, "LaboratoryAuthorizationRequested", params.status
                        return

                    serverRequest "GET", origin + "/api/v1/accounts/verify_credentials", null, accessToken, verifyComplete, verifyError

If we were given an access token then we can go ahead and verify now.

                if accessToken = event.detail.accessToken then do verify

Otherwise we first have to acquire one.

                else if code = event.detail.code
                    onComplete = (response, data, params) ->
                        accessToken = response.access_token
                        datetime = new Date response.created_at
                        scope = response.scope
                        tokenType = response.token_type
                        do verify
                        return
                    onError = (response, data, params) ->
                        dispatch "LaboratoryAuthorizationFailed", new Failure response.error, "LaboratoryAuthorizationRequested", params.status
                        return
                    serverRequest "POST", origin + "/oauth/token", {
                        client_id: clientID
                        client_secret: clientSecret
                        redirect_uri: redirect
                        grant_type: "authorization_code"
                        code: code
                    }, null, onComplete, onError

If we weren't given an `accessToken` *or* a `code`, that's an error.

                else dispatch "LaboratoryAuthorizationFailed", new Failure "No authorization code or access token was granted", "LaboratoryAuthorizationRequested"

We can now reset our recalled origin.

                recalledOrigin = null
                return

####  `LaboratoryAuthorizationReceived`.

The `LaboratoryAuthorizationReceived` handler just saves the provided `Authorization` to the `Store`.
It also exposes it to the window through `Exposed`.

            .handle "LaboratoryAuthorizationReceived", (event) ->
                return unless event.detail instanceof Authorization
                Exposed.auth = Store.auth = event.detail
                return
