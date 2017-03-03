#  AUTHORIZATION EVENTS  #

    Events.Authorization = Object.freeze

The __Authorization__ module of Laboratory Events is comprised of those events which are related to OAuth authorization and authentication between the user, Laboratory, and the Mastodon server.
The only Authorization event you should fire yourself is `LaboratoryAuthorizationRequested`; the remainder are used by Laboratory to document various stages in the authentication process.

| Event / Builder | Description |
| :-------------- | :---------- |
| `LaboratoryAuthorizationClientRequested` / `Laboratory.Authorization.ClientRequested` | Fires when a client id and secret should be requested from the OAuth server |
| `LaboratoryAuthorizationClientReceived` / `Laboratory.Authorization.ClientReceived` | Fires when a client id and secret have been received from the OAuth server |
| `LaboratoryAuthorizationRequested` / `Laboratory.Authorization.Requested` | Fires when an access token should be requested from the OAuth server |
| `LaboratoryAuthorizationGranted` / `Laboratory.Authorization.Granted` | Fires when a user has granted authorization for Laboratory to receive an access token from the OAuth server |
| `LaboratoryAuthorizationReceived` / `Laboratory.Authorization.Received` | Fires when an access token has been received from the OAuth server |
| `LaboratoryAuthorizationVerified` / `Laboratory.Authorization.Verified` | Fires when an access token has been verified and the account data for the user has been received |
| `LaboratoryAuthorizationFavourites` / `Laboratory.Authorization.Favourites` | Requests the list of favourited statuses for the currently authenticated user |
| `LaboratoryAuthorizationBlocks` / `Laboratory.Authorization.Blocks` | Requests the list of favourited statuses for the currently authenticated user |

##  `LaboratoryAuthorizationClientRequested`  ##

>   - __Builder :__ `Laboratory.Authorization.ClientRequested`
>   - __Properties :__
>       - `url` – Provides the URL of the Mastodon server (only the origin is used).
>       - `redirect` – Provides the base URL for your application. This URL must be in the same domain as the current page and must have the Laboratory script loaded. Furthermore, if your application has multiple pages, it should be the same for each.
>       - `name` – Provides the name to use when registering the Mastodon client.

        ClientRequested: new Constructors.LaboratoryEvent 'LaboratoryAuthorizationClientRequested',
            url: "/"
            redirect: ""
            name: "Laboratory Web Client"

The `LaboratoryAuthorizationClientRequested` event fires when the Laboratory script is requesting a new client id for use with OAuth.
Laboratory will fire this event automatically if it needs to during the handling of `LaboratoryAuthorizationRequested`, so it isn't usually something you need to worry about.

##  `LaboratoryAuthorizationClientReceived`  ##

>   - __Builder :__ `Laboratory.Authorization.ClientReceived`
>   - __Properties :__
>       - `data` – Provides the response from the server.
>       - `params` – Provides parameters remembered from the initial request.

        ClientReceived: new Constructors.LaboratoryEvent 'LaboratoryAuthorizationClientReceived',
            data: null
            params: null

The `LaboratoryAuthorizationClientReceived` event fires when the Mastodon server has responded to its request for a client id.
Hopefully, the `data` of this request will contain a client id and secret for Laboratory to use.
These aren't anything you should need to use yourself—especially since Laboratory will be acquiring a much-more-useful access token for you here shortly.

##  `LaboratoryAuthorizationRequested`  ##

>   - __Builder :__ `Laboratory.Authorization.Requested`
>   - __Properties :__
>       - `url` – Provides the URL of the Mastodon server (only the origin is used).
>       - `redirect` – Provides the base URL for your application. This URL must be in the same domain as the current page and must load the Laboratory script. Furthermore, if your application has multiple pages, this URL should be the same for each.
>       - `name` – Provides the name to use when registering the Mastodon client.

        Requested: new Constructors.LaboratoryEvent 'LaboratoryAuthorizationRequested',
            url: "/"
            redirect: ""
            name: "Laboratory Web Client"

The `LaboratoryAuthorizationRequested` event asks Laboratory to seek authorization from a Mastodon server, provided with `url`.
If it is fired with a `name`, then that name will be used when registering the Laboratory client.
(If no client registration is needed, the `name` will be discarded.)

The OAuth authorization window opened by `LaboratoryAuthorizationRequested` will be treated as a popup by most browsers unless you've opened it ahead of time as the result of a click or a keypress.
The name of this window should be `LaboratoryOAuth`.
One good workflow is to open this window preemptively when a user clicks to submit the name of their instance.
If you know the name of the instance ahead of time, using a "connect" button might work just as well.

`LaboratoryAuthorizationClientReceived` automatically fires this event during its handler, so you don't need to dispatch it twice if client registration happens to be needed.

##  `LaboratoryAuthorizationGranted`  ##

>   - __Builder :__ `Laboratory.Authorization.Granted`
>   - __Properties :__
>       - `window` – A reference to the `window` popup which authorized the application
>       - `code` – The authorization code which will be used to retreive an access token.

        Granted: new Constructors.LaboratoryEvent 'LaboratoryAuthorizationGranted',
            window: null
            code: null

The `LaboratoryAuthorizationGranted` event is called from a Laboratory popup window once the user has signed in and authorized the application.
The handler for this event closes the popup and requests an access token from the Mastodon API.

##  `LaboratoryAuthorizationReceived`  ##

>   - __Builder :__ `Laboratory.Authorization.Received`
>   - __Properties :__
>       - `data` – The response from the server.

        Received: new Constructors.LaboratoryEvent 'LaboratoryAuthorizationReceived',
            data: null

The `LaboratoryAuthorizationReceived` event fires once the server has responded to a request for an access token.
The token is—hopefully—contained inside `data`; otherwise Laboratory will start the whole process over again from the beginning.
It is unlikely that you would ever need access to Laboratory's access token, since the whole point of Laboratory is to make it handle the API stuff for you.
However, if you do, **now is the time to secure it**, since after this event is fired it will disappear into the unknowable depths of the Laboratory store.
You can access it at `event.detail.data.access_token`—note the underscore, because this is an API response.

##  `LaboratoryAuthorizationVerified`  ##

>   - __Builder :__ `Laboratory.Authorization.Verified`
>   - __Properties :__
>       - `data` – The response from the server.

        Verified: new Constructors.LaboratoryEvent 'LaboratoryAuthorizationVerified',
            data: null

The `LaboratoryAuthorizationVerified` event fires when the first request non–OAuth-related API request goes through.
This is always a request to `/api/v1/accounts/verify_credentials`, and the response will always be the account data for the newly–signed-in user.
If you need to know the current user's id, listing for this event is your best hope of getting it.
A `LaboratoryAccountReceived` event with containing the account's `data` will be fired by this event's handler.

##  `LaboratoryAuthorizationFavourites`  ##

>   - __Builder :__ `Laboratory.Authorization.Favourites`
>   - __Properties :__
>       - `callback` – A function to call with the response.
>       - `before` – The status id at which to end the request.
>       - `after` – The status id at which to start the request.

        Favourites: new Constructors.LaboratoryEvent 'LaboratoryAuthorizationFavourites',
            callback: null
            before: null
            after: null

The `LaboratoryAuthorizationFavouritesRequested` event asks for the current user's favourites from the server.
The `callback` will not be remembered for future instances of this request.

##  `LaboratoryAuthorizationBlocks`  ##

>   - __Builder :__ `Laboratory.Authorization.Blocks`
>   - __Properties :__
>       - `callback` – A function to call with the response.
>       - `before` – The account id at which to end the request.
>       - `after` – The account id at which to start the request.

        Blocks: new Constructors.LaboratoryEvent 'LaboratoryAuthorizationBlocks',
            callback: null
            before: null
            after: null

The `LaboratoryAuthorizationBlocksRequested` event asks for the current user's blocks from the server.
The `callback` will not be remembered for future instances of this request.
