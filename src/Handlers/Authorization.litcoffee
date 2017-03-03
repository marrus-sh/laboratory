#  AUTHORIZATION HANDLERS  #

    Handlers.Authorization = Object.freeze

##  `LaboratoryAuthorizationClientRequested`  ##

The `LaboratoryAuthorizationClientRequested` handler requests a new client id and secret from the API, and fires `LaboratoryAuthorizationClientReceived` when it is granted.

        ClientRequested: handle Events.Authorization.ClientRequested,  (event) ->

First, we normalize our URL.
We also get our redirect URI at this point.

            a = document.createElement("a")
            a.href = event.detail.url
            url = a.origin
            a.href = event.detail.redirect || ""
            authURL = a.href

Now we can send our request.

            serverRequest "POST", url + "/api/v1/apps", "client_name=" + encodeURIComponent(String(event.detail.name).replace " ", "+") + "&redirect_uris=" + encodeURIComponent(authURL) + "&scopes=read+write+follow", null, Events.Authorization.ClientReceived, {url, redirect: authURL}

            return

##  `LaboratoryAuthorizationClientReceived`  ##

The `LaboratoryAuthorizationClientReceived` handler stores a received client id and secret from the API in `localStorage`.
It then fires `LaboratoryAuthorizationRequested` to attempt to authenticate the user.

        ClientReceived: handle Events.Authorization.ClientReceived, (event) ->

            localStorage.setItem "Laboratory | " + event.detail.params.url, event.detail.params.redirect + " " + event.detail.data.client_id + " " + event.detail.data.client_secret

            Events.Authorization.Requested
                url: event.detail.params.url
                redirect: event.detail.params.redirect

            return

###  `LaboratoryAuthorizationRequested`:

The `LaboratoryAuthorizationRequested` handler requests authorization from the user through the API.

        Requested: handle Events.Authorization.Requested,  (event) ->

First, we normalize our URL.
We also get our redirect URI at this point.

            a = document.createElement "a"
            a.href = event.detail.url
            url = a.origin
            a.href = event.detail.redirect || ""
            authURL = a.href


If we don't have a client id or secret we need to get one.

            if localStorage.getItem("Laboratory | " + url) then [redirect, clientID, clientSecret] = localStorage.getItem(url).split " ", 3

            unless (redirect and not event.detail.redirect? or redirect is authURL) and clientID? and clientSecret?
                Events.Authorization.ClientRequested {url, name: event.detail.name}
                return

Otherwise, we can load our authorization data into our state for later use.

            @auth.origin = url
            @auth.api = @auth.origin + "/api/v1"
            @auth.clientID = clientID
            @auth.clientSecret = clientSecret
            @auth.redirect = authURL

We now open a popup for authorization.
It will fire `LaboratoryAuthorizationGranted` with the granted code if it succeeds.

            window.open url + "/oauth/authorize?client_id=" + clientID + "&response_type=code&redirect_uri=" + encodeURIComponent(authURL), "LaboratoryOAuth"

            return

###  `LaboratoryAuthorizationGranted`:

The `LaboratoryAuthorizationGranted` handler is called when the user grants access to the Laboratory app from a popup.

        Granted: handle Events.Authorization.Granted, (event) ->

If our authentication data hasn't been loaded into the state, then this event must have been called erroneously.

            return unless @auth.origin? and @auth.clientID? and @auth.clientSecret? and @auth.redirect?

We can now close our popup.

            event.detail.window.close() if event.detail.window?

Finally, we can request our authorization token from the server using the code we were just given.

            serverRequest "POST", @auth.origin + "/oauth/token", "client_id=" + @auth.clientID + "&client_secret=" + @auth.clientSecret + "&redirect_uri=" + encodeURIComponent(@auth.redirect) + "&grant_type=authorization_code&code=" + event.detail.code, null, Events.Authorization.Received

            return

###  `LaboratoryAuthorizationReceived`:

The `LaboratoryAuthorizationReceived` handler is called when the user grants access to the Laboratory app from a popup.

        Received: handle Events.Authorization.Received, (event) ->

If our authorization failed, then we *sigh* have to start all over again from scratch.

            unless event.detail.data?.access_token
                localStorage.setItem "Laboratory | " + @auth.origin, ""
                Events.Authorization.Requested
                    url: @auth.origin
                    clientID: @auth.clientID
                    clientSecret: @auth.clientSecret
                return

We can now load our tokens:

            @auth.accessToken = event.detail.data.access_token
            localStorage.setItem "Laboratory | " + @auth.origin, @auth.redirect + " " + @auth.clientID + " " + @auth.clientSecret

*Finally*, we try to grab the account of the newly-signed-in user, using `Authorization.Verified` as our callback.

            serverRequest "GET", @auth.api + "/accounts/verify_credentials", null, @auth.accessToken, Events.Authorization.Verified

            return

###  `LaboratoryAuthorizationVerified`:

The `LaboratoryAuthorizationVerified` handler is called when the credentials of a user have been verified.
Its `data` contains the account information for the just-signed-in user.
We keep track of its id, but pass the rest on to `LaboratoryAccountReceived`.

        Verified: handle Events.Authorization.Verified, (event) ->
            @auth.me = Number event.detail.data.id
            Events.Account.Received {data: event.detail.data}
            return

##  `LaboratoryAuthorizationFavourites`  ##

When a `LaboratoryAuthorizationFavourites` event is fired, we simply petition the server for a list of favourites for the current user.
We wrap the callback in a function which formats the list for us.

        Favourites: handle Events.Authorization.Favourites (event) ->

            return unless typeof (callback = event.detail.callback) is "function"

            query = ""
            query += "?max_id=" + Number event.detail.before if isFinite event.detail.before
            query += (if query then "&" else "?") + "since_id=" + Number event.detail.after if isFinite event.detail.after

            serverRequest "GET", @auth.api + "/favourites" + query, null, @auth.accessToken, (response) -> callback(Constructors.Post(data) for data in response.data)

##  `LaboratoryAuthorizationBlocks`  ##

When a `LaboratoryAuthorizationBlocks` event is fired, we simply petition the server for a list of people following the user and pass this to our callback.
We wrap the callback in a function which formats the list for us.

        Blocks: handle Events.Authorization.Blocks (event) ->

            return unless typeof (callback = event.detail.callback) is "function"

            query = ""
            query += "?max_id=" + Number event.detail.before if isFinite event.detail.before
            query += (if query then "&" else "?") + "since_id=" + Number event.detail.after if isFinite event.detail.after

            serverRequest "GET", @auth.api + "/blocks" + query, null, @auth.accessToken, (response) -> callback(Constructors.Profile(data) for data in response.data)
