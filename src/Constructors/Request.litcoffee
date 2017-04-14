<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>Constructors/Request.litcoffee</code></p>

#  THE REQUEST CONSTRUCTOR  #

 - - -

##  Description  ##

The `Request()` constructor creates a unique, read-only object which represents a request to the Mastodon server.
Its properties are summarized below:

|  Property  | Description |
| :--------: | :---------- |
|    `id`    | A unique numbered `id` for the request |
| `response` | The request's response |

>   __[Issue #38](https://github.com/marrus-sh/laboratory/issues/38) :__
>   A `Request.STATE` enumeral is planned.

###  Instance methods:

####  Starting and stopping.

>   ```javascript
>   request.start();
>   request.stop();
>   ```
>
>   - __`request` :__ A `Request`.

The `start()` method starts a request, and `stop()` ends one.
It is recommended that you always `stop()` a request after you're done using it.

####  Assigning and removing callbacks.

>   ```javascript
>   request.assign(callback);
>   request.remove(callback);
>   ```
>
>   - __`request` :__ A `Request`.
>   - __`callback` :__ A callback function to add or remove.

The provided `callback` will be called when the `request` finishes.

 - - -

##  Examples  ##

>   __[Issue #53](https://github.com/marrus-sh/laboratory/issues/53) :__
>   Usage examples for constructors are forthcoming.

 - - -

##  Implementation  ##

We define `Request()` inside a closure because it involves a number of helper functions.

    Request = undefined

    do ->

###  Setting and getting the response:

The `setResponse()` function sets the `response` of a `Request` and triggers its callbacks.
It can only be called from privileged code.

        setResponse = (stored, n) ->
            if do checkDecree then police =>
                stored.response = n
                for callback in stored.callbacks when typeof callback is "function"
                    callback this
                return

`getResponse()` just returns the current value of the `response`.

        getResponse = (stored) -> stored.response

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

        finish = (request, onComplete) ->
            switch request.readyState
                when 0 then  #  Do nothing
                when 1 then dispatch "LaboratoryRequestOpen", request
                when 2, 3 then dispatch "LaboratoryRequestUpdate", request
                when 4
                    status = request.status
                    result =
                        try
                            if request.responseText then JSON.parse request.responseText
                            else {}
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
                            if result?.error?
                                decree => @response = police -> new Failure result, status
                                dispatch "LaboratoryRequestError", request
                            else
                                onComplete result, params if typeof onComplete is "function"
                                dispatch "LaboratoryRequestComplete", request
                        else
                            decree => @response = police -> new Failure result, status
                            dispatch "LaboratoryRequestError", request
            return

###  Adding and removing callbacks:

The `assign()` function assigns the provided `callback` to the `Request`.
Meanwhile, the `remove()` function removes the provided `callback`.
Both of these functions return the `Request` so that they can be chained.

        assign = (stored, callback) ->
            unless typeof callback is "function"
                throw new TypeError "Provided callback was not a function"
            stored.callbacks.push callback unless callback in stored.callbacks
            return this

        remove = (stored, callback) ->
            until (index = stored.callbacks.indexOf callback) is -1
                stored.callbacks.splice index, 1
            return this

###  Starting and stopping:

The `start()` function begins a request, and the `stop()` function finishes one.
`start()` automatically calls `stop()` before proceeding.

        start = (stored) ->
            return unless (request = stored.request) instanceof XMLHttpRequest
            do @stop
            contents = stored.contents
            token = stored.token
            request.open method = stored.method, stored.location
            if method is "POST" and not (FormData? and contents instanceof FormData)
                request.setRequestHeader "Content-type",
                    "application/x-www-form-urlencoded"
            request.setRequestHeader "Authorization", "Bearer " + token if token?
            request.addEventListener "readystatechange", stored.callback
            request.send if method is "POST" then contents else undefined
            return

        stop = (stored) ->
            return unless (request = stored.request) instanceof XMLHttpRequest
            request.removeEventListener "readystatechange", stored.callback
            do request.abort
            return

###  The constructor:

The `Request()` constructor takes a number of arguments: the `method` for the request, the request's `location`, the `data` of the request, and callbacks to be called `onComplete`.
It can't actually be called from outside of Laboratory source.

>   __[Issue #47](https://github.com/marrus-sh/laboratory/issues/47) :__
>   It would be great if it were possible to monitor the progress of `Request`s.

        Request = (method, location, data, token, onComplete) ->

####  Initial setup.

            unless this and this instanceof Request
                throw new TypeError "this is not a Request"

We'll keep track of all the callbacks assigned to this `Request` with the `stored.callbacks` array.
Our `stored.response` starts out as `null`.
`Request()` only sets the value of its instances' `response`s in the case of failures; it's up to others to make that decree otherwise.

            data = Object(data)
            stored =
                callback: undefined
                callbacks: []
                contents: undefined
                location: location = String location
                method: method = String method
                request: undefined
                response: null
                token: if token? then String token else undefined

####  Defining instance properties and methods.

We bind our instance to our helper functions and properties here.

>   __[Issue #38](https://github.com/marrus-sh/laboratory/issues/38) :__
>   `Request`s should have a `state` property which indicates their state (running or stopped).

            Object.defineProperties this,
                assign:
                    configurable: yes
                    enumerable: no
                    writable: no
                    value: assign.bind this, stored
                remove:
                    configurable: yes
                    enumerable: no
                    writable: no
                    value: remove.bind this, stored
                response:
                    configurable: yes
                    enumerable: yes
                    get: getResponse.bind this, stored
                    set: setResponse.bind this, stored
                start:
                    configurable: yes
                    enumerable: no
                    writable: no
                    value: start.bind this, stored
                stop:
                    configurable: yes
                    enumerable: no
                    writable: no
                    value: stop.bind this, stored

If the provided method isn't `GET`, `POST`, or `DELETE`, then we aren't going to make any requests ourselves.

            return this unless method is "GET" or method is "POST" or method is "DELETE"
            stored.callback = finish.bind this, stored.request = new XMLHttpRequest, onComplete

####  Setting the contents.

If our contents aren't `FormData`, then we convert our key-value pairs into a URL-encoded format.
Note that `FormData` isn't supported in IE 9.

            stored.contents = contents =
                if method is "POST" and typeof FormData is "function" and data instanceof FormData
                    data
                else (
                    (
                        for key, value of data when value?
                            if isArray value then (
                                for subvalue in value
                                    (encodeURIComponent key) + "[]=" + encodeURIComponent subvalue
                            ).join "&"
                            else (encodeURIComponent key) + "=" + encodeURIComponent value
                    ).join "&"
                ).replace /%20/g, '+'

####  Setting our location.

If our `method` isn't `"POST"` then we need to append our `contents` to the query of our `location`.

            unless contents is "" or method is "POST"
                stored.location += (if "?" in location then "&" else "?") + contents

And with that, we're done.

            return this

###  The dummy:

External scripts don't actually get to access the `Request()` constructor.
Instead, we feed them a dummy function with the same prototype—so `instanceof` will still match.
(The prototype is set in the next section.)

        Laboratory.Request = (data) -> throw new TypeError "Illegal constructor"

###  The prototype:

The `Request` prototype mostly just inherits from `LaboratoryEventTarget`.
The `go()` function creates a new `Promise` for the response.
(Obviously, this requires support for `Promise`s to be present in the environment.)
We define dummy functions for our instance methods but these should be overwritten by instances.
You'll note that `Request.prototype.constructor` gives our dummy constructor, not the real one.

        Object.defineProperty Request, "prototype",
            configurable: no
            enumerable: no
            writable: no
            value: Object.freeze Object.create Object.prototype,
                assign:
                    enumerable: no
                    value: ->
                constructor:
                    enumerable: no
                    value: Laboratory.Request
                go:
                    enumerable: no
                    value: -> new Promise (resolve, reject) =>
                        callback = (response) =>
                            (if response instanceof Failure then reject else resolve) response
                            @remove callback
                        @assign callback
                        @start
                remove:
                    enumerable: no
                    value: ->
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
