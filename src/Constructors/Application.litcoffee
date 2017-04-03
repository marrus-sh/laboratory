<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.4.0</i> <br> <code>Constructors/Application.litcoffee</code></p>

#  THE APPLICATION CONSTRUCTOR  #

 - - -

##  Description  ##

The `Application()` constructor creates a unique, read-only object which represents an application used to interface with the Mastodon API.
Its properties are summarized below, alongside their Mastodon API equivalents:

| Property | API Response | Description |
| :------: | :----------: | :---------- |
|  `name`  |    `name`    | The name of the application |
|  `href`  |  `website`   | The url of the application's homepage or website |

 - - -

##  Examples  ##

>   __[Issue #53](https://github.com/marrus-sh/laboratory/issues/53) :__
>   Usage examples for constructors are forthcoming.

 - - -

##  Implementation  ##

###  The constructor:

The `Application()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.

    Laboratory.Application = Application = (data) ->

        unless this and this instanceof Application
            throw new TypeError "this is not an Application"
        unless data?
            throw new TypeError "Unable to create Application; no data provided"

        @name = data.name
        @href = data.website

        return Object.freeze this

###  The prototype:

The `Application` prototype just inherits from `Object`.

    Object.defineProperty Application, "prototype",
        value: Object.freeze {}
