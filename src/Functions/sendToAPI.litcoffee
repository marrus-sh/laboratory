#  `Laboratory.Functions.sendToAPI`

This module is used to send information to the Mastodon API.
It sends its `contents` to `location` using the provided `accessToken`, and when it finishes it calls the function provided by `onComplete` with an object containing the request's response as its `data`.

    Laboratory.Functions.sendToAPI = (contents, location, accessToken, onComplete, params) ->

##  Creating the Request  ##

This is fairly simple; we just create an XMLHttpRequest.
You can see we set the `Authorization` header using our access token.

        request = new XMLHttpRequest()
        request.open "POST", location
        request.setRequestHeader "Content-type", "application/x-www-form-urlencoded"
        request.setRequestHeader "Authorization", "Bearer " + accessToken if accessToken

###  The callback:

This is the function that is called once the request finishes loading.
We define it inside our `requestFromAPI()` function so that it has access to our `request` and `onComplete` variables.
We also pass through any provided `params`.

        callback = ->
            return unless request.readyState is XMLHttpRequest.DONE and request.status is 200
            onComplete
                params: params
                data: JSON.parse request.responseText
            request.removeEventListener "readystatechange", callback, false

We can now add our event listener and send the request.

        request.addEventListener "readystatechange", callback, false
        request.send(contents)

        return
