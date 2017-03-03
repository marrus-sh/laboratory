#  THE APPLICATION CONSTRUCTOR  #

The `Application()` constructor creates a unique, read-only object which represents an application used to interface with the Mastodon API.
Its properties are summarized below, alongside their Mastodon API equivalents:

| Property | API Response | Description |
| :------: | :----------: | :---------- |
|  `name`  |    `name`    | The name of the application |
|  `href`  |  `website`   | The url of the application's homepage or website |

##  Implementation  ##

###  The constructor:

The `Application()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.

    Constructors.Application = (data) ->

        return unless this and (this instanceof Constructors.Application) and data?

        @name = data.name
        @href = data.website

        return Object.freeze this

###  The prototype:

The `Application` prototype just inherits from `Object`.

    Object.defineProperty Constructors.Application, "prototype",
        value: Object.freeze {}
