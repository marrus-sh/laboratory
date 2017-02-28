#  `Laboratory.Handlers.Authentication`  #

##  Coverage  ##

**The following events from `Authentication` have handlers:**

- `Authentication.ClientRequested`
- `Authentication.ClientReceived`
- `Authentication.Requested`
- `Authentication.Granted`
- `Authentication.Received`
- `Authentication.Verified`

##  Object Initialization  ##

    Laboratory.Handlers.Authentication = {}

##  Handlers  ##

###  `Authentication.ClientRequested`:

The `Authentication.ClientRequested` handler requests a new client id and secret from the API, and fires `Authentication.ClientReceived` when it is granted.

    Laboratory.Handlers.Authentication.ClientRequested = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Authentication.ClientRequested.type

First, we normalize our URL.
We also get our redirect URI at this point.

        a = document.createElement("a")
        a.href = event.detail.url
        url = a.origin
        a.href = @config.baseName + "/"
        authURL = a.href

Now we can send our request.

        Laboratory.Functions.sendToAPI(
            "client_name=Laboratory+Frontend&redirect_uris=" + encodeURIComponent(authURL) + "&scopes=read+write+follow"
            url + "/api/v1/apps"
            null
            Laboratory.Events.Authentication.ClientReceived
            {url, authURL}
        )

        return

    Laboratory.Handlers.Authentication.ClientRequested.type = Laboratory.Events.Authentication.ClientRequested.type
    Object.freeze Laboratory.Handlers.Authentication.ClientRequested

###  `Authentication.ClientReceived`:

The `Authentication.ClientReceived` handler stores a received client id and secret from the API in `localStorage`.
It then calls `Authentication.Requested` to attempt to authenticate the user.

    Laboratory.Handlers.Authentication.ClientReceived = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Authentication.ClientReceived.type

        localStorage.setItem event.detail.params.url, event.detail.params.authURL + " " + event.detail.data.client_id + " " + event.detail.data.client_secret

        Laboratory.Events.Authentication.Requested
            url: event.detail.params.url
            clientID: event.detail.data.client_id
            clientSecret: event.detail.data.client_secret

        return

    Laboratory.Handlers.Authentication.ClientReceived.type = Laboratory.Events.Authentication.ClientReceived.type
    Object.freeze Laboratory.Handlers.Authentication.ClientReceived

###  `Authentication.Requested`:

The `Authentication.Requested` handler requests authorization from the user through the API, and fires `Authentication.Granted` when it is granted.

    Laboratory.Handlers.Authentication.Requested = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Authentication.Requested.type

First, we normalize our URL.
We also get our redirect URI at this point.

        a = document.createElement "a"
        a.href = event.detail.url
        url = a.origin
        a.href = @config.baseName + "/"
        authURL = a.href


If we don't have a client ID or secret we need to get one.

        if event.detail.clientID? and event.detail.clientSecret? then [redirect, clientID, clientSecret] = [authURL, event.detail.clientID, event.detail.clientSecret]
        else if localStorage.getItem(url) then [redirect, clientID, clientSecret] = localStorage.getItem(url).split " ", 3

        unless redirect is authURL and clientID? and clientSecret?
            Laboratory.Events.Authentication.ClientRequested {url}
            return

Otherwise, we can load our authentication data into our state for later use.

        @auth.origin = url
        @auth.api = @auth.origin + "/api/v1"
        @auth.clientID = clientID
        @auth.clientSecret = clientSecret
        @auth.redirect = authURL

We now open a popup for authorization.
It will call `Authentication.Granted` with the granted code if it succeeds.

        window.open url + "/oauth/authorize?client_id=" + clientID + "&response_type=code&redirect_uri=" + encodeURIComponent(authURL), "LaboratoryOAuth"

        return

    Laboratory.Handlers.Authentication.Requested.type = Laboratory.Events.Authentication.Requested.type
    Object.freeze Laboratory.Handlers.Authentication.Requested

###  `Authentication.Granted`:

The `Authentication.Granted` handler is called when the user grants access to the Laboratory app from a popup.

    Laboratory.Handlers.Authentication.Granted = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Authentication.Granted.type

If our authentication data hasn't been loaded into the state, then this event must have been called erroneously.

        return unless @auth.origin? and @auth.clientID and @auth.clientSecret and @auth.redirect

We can now close our popup.

        event.detail.window.close() if event.detail.window?

Finally, we can request our authorization token from the server using the code we were just given.

        Laboratory.Functions.sendToAPI(
            "client_id=" + @auth.clientID + "&client_secret=" + @auth.clientSecret + "&redirect_uri=" + encodeURIComponent(@auth.redirect) + "&grant_type=authorization_code&code=" + event.detail.code
            @auth.origin + "/oauth/token"
            null
            Laboratory.Events.Authentication.Received
        )

        return

    Laboratory.Handlers.Authentication.Granted.type = Laboratory.Events.Authentication.Granted.type
    Object.freeze Laboratory.Handlers.Authentication.Granted

###  `Authentication.Received`:

The `Authentication.Received` handler is called when the user grants access to the Laboratory app from a popup.

    Laboratory.Handlers.Authentication.Received = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Authentication.Received.type

If our authentication failed, then we *sigh* have to start all over again from scratch.

        unless event.detail.data.access_token
            localStorage.setItem @auth.origin, ""
            Laboratory.Events.Authentication.Requested
                url: @auth.origin
                clientID: @auth.clientID
                clientSecret: @auth.clientSecret
            return

We can now load our tokens:

        @auth.accessToken = event.detail.data.access_token
        localStorage.setItem @auth.origin, @auth.redirect + " " + @auth.clientID + " " + @auth.clientSecret

*Finally*, we try to grab the account of the newly-signed-in user, using `Authentication.Verified` as our callback.

        Laboratory.Functions.requestFromAPI(
            @auth.api + "/accounts/verify_credentials"
            @auth.accessToken
            Laboratory.Events.Authentication.Verified
        )

        return

    Laboratory.Handlers.Authentication.Received.type = Laboratory.Events.Authentication.Received.type
    Object.freeze Laboratory.Handlers.Authentication.Received

###  `Authentication.Verified`:

The `Authentication.Verified` handler is called when the credentials of a user have been verified.
Its `data` contains the account information for the just-signed-in user.
Once this data has been received, we can fire up our UI.

    Laboratory.Handlers.Authentication.Verified = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Authentication.Verified.type

        @auth.me = event.detail.data.id

        Laboratory.Events.Account.Received {data: event.detail.data}

Now that our account has been received, we can render our React components.
We don't give our React components direct access to our store so there's quite a few properties we need to set instead.

        frontend = 彁 Laboratory.Components.Shared.productions.Laboratory,
            locale: @config.locale
            myID: @auth.me
            useBrowserHistory: @config.useBrowserHistory
            title: @site.title || @auth.origin
            links: @site.links
            routerBase: @config.baseName
            maxChars: @site.maxChars
            defaultPrivacy: "unlisted"

        ReactDOM.unmountComponentAtNode @config.root
        ReactDOM.render frontend, @config.root

        return

    Laboratory.Handlers.Authentication.Verified.type = Laboratory.Events.Authentication.Verified.type
    Object.freeze Laboratory.Handlers.Authentication.Verified

##  Object Freezing  ##

    Object.freeze Laboratory.Handlers.Authentication
