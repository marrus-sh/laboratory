#  LABORATORY EVENT HANDLERS  #

The __Laboratory Event Handlers__ provide the backend for the [__Laboratory Event API__](../Events/).
These files contain the actual server calls, information processing, and data handling of the Laboratory engine.

For the most part, you probably don't need to know what actually goes on in here to use Laboratory, because you will never have direct access to the Laboratory handlers or the store.
However, if you want to know what Laboratory is doing behind-the-scenes, this file is your answer.

##  Implementation  ##

Here we set up our internal `Handlers` object.
This object will *not* be made available to our external `window.Laboratory` object.

    Handlers = {}

###  `handle()`:

The `handle()` function just associates a `type` with a `callback`.
It sets things up so we can easily add our handlers to the document later.
We also do a few checks before running the callback to make sure it actually is receiving an appropriate event response.

    handle = (builder, callback) ->
        console.log callback if not builder
        typedCallback = (event) ->
            return unless event? and this? and event.type is builder.type
            callback.call this, event
        typedCallback.type = builder.type
        return Object.freeze typedCallback

###  `serverRequest()`:

The `serverRequest()` function conveniently performs an `XMLHttpRequest` and binds it to a callback with the response `data` and additional `params`.
We will use it in our handlers to actually send our requests to the API.

    serverRequest = (method, location, contents, accessToken, onComplete, params) ->

####  Creating the request.

This is fairly simple; we just create an XMLHttpRequest.
You can see we set the `Authorization` header using our access token, if one was provided.

        return unless method is "GET" or method is "POST" or method is "DELETE"
        request = new XMLHttpRequest()
        request.open method, location
        if method is "POST" and not (contents instanceof FormData) then request.setRequestHeader "Content-type", "application/x-www-form-urlencoded"
        else if method isnt "POST" then contents = undefined
        request.setRequestHeader "Authorization", "Bearer " + accessToken if accessToken

####  The callback.

This is the function that is called once the request finishes loading.
We define it inside our `requestFromAPI()` function so that it has access to our `request` and `onComplete` variables.
We also pass through any provided `params`.

        callback = ->
            prevMatches = request.getResponseHeader("Link")?.match /<\s*([^,]*)\s*>\s*;[^,]*[;\s]rel="?prev(?:ious)?"?/
            nextMatches = request.getResponseHeader("Link")?.match /<\s*([^,]*)\s*>\s*;[^,]*[;\s]rel="?next"?/
            return unless request.readyState is XMLHttpRequest.DONE and 200 <= request.status <= 205
            onComplete
                params: params
                data: if request.status <= 202 then JSON.parse request.responseText else null
                prev: if prevMatches? then prevMatches[1] else null
                next: if nextMatches? then nextMatches[1] else null
            request.removeEventListener "readystatechange", callback, false

####  Sending the request.

We can now add our event listener and send the request.

        request.addEventListener "readystatechange", callback, false
        request.send contents

        return
