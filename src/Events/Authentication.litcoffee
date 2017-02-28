#  `Laboratory.Events.Authentication`  #

##  Usage  ##

>   ```javascript
>       //  Fires when client authentication is first requested:
>       Authentication.ClientRequested({url: …})
>       //  Fires when client authentication is received:
>       Authentication.ClientReceived({data: …, params: …})
>       //  Fires when authentication is first requested:
>       Authentication.Requested({url: …, window: …, clientID: …, clientSecret: …})
>       //  Fires when a user grants an authorization request:
>       Authentication.Granted({window: …, code: …})
>       //  Fires when an authentication request goes through:
>       Authentication.Received({data: …})
>       //  Fires when an authentication request goes through:
>       Authentication.Verified({data: …})
>   ```
>   - **`url` :** The url of the server to authenticate with.
>   - **`clientID` :** The url of the server to authenticate with.
>   - **`clientSecret` :** The url of the server to authenticate with.
>   - **`window` :** The window which was granted the authentication.
>   - **`code` :** An authorization code.
>   - **`data` :** The data from the request.
>   - **`params` :** Params passed along with the request.

##  Object Initialization  ##

    Laboratory.Events.Authentication = {}

##  Events  ##

###  `Authentication.ClientRequested`:

The `Authentication.ClientRequested` event has one property: the `url` of the server to authenticate with.

    Laboratory.Events.Authentication.ClientRequested = Laboratory.Events.newBuilder 'LaboratoryAuthenticationClientRequested',
        url: "/"

###  `Authentication.ClientReceived`:

The `Authentication.ClientReceived` event has two properties: the `data` returned by the server, and the `params` which were passed with the request.

    Laboratory.Events.Authentication.ClientReceived = Laboratory.Events.newBuilder 'LaboratoryAuthenticationClientReceived',
        data: null
        params: null

###  `Authentication.Requested`:

The `Authentication.Requested` event has one property: the `url` of the server to authenticate with.

    Laboratory.Events.Authentication.Requested = Laboratory.Events.newBuilder 'LaboratoryAuthenticationRequested',
        url: "/"
        window: null
        clientID: null
        clientSecret: null

###  `Authentication.Granted`:

The `Authentication.Granted` event has three properties: the `data` returned by the server, the `code` to use for authentication, and the `method` for getting our access token.

    Laboratory.Events.Authentication.Granted = Laboratory.Events.newBuilder 'LaboratoryAuthenticationGranted',
        window: null
        code: null

###  `Authentication.Received`:

The `Authentication.Received` event has two properties: the `data` returned by the server, and the `params` which were passed with the request.

    Laboratory.Events.Authentication.Received = Laboratory.Events.newBuilder 'LaboratoryAuthenticationReceived',
        data: null

###  `Authentication.Verified`:

The `Authentication.Verified` event has one property: the `data` of the server's response.

    Laboratory.Events.Authentication.Verified = Laboratory.Events.newBuilder 'LaboratoryAuthenticationVerified',
        data: null

##  Object Freezing  ##

    Object.freeze Laboratory.Events.Authentication
