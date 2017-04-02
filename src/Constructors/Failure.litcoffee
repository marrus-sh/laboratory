<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.4.0</i> <br> <code>Constructors/Timeline.litcoffee</code></p>

#  THE FAILURE CONSTRUCTOR  #

 - - -

##  Description  ##

The `Failure()` constructor creates a unique, read-only object which represents a failed request.
Its properties are summarized below, alongside their Mastodon API equivalents:

| Property  |  API Response  | Description |
| :-------: | :------------: | :---------- |
|  `error`  |    `error`     | The text of the error |
|  `code`   | *Not provided* | The HTTP access code of the error, if applicable |
| `request` | *Not provided* | The request which failed |

 - - -

##  Implementation  ##

###  The constructor:

The `Failure()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.
We have to provide it with the `request` we made and the HTTP `code` of the response as well.

    Laboratory.Failure = Failure = (data, request, code) ->

        unless this and this instanceof Failure
            throw new Error "Laboratory Error : `Failure()` must be called as a constructor"
        unless data?
            throw new Error "Laboratory Error : `Failure()` was called without any `data`"

        @request = String request
        @error = String data.error
        @code = null unless isFinite @code = Number code

        return Object.freeze this

###  The prototype:

The `Failure` prototype just inherits from `Object`.

    Object.defineProperty Failure, "prototype",
        value: Object.freeze {}
