#  `Laboratory.Functions.requestFromAPI`

This module is used to request information from the Mastodon API.
It sends a request to `location` using the provided `accessToken`, and when it finishes it calls the function provided by `onComplete` with an object containing the request's response as its `data`.

    Laboratory.Functions.requestFromAPI = (location, accessToken, onComplete, params) ->

##  Creating the Request  ##

This is fairly simple; we just create an XMLHttpRequest.
You can see we set the `Authorization` header using our access token.

        request = new XMLHttpRequest()
        request.open "GET", location
        request.setRequestHeader "Authorization", "Bearer " + accessToken

###  The callback:

This is the function that is called once the request finishes loading.
We define it inside our `requestFromAPI()` function so that it has access to our `request` and `onComplete` variables.
We also pass through any provided `params`.

        callback = ->
            prevMatches = request.getResponseHeader("Link")?.match /<\s*([^,]*)\s*>\s*;[^,]*[;\s]rel="?prev(?:ious)?"?/
            nextMatches = request.getResponseHeader("Link")?.match /<\s*([^,]*)\s*>\s*;[^,]*[;\s]rel="?next"?/
            onComplete
                params: params
                prev: if prevMatches? then prevMatches[1] else null
                next: if nextMatches? then nextMatches[1] else null
                data: JSON.parse request.responseText
            request.removeEventListener "load", callback, false

We can now add our event listener and send the request.

        request.addEventListener "load", callback, false
        request.send()

        return
