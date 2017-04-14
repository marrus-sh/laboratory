<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>Constructors/Timeline.litcoffee</code></p>

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

##  Examples  ##

>   __[Issue #29](https://github.com/marrus-sh/laboratory/issues/29) :__
>   Usage examples for constructors are forthcoming.

 - - -

##  Implementation  ##

###  The constructor:

The `Failure()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.
We have to provide it with the `request` we made and the HTTP `code` of the response as well.

>   __[Issue #53](https://github.com/marrus-sh/laboratory/issues/53) :__
>   `Failure`s may be localizable in the future.

    Laboratory.Failure = Failure = (data, code) ->

        unless this and this instanceof Failure
            throw new TypeError "this is not a Failure"
        unless data?
            throw new TypeError "Unable to create Failure; no data provided"

        @error = String data.error
        @code = null unless isFinite @code = Number code

        return Object.freeze this

###  The prototype:

The `Failure` prototype just inherits from `Object`.

    Object.defineProperty Failure, "prototype",
        value: Object.freeze {}
