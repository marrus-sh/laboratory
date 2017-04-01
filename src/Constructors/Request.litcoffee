<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.4.0</i> <br> <code>Constructors/Request.litcoffee</code></p>

#  THE REQUEST CONSTRUCTOR  #

 - - -

##  Description  ##

The `Request()` constructor creates a unique, read-only object which represents a request to the Mastodon server.
Its properties are summarized below:

|  Property  | Description |
| :--------: | :---------- |
|    `id`    | A unique numbered `id` for the request |
| `response` | The request's response |

###  Prototype methods:

####  `start()`.

>   ```javascript
>       Laboratory.Request.prototype.start();
>   ```

The `start()` prototype method begins a request.

####  `stop()`.

>   ```javascript
>       Laboratory.Request.prototype.stop();
>   ```

The `stop()` prototype method ends a request.

 - - -

##  Implementation  ##

###  The constructor:

The `Request()` constructor takes a number of arguments: the `method` for the request, the request's `location`, the `data` of the request, and callbacks to be called `onComplete`.

    Request = (method, location, data, token, onComplete) ->

####  Initial setup.

        throw new TypeError "this is not a Request" unless this and this instanceof Request

Our `response` starts out as `null`.
`Request()` never actually sets the value of its instances' `response`; it's up to others to make that decree.

        response = null

`response` can only be set by privileged code and automatically fires a `response` event when it is set.

        Object.defineProperty this, "response",
            configurable: yes
            enumerable: yes
            get: -> response
            set: (n) ->
                if do checkDecree then police =>
                    response = n
                    @dispatchEvent new CustomEvent "response",
                        request: this
                        response: n

If the provided method isn't `GET`, `POST`, or `DELETE`, then we aren't going to make any requests ourselves.

        return this unless method is "GET" or method is "POST" or method is "DELETE"

####  Creating the request.

The core of any `Request` is an `XMLHttpRequest`.

        location = String location
        data = Object data
        request = new XMLHttpRequest

####  Setting the contents.

If our contents aren't `FormData`, then we convert our key-value pairs into a URL-encoded format.
Note that `FormData` isn't supported in IE 9.

        contents =
            if method is "POST" and typeof FormData is "function" and data instanceof FormData
                data
            else (
                (
                    for key, value of data when value?
                        if value instanceof Array then (
                            for subvalue in value
                                (encodeURIComponent key) + "[]=" + encodeURIComponent subvalue
                        ).join "&"
                        else (encodeURIComponent key) + "=" + encodeURIComponent value
                ).join "&"
            ).replace /%20/g, '+'

####  Setting our location.

If our `method` isn't `"POST"` then we need to append our `contents` to the query of our `location`.

        unless contents is "" or method is "POST"
            location += (if (location.indexOf "?") isnt -1 then "&" else "?") + contents

####  The callback.

This is the function that is called once the request finishes loading.
We will consider a status code in the range `200` to `205` (inclusive) to be a success, and anything else to be an error.
Laboratory doesn't support HTTP status codes like `206 PARTIAL CONTENT`.

>   __Note :__
>   We use numbers instead of the easier-to-read state names because state names are different in IE.
>   However, the standard names are as follows:
>
>   - `XMLHttpRequest.UNSENT` (`0`)
>   - `XMLHttpRequest.OPENED` (`1`)
>   - `XMLHttpRequest.HEADERS_RECEIVED` (`2`)
>   - `XMLHttpRequest.LOADING` (`3`)
>   - `XMLHttpRequest.DONE` (`4`)

        callback = =>
            switch request.readyState
                when 0 then  #  Do nothing
                when 1 then dispatch "LaboratoryRequestOpen", request
                when 2, 3 then dispatch "LaboratoryRequestUpdate", request
                when 4
                    status = request.status
                    data =
                        try
                            if request.responseText then JSON.parse request.responseText
                            else null
                        catch
                            error: "The response could not be parsed."
                    link = request.getResponseHeader "Link"
                    params =
                        status: status
                        url: location
                        prev: (
                            (
                                link?.match ///
                                    <\s*([^,]*)\s*>\s*;    #  A URL. Presumably the instance's.
                                    (?:[^,]*[;\s])?        #  Other parameters.
                                    rel="?prev(?:ious)?"?  #  The "prev" rel parameter.
                                ///
                            ) or []
                        )[1]
                        next: (
                            (
                                link?.match ///
                                    <\s*([^,]*)\s*>\s*;  #  A URL. Presumably the instance's.
                                    (?:[^,]*[;\s])?      #  Other parameters.
                                    rel="?next"?         #  The "next" rel parameter.
                                ///
                            ) or []
                        )[1]
                    switch
                        when 200 <= status <= 205
                            if data?.error?
                                @dispatchEvent new CustomEvent "failure",
                                    request: this
                                    response: new Failure data.error, status
                                dispatch "LaboratoryRequestError", request
                            else
                                onComplete data, params if typeof onComplete is "function"
                                dispatch "LaboratoryRequestComplete", request
                        else
                            @dispatchEvent new CustomEvent "failure",
                                request: this
                                response: new Failure data?.error, status
                            dispatch "LaboratoryRequestError", request
                    request.removeEventListener "readystatechange", callback

####  Final steps.

We can now add our event listener and connect our `start` and `stop` properties to `send()` and `abort()` on the `request`.
Note that `abort()` does *not* trigger a `readystatechange` event so our `callback()` will not be called.

        Object.defineProperties this,
            start:
                configurable: yes
                enumerable: no
                writable: no
                value: ->
                    request.open method, location
                    if method is "POST" and not (FormData? and contents instanceof FormData)
                        request.setRequestHeader "Content-type",
                            "application/x-www-form-urlencoded"
                    request.setRequestHeader "Authorization", "Bearer " + token if token?
                    request.addEventListener "readystatechange", callback
                    do request.send if method is "POST" then contents else undefined
                    return
            stop:
                configurable: yes
                enumerable: no
                writable: no
                value: ->
                    request.removeEventListener "readystatechange", callback
                    do request.abort
                    return

And with that, we're done.

        return this

###  The dummy:

External scripts don't actually get to access the `Request` constructor.
Instead, we feed them a dummy function with the same prototype—so `instanceof` will still match.
(The prototype is set in the next section.)

    Laboratory.Request = -> throw new TypeError "Illegal constructor"

###  The prototype:

The `Request` prototype just inherits from `LaboratoryEventTarget`.
We define dummy functions for `start()` and `stop()` but these should be overwritten by instances.
You'll note that `Request.prototype.constructor` gives our dummy constructor, not the real one.

    Object.defineProperty Request, "prototype",
        configurable: no
        enumerable: no
        writable: no
        value: Object.freeze Object.create LaboratoryEventTarget.prototype,
            constructor:
                enumerable: no
                value: Laboratory.Request
            start:
                enumerable: no
                value: ->
            stop:
                enumerable: no
                value: ->
    Object.defineProperty Laboratory.Request, "prototype",
        configurable: no
        enumerable: no
        writable: no
        value: Request.prototype
