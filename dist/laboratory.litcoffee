<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>README.litcoffee</code></p>

#  _LABORATORY_  #

 - - -

##  Description  ##

Welcome to the Laboratory source code!
Laboratory is an open-source, client-side engine for Mastodon written in Literate CoffeeScript.
Its source files are parseable as regular Markdown documents, and this file is in fact part of the Laboratory source!

###  How to read Laboratory source code:

Each Laboratory source code file is broadly split up into three parts, as follows:

- The ___Description___ describes what the file does and how to use the interfaces it provides
- The ___Examples___ give sample snippets of JavaScript code that you can look at to see Laboratory at work
- The ___Implementation___ provides and explains the precise mechanisms by which Laboratory implements its features

The implementation will always be the last section in the document, and it is the one that it is safest to ignore—any important information should have already been covered in the description of what goes on in the file.
However, you can turn to the implementation if you are curious on how specific Laboratory features are actually coded.
(And, of course, if you are a computer, the compiled implementation is the only part of this file you will ever see!)

####  What to read.

If you're looking to use Laboratory in your project, then you should definitely familiarize yourself with the [Laboratory API](API/), as this is the primary means of interfacing with the Laboratory engine.
Each file of the API provides a different module, and you should take a look at at least the descriptions for each.
These will give you an overview of each API component and direct you towards further information.

The [Constructors](Constructors/) documentation provides details on the various data types you might encounter while interacting with Laboratory.
You should turn to these files whenever you are unclear on what specific properties or methods an object provides.

####  Notable conventions.

Laboratory contains a number of constructors, functions, and objects which are made available on the `window.Laboratory` object.
For simplicity's sake, this documentation omits the `Laboratory` part in prose; for example, `Laboratory.Authorization` will be referred to as `Authorization` and `Laboratory.dispatch()` will be represented as `dispatch()`.
In code examples, the `Laboratory` prefix should be included.

Laboratory tries its hardest to follow the conventions set forward in the [Laboratory Style Guide](https://github.com/marrus-sh/laboratory-style).

###  About this file:

In addition to serving as a broad introduction to the Laboratory source, this file sets up our scripts with the basic objects, functions, and polyfills they will need for operation.
You can see the specifics of these in the _Implementation_ below.
This file is the first thing that Laboratory loads.

 - - -

##  Examples  ##

For basic examples on how to use Laboratory, see [_Using Laboratory_](INSTALLING.litcoffee).

 - - -

##  Implementation  ##

This file doesn't actually do much, but it's the first thing that our Laboratory script runs.

###  Strict mode:

Laboratory runs in strict mode.

    "use strict"

###  Introduction:

This is the first file in our compiled source, so let's identify ourselves real fast.

    ###

        ............. LABORATORY ..............

        A client-side API for Mastodon, a free,
           open-source social network server
                  - - by Kibigo! - -

            Licensed under the MIT License.
               Source code available at:
        https://github.com/marrus-sh/laboratory

                    Version 0.5.0

    ###

Laboratory uses an [MIT License](../LICENSE.md) because it's designed to be included in other works.
Feel free to make it your own!

###  First steps:

We include an informative url for the `Laboratory` package on `Laboratory.ℹ` and give the version number on `Laboratory.Nº` for intersted parties.
Laboratory follows semantic versioning, which translates into `Nº` as follows: `Major * 100 + Minor + Patch / 100`.
Laboratory thus assures that minor and patch numbers will never exceed `99` (indeed this would be quite excessive!).

    Laboratory =
        ℹ: "https://github.com/marrus-sh/laboratory"
        Nº: 5.0

Laboratory is designed to be extended, and these attributes provide extensions with a simple way of detecting Laboratory support.

###  Popup handling:

If this is a popup (`window.opener.Laboratory` exists) and an API redirect (a `code` parameter exists in our query), then we hand our opener our code.

    do ->
        if (code = (location.search.match(/code=([^&]*)/) || [])[1]) and Mommy = window.opener
            Mommy.postMessage code, window.location.origin

Assuming that this window was opened during the normal Laboratory OAuth proceedures, it will soon be closed.

###  API and exposed properties:

The Laboratory API is available through the `Laboratory` object.

Although Laboratory does not expose its store to outsiders, it does carefully reveal a few key properties.
These are:

- `ready`, which indicates whether `LaboratoryInitializationReady` has fired yet
- `auth`, which gives the `Authorization` object that `Laboratory` is currently using.

For now, we'll keep these properties in the `Exposed` object, and define getters on `Laboratory` for accessing them.

    Exposed =
        ready: no
        auth: null

    for prop of Exposed
        do (prop) -> Object.defineProperty Laboratory, prop,
            enumerable: yes
            configurable: no
            get: -> Exposed[prop]

###  Privileged and unprivileged code:

There are certain features that we will want available from within the API that should not be accessible to outsiders.
The `decree()` function immediately invokes its argument with privilege, while the `checkDecree()` function checks whether privilege is currently had.
The `police()` function can be used to remove privilege from within a `decree`.
For obvious reasons, none of these functions are exposed to the window.

    decree = police = checkDecree = null
    do ->
        isPrivileged = no
        decree = (callback) ->
            wasPrivileged = isPrivileged
            isPrivileged = yes
            result = do callback
            isPrivileged = wasPrivileged
            return result
        police = (callback) ->
            wasPrivileged = isPrivileged
            isPrivileged = no
            result = do callback
            isPrivileged = wasPrivileged
            return result
        checkDecree = -> isPrivileged

###  `CustomEvent()`:

`CustomEvent()` is required for our event handling.
This is a CoffeeScript re-implementation of the polyfill available on [the MDN](https://developer.mozilla.org/en-US/docs/Web/API/CustomEvent/CustomEvent).

    CustomEvent = do ->
        return window.CustomEvent if typeof window.CustomEvent is "function"
        CE = (event, params) ->
            params = params or {bubbles: no, cancelable: no, detail: undefined}
            e = document.createEvent "CustomEvent"
            e.initCustomEvent event, params.bubbles, params.cancelable, params.detail
            return e
        CE.prototype = Object.freeze Object.create window.Event.prototype
        Object.freeze CE

###  `reflection()` and `give()`:

`reflection()` is a function that just returns its `this`.
For convenience, the `give()` function returns a reflection bound to its argument.

    reflection = -> this
    give = (n) -> reflection.bind n

###  `isArray()`:

`isArray()` checks to see if the given argument is an array.

    isArray =
        if typeof Array.isArray is "function" then Array.isArray
        else (n) -> (Object.prototype.toString.call n) is "[object Array]"


- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>Constructors/README.litcoffee</code></p>

#  LABORATORY CONSTRUCTORS  #

 - - -

##  Description  ##

The data received from Laboratory API responses is processed and converted into one of several object types before it makes its way to users.
This process is handled by __Laboratory constructors,__ which define the basic data types used when interacting with the API.
Many Laboratory constructors are also API modules; however, some are more "passive" and don't have events directly associated with them.

The Laboratory constructors are as follows:

- [__Application__](Application.litcoffee)
- [__Attachment__](Attachment.litcoffee)
- [__Authorization__](Authorization.litcoffee)
- [__Client__](Client.litcoffee)
- [__Enumeral__](Enumeral.litcoffee)
- [__Failure__](Failure.litcoffee)
- [__Post__](Post.litcoffee)
- [__Profile__](Profile.litcoffee)
- [__Request__](Request.litcoffee)
- [__Rolodex__](Rolodex.litcoffee)
- [__Timeline__](Timeline.litcoffee)

###  API spoofing:

Most Laboratory constructors expect a Mastodon API response as their first argument.
If you find yourself needing to call them yourself (to dispatch your own `Post`s, for example), then you should feed them an object that matches what would be sent out by the Mastodon server.
See the [Mastodon API documentation](https://github.com/tootsuite/mastodon/blob/master/docs/Using-the-API/API.md) for details on what these objects look like.

 - - -

##  Implementation  ##

See specific constructor pages for details on their implementation.

>   __[Issue #6](https://github.com/marrus-sh/laboratory/issues/6) :__
>   Constructor getters may be re-written to use lazy-loading in the future.

>   __[Issue #9](https://github.com/marrus-sh/laboratory/issues/9) :__
>   Right now arrays and objects passed to constructors must originate in the same window as the constructor.
>   This requirement may be lifted in the future.

>   __[Issue #10](https://github.com/marrus-sh/laboratory/issues/10) :__
>   Right now constructors only require that they be called with a `this` that is an `instanceof` themselves, but this may change in the future.

>   __[Issue #11](https://github.com/marrus-sh/laboratory/issues/11) :__
>   As a matter of fact, the way `instanceof` works for Laboratory constructors may itself be modified at some future time.

>   __[Issue #62](https://github.com/marrus-sh/laboratory/issues/62) :__
>   Constructors may not support very recent additions to the Mastodon API.


- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>Constructors/Enumeral.litcoffee</code></p>

#  LABORATORY ENUMERALS  #

 - - -

##  Description  ##

If you have experience working with JavaScript and the DOM, you may have encountered DOM attributes whose values are described by an enumerated type.
For example, `Node.NodeType` can have values which include `Node.ELEMENT_NODE`, with a value of `1`, and `Node.TEXT_NODE`, with a value of `3`.
__Laboratory enumerals__ are an extension of this principle.
They aim to accomplish these things:

1.  **Provide a unique, static identifier for a response value.**
    Laboratory enumerals are unique, immutable objects that do not equate to anything but themselves under strict (`===`) equality.

2.  **Allow checking of specific properties using binary flags.**
    Laboratory enumerals compute to numbers which are non-arbitrary in their meaning.
    You can use binary tests to check for specific enumeral properties; for example, `visibility & Laboratory.Post.Visibility.LISTED` can be used to tell if a given `visibility` is listed or not.

3.  **Provide easy type identification.**
    Each Laboratory enumeral is an instance of the object in which it is contained.
    Thus, `Laboratory.PostType.STATUS instanceof Laboratory.PostType` evaluates to `true`.

4.  **Guarantee uniqueness of value.**
    It is guaranteed that no two enumerals of a given type will share the same value.

###  Enumeral types:

Enumeral types can be created by calling `Enumeral.generate()` with an object whose properties and values give the names and values for the resultant enumerals, like so:

>   ```javascript
>   MyType = Enumeral.generate({
>       TYPE_A: 1
>       TYPE_B: 2
>       TYPE_AB: 3
>       TYPE_C: 4
>       TYPE_F: 32
>   });
>   console.log(
>       MyType.TYPE_A instanceof MyType &&  //  TYPE_A is an instance of MyType
>       MyType.TYPE_A == 1 &&               //  TYPE_A.valueOf() is 1
>       !(MyType.TYPE_A === 1)              //  But TYPE_A isn't 1
>   );  //  `true`
>   ```

Further discussion of specific enumeral types takes place in the various files in which they are defined.

####  `fromValue()`.

>   ```javascript
>   MyType.fromValue(n);
>   ```
>
>   - __`n` :__ An integer value

The `fromValue()` method of an enumeral type can be used to get the enumeral associated with the given value.

 - - -

##  Examples  ##

>   __[Issue #53](https://github.com/marrus-sh/laboratory/issues/53) :__
>   Usage examples for constructors are forthcoming.

 - - -

##  Implementation  ##

###  The constructor:

The `Enumeral()` constructor takes a numeric `value`, which the resultant enumeral will compute to.

    Enumeral = (value) ->

        throw new TypeError "this is not a Enumeral" unless this and this instanceof Enumeral

        @value = value | 0
        return Object.freeze this

###  The dummy:

External scripts don't actually get to access the `Enumeral()` constructor.
Instead, we feed them a dummy function with the same prototype—so `instanceof` will still match.
(The prototype is set in the next section.)

    Laboratory.Enumeral = (value) -> throw new TypeError "Illegal constructor"

###  The prototype:

The `Enumeral` prototype overwrites `valueOf()` to allow for easy numeric conversion.
It also adjusts `toString()` and `toSource()` slightly.
You'll note that `Enumeral.prototype.constructor` gives our dummy constructor, not the real one.

    Object.defineProperty Enumeral, "prototype",
        configurable: no
        enumerable: no
        writable: no
        value: Object.freeze Object.defineProperties {},
            constructor:
                enumerable: no
                value: Laboratory.Enumeral
            toString:
                enumerable: no
                value: -> "Enumeral(" + @value + ")"
            toSource:
                enumerable: no
                value: -> "Enumeral(" + @value + ")"
            valueOf:
                enumerable: no
                value: -> @value
    Object.defineProperty Laboratory.Enumeral, "prototype",
        configurable: no
        enumerable: no
        writable: no
        value: Enumeral.prototype

###  Generating enumerals:

The `generate()` constructor method creates an `Enumeral` type that meets our specifications.
The provided `data` should be an object whose enumerable own properties associate enumeral names with values.

    Enumeral.generate = (data) ->

First, we need to "fork" the main `Enumeral` constructor so that typechecking will work.
We create a new constructor that just passes everything on.

        type = (n) -> Enumeral.call this, n
        type.prototype = Object.create Enumeral.prototype

Next, we define our enumerals.
We also create a hidden object which store the relationship going the other way.
Note that since values are not guaranteed to be unique, this object may not contain every enumeral (some might be overwritten).

        byValue = {}
        for own enumeral, value of data
            continue if byValue[value]?
            type[enumeral] = new type value
            byValue[value] = type[enumeral]

This function allows quick conversion from value to enumeral.

        type.fromValue = (n) -> byValue[n | 0]

We can now freeze our enumerals and return them.

        return Object.freeze type


- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>Constructors/Application.litcoffee</code></p>

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


- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>Constructors/Attachment.litcoffee</code></p>

#  THE ATTACHMENT CONSTRUCTOR  #

 - - -

##  Description  ##

The `Attachment()` constructor creates a unique, read-only object which represents an attached piece of media sent through the Mastodon API.
Its properties are summarized below, alongside their Mastodon API equivalents:

| Property  | API Response  | Description |
| :-------: | :-----------: | :---------- |
|   `id`    |     `id`      | The id of the media attachment |
|  `href`   |     `url`     | The url of the media attachment |
| `preview` | `preview_url` | The url of a preview for the media attachment |
|  `type`   |    `type`     | An `Attachment.Type` |

###  Media types:

The possible `Attachment.Type`s are as follows:

| Enumeral | Binary Value | Description |
| :------: | :----------: | :---------- |
| `Attachment.Type.UNKNOWN` | `00` | The media type cannot be determined |
| `Attachment.Type.PHOTO` | `01` | The media is a photo |
| `Attachment.Type.VIDEO` | `10` | The media is a video |
| `Attachment.Type.GIFV` | `11` | The media is a gif-video |

 - - -

##  Examples  ##

>   __[Issue #53](https://github.com/marrus-sh/laboratory/issues/53) :__
>   Usage examples for constructors are forthcoming.

 - - -

##  Implementation  ##

###  The constructor:

The `Attachment()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.

    Laboratory.Attachment = Attachment = (data) ->

        unless this and this instanceof Attachment
            throw new TypeError "this is not an Attachment"
        unless data?
            throw new TypeError "Unable to create Attachment; no data provided"

        @id = Number data.id
        @href = String data.url
        @preview = String data.preview_url
        @type = switch data.type
            when "image" then Attachment.Type.IMAGE
            when "video" then Attachment.Type.VIDEO
            when "gifv" then Attachment.Type.GIFV
            else Attachment.Type.UNKNOWN

        return Object.freeze this

###  The prototype:

The `Attachment` prototype just inherits from `Object`.

    Object.defineProperty Attachment, "prototype",
        value: Object.freeze {}

###  Defining media types:

Here we define our `Attachment.Type`s, as described above:

    Attachment.Type = Enumeral.generate
        UNKNOWN : 0b00
        PHOTO   : 0b01
        VIDEO   : 0b10
        GIFV    : 0b11


- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>Constructors/Authorization.litcoffee</code></p>

#  THE AUTHORIZATION CONSTRUCTOR  #

 - - -

##  Description  ##

The `Authorization()` constructor creates a unique, read-only object which represents a successful authorization request.
Its properties are summarized below, alongside their Mastodon API equivalents:

|   Property    |  API Response  | Description |
| :-----------: | :------------: | :---------- |
|   `origin`    | *Not provided* | The origin of the API request |
| `accessToken` | `access_token` | The access token received by the authorization |
|  `datetime`   |  `created_at`  | The `Date` the token was created |
|    `scope`    |    `scope`     | The `Authorization.Scope` associated with the access token |
|  `tokenType`  |  `token_type`  | Should always be the string `"bearer"` |
|     `me`      | *Not provided* | The id of the currently-signed-in account |

###  Scopes:

The possible `Authorization.Scope`s are as follows:

| Enumeral | Binary Value | Description |
| :------: | :----------: | :---------- |
| `Authorization.Scope.NONE` | `000` | No scope is defined |
| `Authorization.Scope.READ` | `001` | The scope is `"read"` |
| `Authorization.Scope.WRITE` | `010` | The scope is `"write"` |
| `Authorization.Scope.READWRITE` | `011` | The scope is `"read write"` |
| `Authorization.Scope.FOLLOW` | `100` | The scope is `"follow"` |
| `Authorization.Scope.READFOLLOW` | `101` | The scope is `"read follow"` |
| `Authorization.Scope.WRITEFOLLOW` | `110` | The scope is `"write follow"` |
| `Authorization.Scope.READWRITEFOLLOW` | `111` | The scope is `"read write follow"` |

 - - -

##  Examples  ##

>   __[Issue #53](https://github.com/marrus-sh/laboratory/issues/53) :__
>   Usage examples for constructors are forthcoming.

 - - -

##  Implementation  ##

###  The constructor:

The `Authorization()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.
We also need to provide it with an `origin`.

    Laboratory.Authorization = Authorization = (data, origin, me) ->

        unless this and this instanceof Authorization
            throw new TypeError "this is not an Authorization"
        unless data?
            throw new TypeError "Unable to create Authorization; no data provided"

        @origin = String origin
        @accessToken = String data.access_token
        @datetime = new Date data.created_at
        @scope = Authorization.Scope.fromValue Authorization.Scope.READ *
            ("read" not in (scopes = (String data.scope).split /[\s\+]+/g)) +
            Authorization.Scope.WRITE * ("write" not in scopes) +
            Authorization.Scope.FOLLOW * ("follow" not in scopes)
        @tokenType = String data.tokenType
        @me = +me

        return Object.freeze this

###  The prototype:

The `Authorization` prototype just inherits from `Object`.

    Object.defineProperty Authorization, "prototype",
        value: Object.freeze {}

###  Defining our scopes:

Here we define our `Authorization.Scope`s, as described above:

    Authorization.Scope = Enumeral.generate
        NONE            : 0b000
        READ            : 0b001
        WRITE           : 0b010
        READWRITE       : 0b011
        FOLLOW          : 0b100
        READFOLLOW      : 0b101
        WRITEFOLLOW     : 0b110
        READWRITEFOLLOW : 0b111


- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>Constructors/Client.litcoffee</code></p>

#  THE CLIENT CONSTRUCTOR  #

 - - -

##  Description  ##

The `Client()` constructor creates a unique, read-only object which represents a registered Mastodon client.
It is unlikely you will ever need to call this constructor yourself.
Its properties are summarized below, alongside their Mastodon API equivalents:

|    Property    |  API Response   | Description |
| :------------: | :-------------: | :---------- |
|    `origin`    | *Not provided*  | The origin of the API request |
|     `name`     | *Not provided*  | The name of the client |
|      `id`      |      `id`       | The internal id for the client|
|   `clientID`   |   `client_id`   | The public id of the client |
| `clientSecret` | `client_secret` | The private (secret) id of the client |
|    `scope`     | *Not provided*  | The [`Authorization.Scope`](Authorization.litcoffee) associated with the client |
|   `redirect`   | `redirect_uri`  | The redirect URL associated with the client |

 - - -

##  Examples  ##

>   __[Issue #53](https://github.com/marrus-sh/laboratory/issues/53) :__
>   Usage examples for constructors are forthcoming.

 - - -

##  Implementation  ##

###  The constructor:

The `Client()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.
It also takes a couple of other arguments.

>   __[Issue #37](https://github.com/marrus-sh/laboratory/issues/37) :__
>   The `Client()` constructor may be modified to be more user-friendly in the future.

    Laboratory.Client = Client = (data, origin, name, scope) ->

        unless this and this instanceof Client
            throw new TypeError "this is not a Client"
        unless data?
            throw new TypeError "Unable to create Client; no data provided"

        @origin = origin
        @name = name
        @id = data.id
        @clientID = data.client_id
        @clientSecret = data.client_secret
        @scope = scope
        @redirect = data.redirect_uri

        return Object.freeze this

###  The prototype:

The `Client` prototype just inherits from `Object`.

    Object.defineProperty Client, "prototype",
        value: Object.freeze {}


- - -

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


- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>Constructors/Post.litcoffee</code></p>

#  THE POST CONSTRUCTOR  #

 - - -

##  Description  ##

The `Post()` constructor creates a unique, read-only object which represents an account's profile information.
Its properties are summarized below, alongside their Mastodon API equivalents:

|      Property      |    API Response     | Description |
| :----------------: | :-----------------: | :---------- |
|       `type`       |   *Not provided*    | A `Post.Type` |
|       `id`         |        `id`         | The id of the post |
|       `uri`        |        `uri`        | A fediverse-unique identifier for the post |
|      `href`        |        `url`        | The url of the post's page |
|     `author`      |       `account`      | The account who made the post |
|    `inReplyTo`     |  `in_reply_to_id`   | The id of the account who made the post |
|     `content`      |      `content`      | The content of the status |
|     `datetime`     |    `created_at`     | The time when the post was created |
|   `reblogCount`    |   `reblogs_count`   | The number of reblogs the post has |
|  `favouriteCount`  | `favourites_count`  | The number of favourites the post has |
|   `isReblogged`    |     `reblogged`     | Whether or not the user has reblogged the post |
|   `isFavourited`   |    `favourited`     | Whether or not the user has favourited the post |
|      `isNSFW`      |     `sensitive`     | Whether or not the post's media contains sensitive content |
|     `message`      |   `spoiler_text`    | The message to hide the post behind, if any |
|    `visibility`    |    `visibility`     | A `Post.Visibility` |
| `mediaAttachments` | `media_attachments` | An array of [`Attachment`](Attachment.litcoffee)s |
|     `mentions`     |     `mentions`      | An array of [`Profile`](Profile.litcoffee)s |
|   `application`    |   `application`     | A [`Application`](Application.litcoffee) identifying the application which created the post |
|   `rebloggedBy`    |   *Not provided*    | The account who reblogged the post; only set for reblog notifications |
|   `favouritedBy`   |   *Not provided*    | The account who favourited the post; only set for favourite notifications |

`Post`s will not necessarily contain all of the above properties.
Follow notifcations will only have a `type`, `id`, and `author`, and the `rebloggedBy` and `favouritedBy` properties only show up on reblog and favourite reactions, respectively.
If a reaction has neither of these properties, then it must be a mention.

###  Post types:

The available `Post.Type`s are as follows:

| Enumeral | Hex Value | Description |
| :------: | :-------: | :---------- |
| `Post.Type.UNKNOWN` | `0x00` | The post type cannot be determined |
| `Post.Type.STATUS` | `0x10` | The post is an status |
| `Post.Type.NOTIFICATION` | `0x20` | The post is a notification |
| `Post.Type.FOLLOW` | `0x21` | The post is a notification |
| `Post.Type.REACTION` | `0x30` | The post is a notification responding to another post |
| `Post.Type.FAVOURITE` | `0x31` | The post is a notification responding to another post |
| `Post.Type.REBLOG` | `0x32` | The post is a notification responding to another post |
| `Post.Type.MENTION` | `0x33` | The post is a notification responding to another post |

Note that not all of the above types will necessarily ever appear on posts; `Post.Type.NOTIFICATION` and `Post.Type.REACTION` exist purely for use with binary comparison tests.

###  Post visibilities:

The available `Post.Visibility`s are as follows:

| Enumeral | Binary Value | Description |
| :------: | :-----------: | :---------- |
| `Post.Visibility.DIRECT` | `000` | The post can only be seen by those mentioned and cannot be reblogged |
| `Post.Visibility.REBLOGGABLE` | `001` | The post can only be seen by those mentioned, but can be reblogged |
| `Post.Visibility.IN_HOME` | `010` | The post can be viewed in users' home timelines |
| `Post.Visibility.UNLISTED` | `011` | The post can be viewed in users' home timelines and can be reblogged |
| `Post.Visibility.LISTED` | `100` | The post can be viewed in the global timelines |
| `Post.Visibility.NOT_IN_HOME` | `101` | The post can be viewed in the global timelines and can be reblogged |
| `Post.Visibility.UNREBLOGGABLE` | `110` | The post is listed but can't be reblogged |
| `Post.Visibility.PUBLIC` | `111` | The post is listed and can be reblogged |

However, note that only some of these are valid Mastodon visibilities:

- `Post.Visibility.DIRECT` is "direct" visibility
- `Post.Visibility.IN_HOME` is "private" visibility
- `Post.Visibility.UNLISTED` is "unlisted" visibility
- `Post.Visibility.PUBLIC` is "public" visibility

The remainder visibilities are provided for use with bitwise comparisons: `visibility & Post.Visibility.LISTED` will detect whether a post is listed or unlisted, for example.

###  Prototype methods:

####  `compare()`.

>   ```javascript
>       Laboratory.Post.prototype.compare(post);
>   ```
>
>   - __`post` :__ A `Post` to compare with

The `compare()` prototype method compares a `Post` with another and returns `true` if they have the same properties.
For efficiency, if two `Post`s have the same `id` then `compare()` will only test those properties which are likely to change.

 - - -

##  Examples  ##

>   __[Issue #53](https://github.com/marrus-sh/laboratory/issues/53) :__
>   Usage examples for constructors are forthcoming.

 - - -

##  Implementation  ##

###  The constructor:

The `Post()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.

    Laboratory.Post = Post = (data) ->

        unless this and this instanceof Post
            throw new TypeError "this is not a Post"
        unless data?
            throw new TypeError "Unable to create Post; no data provided"

We'll use the `getProfile()` function in our various account getters.

        profiles = Store.profiles
        getProfile = (id) -> profiles[id]

The `Post()` constructor can be called with either a status response or a notification one.
We can check this fairly readily by checking for the presence of the `status` attibute.
If `data` has an associated `type`, then it must be a notification.
We pull the notification data and then overwrite `data` to just show the post.

        if data.type?
            @id = data.id
            fromID = data.account.id
            if data.status
                switch data.type
                    when "reblog"
                        @type = Post.Type.REBLOG
                        Object.defineProperty this, "rebloggedBy",
                            get: getProfile.bind this, fromID
                            enumerable: yes
                    when "favourite"
                        @type = Post.Type.FAVOURITE
                        Object.defineProperty this, "favouritedBy",
                            get: getProfile.bind this, fromID
                            enumerable: yes
                    when "mention" then @type = Post.Type.MENTION
                    else @type = Post.Type.REACTION
                data = data.status
            else
                Object.defineProperty this, "author",
                    get: getProfile.bind this, fromID
                    enumerable: yes
                switch data.type
                    when "follow" then @type = Post.Type.FOLLOW
                    else @type = Post.Type.NOTIFICATION
                return Object.freeze this


If our `data` isn't a notification then we can use its `id` like normal.

        else
            @type = Post.Type.STATUS
            @id = data.id

That said, it is possible our `data` is a normal (non-notification) reblog.
In which case, we want to use the original post for extracting our data.

            if data.reblog
                Object.defineProperty this, "rebloggedBy",
                    get: getProfile.bind this, data.account.id
                    enumerable: yes
                data = data.reblog

Now we can set the rest of our properties.

        @uri = String data.uri
        @href = String data.url
        Object.defineProperty this, "author",
            get: getProfile.bind this, data.account.id
            enumerable: yes
        @inReplyTo = Number data.in_reply_to_id
        @content = String data.content
        @datetime = new Date data.created_at
        @reblogCount = Number data.reblogs_count
        @favouriteCount = Number data.favourites_count
        @isReblogged = !!data.reblogged
        @isFavourited = !!data.favourited
        @isNSFW = !!data.sensitive
        @message = String data.spoiler_text
        @visibility = {
            direct: Post.Visibility.DIRECT
            private: Post.Visibility.IN_HOME
            unlisted: Post.Visibility.UNLISTED
            public: Post.Visibility.PUBLIC
        }[data.visibility] or Post.Visibility.IN_HOME
        @mediaAttachments = (new Attachment item for item in data.media_attachments)
        @mentions = do =>
            mentions = []
            Object.defineProperty mentions, index, {
                enumerable: yes
                get: getProfile.bind(this, mention.id)
            } for mention, index in data.mentions
            return Object.freeze mentions
        @application = if data.application? then new Application data.application else null

        return Object.freeze this

###  The prototype:

The `Post` prototype has one function.

    Object.defineProperty Post, "prototype",
        value: Object.freeze

`compare` does a quick comparison between two `Post`s, and tells whether or not they are equivalent.
For efficiency's sake, if the ids of the two posts are the same, it only compares those values which should be considered mutable.

            compare: (other) ->

                return no unless this instanceof Post and other instanceof Post

                return (
                    @type is other.type and
                    @id is other.id and
                    @reblogCount is other.reblogCount and
                    @favouriteCount is other.favouriteCount and
                    @isReblogged is other.isReblogged and
                    @isFavourited is other.isFavourited
                )

###  Defining our enumerals:

Here we define our enumerals as described above.

    Post.Type = Enumeral.generate
        UNKNOWN      : 0x00
        STATUS       : 0x10
        NOTIFICATION : 0x20
        FOLLOW       : 0x21
        REACTION     : 0x30
        FAVOURITE    : 0x31
        REBLOG       : 0x32
        MENTION      : 0x33

    Post.Visibility = Enumeral.generate
        DIRECT        : 0b000
        REBLOGGABLE   : 0b001
        IN_HOME       : 0b010
        UNLISTED      : 0b011
        LISTED        : 0b100
        NOT_IN_HOME   : 0b101
        UNREBLOGGABLE : 0b110
        PUBLIC        : 0b111



- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>Constructors/Profile.litcoffee</code></p>

#  THE PROFILE CONSTRUCTOR  #

 - - -

##  Description  ##

The `Profile()` constructor creates a unique, read-only object which represents an account's profile information.
Its properties are summarized below, alongside their Mastodon API equivalents:

|     Property     |    API Response   | Description |
| :--------------: | :---------------: | :---------- |
|       `id`       |       `id`        | The id of the account |
|    `username`    |    `username`     | The account's username |
|     `account`    |  *Not provided*   | The account's username, followed by their domain |
|  `localAccount`  |      `acct`       | The account's username, followed by their domain for remote users only |
|  `displayName`   |  `display_name`   | The account's display name |
|      `bio`       |      `note`       | The account's profile bio |
|      `href`      |      `url`        | The URL for the account's profile page |
|     `avatar`     |     `avatar`      | The URL for the account's avatar |
|     `header`     |     `header`      | The URL for the account's header |
|    `isLocked`    |     `locked`      | `true` if the account is locked; `false` otherwise |
| `followerCount`  | `followers_count` | The number of accounts following the given one |
| `followingCount` | `following_count` | The number of accounts that the given one is following |
|  `statusCount`   | `statuses_count`  | The number of statuses that the given account has posted |
|  `relationship`  |  *Not provided*   | A `Laboratory.Profile.Relationship`, providing the relationship between the given account and the current user. |

###  Profile relationiships:

The available `Profile.Relationship`s are as follows:

| Enumeral | Binary Value | Description |
| :------: | :----------: | :---------- |
| `Profile.Relationship.NOT_FOLLOWING` | `00000000` | Neither the account nor the user are following each other |
| `Profile.Relationship.FOLLOWER` | `00000001` | The user is being followed by the account |
| `Profile.Relationship.FOLLOWING` | `00000010` | The account is being followed by the user |
| `Profile.Relationship.MUTUAL` | `00000011` | The user and the account are following each other |
| `Profile.Relationship.REQUESTED` | `00000100` | The user has requested to follow the account |
| `Profile.Relationship.REQUESTED_MUTUAL` | `00000101` | The account follows the user, and the user has requested to follow the account |
| `Profile.Relationship.BLOCKING` | `00001000` | The user is blocking the account |
| `Profile.Relationship.MUTING` | `00010000` | The user is muting the account |
| `Profile.Relationship.MUTING_FOLLOWER` | `00010001` | The user is muting, and being followed by, the account |
| `Profile.Relationship.MUTING_FOLLOWING` | `00010010` | The user is muting and following the account |
| `Profile.Relationship.MUTING_MUTUAL` | `00010011` | The user and the account are following each other, but the user is muting the account |
| `Profile.Relationship.MUTING_REQUESTED` | `00010100` | The user is muting the account, but has also requested to follow it |
| `Profile.Relationship.MUTING_REQUESTED_MUTUAL` | `00010101` | The user is muting, and being followed by, the accoung, but has also requested to follow it |
| `Profile.Relationship.UNKNOWN` | `01000000` | The relationship between the user and the account is unknown |
| `Profile.Relationship.SELF` | `10000000` | The account is the user |

You can use bitwise comparisons on these enumerals to test for a specific relationship status.
Of course, many combinations are not possible.

|    Flag    | Enumeral | Meaning |
| :--------: | -------- | ------- |
| `00000001` | `Profile.Relationship.FOLLOWER` | The user is followed by the account |
| `00000010` | `Profile.Relationship.FOLLOWING` | The account is followed by the user |
| `00000100` | `Profile.Relationship.REQUESTED` | The user has sent a follow request to the account |
| `00001000` | `Profile.Relationship.BLOCKING` | The user is blocking the account |
| `00010000` | `Profile.Relationship.MUTING` | The user is muting the account |
| `00100000` | _Unused_ | Reserved for later use |
| `01000000` | `Profile.Relationship.UNKNOWN` | The relationship status between the user and the account is unknown |
| `10000000` | `Profile.Relationship.SELF` | The user is the same as the account |

###  Prototype methods:

####  `compare()`.

>   ```javascript
>       Laboratory.Profile.prototype.compare(profile);
>   ```
>
>   - __`profile` :__ A `Profile` to compare with

The `profile()` prototype method compares a `Profile` with another and returns `true` if they have the same properties.

 - - -

##  Examples  ##

>   __[Issue #53](https://github.com/marrus-sh/laboratory/issues/53) :__
>   Usage examples for constructors are forthcoming.

 - - -

##  Implementation  ##

###  The constructor:

The `Profile()` constructor takes a `data` object from an API response (or another `Profile` object) and reads its attributes into an instance's properties.
Additionally, the `relationship` argument can be used to set the Profile relationship.

    Laboratory.Profile = Profile = (data, relationship) ->

        unless this and this instanceof Profile
            throw new TypeError "this is not a Profile"
        unless data?
            throw new TypeError "Unable to create Profile; no data provided"
        
If the `relationship` isn't provided, we check to see if we already have one for this id in our `Store`.

        relationship = Store.profiles[data.id]?.relationship unless relationship?

If our `data` is already a `Profile`, we can just copy its info over.

        if data instanceof Profile then {@id, @username, @account, @localAccount, @displayName,
            @bio, @href, @avatar, @header, @isLocked, @followerCount, @followingCount,
            @statusCount, @relationship} = data

Otherwise, we have to change some variable names around.

        else
            @id = Number data.id
            @username = String data.username
            @account = String data.acct + (
                if (origin = Store.auth.origin)? and "@" not in data.acct then "@" + origin
                else ""
            )
            @localAccount = String data.acct
            @displayName = String data.display_name
            @bio = String data.note
            @href = String data.url
            @avatar = String data.avatar
            @header = String data.header
            @isLocked = !!data.locked
            @followerCount = Number data.followers_count
            @followingCount = Number data.following_count
            @statusCount = Number data.statuses_count
            @relationship =
                if data.id is Store.auth.me then Profile.Relationship.SELF
                else Profile.Relationship.UNKNOWN

We set the relationship last, overwriting any previous relationship if one is provided.
This code will coerce the provided relationship into an Number and then back to an enumeral if possible.
Remember that because enumerals are objects, they will always evaluate to `true` even if their value is `0x00`.

        if relationship?
            @relationship = Profile.Relationship.fromValue(relationship) or @relationship

        return Object.freeze this

###  The prototype:

The `Profile` prototype has one function.

    Object.defineProperty Profile, "prototype",
        value: Object.freeze

`compare` does a quick comparison between two `Profile`s, and tells whether or not they are equivalent.
For efficiency's sake, it compares attributes with the most-likely-to-be-different ones first.

            compare: (other) ->

                return false unless this instanceof Profile and other instanceof Profile

                return (
                    @id is other.id and
                    @relationship is other.relationship and
                    @followerCount is other.followerCount and
                    @followingCount is other.followingCount and
                    @statusCount is other.statusCount and
                    @bio is other.bio and
                    @displayName is other.displayName and
                    @avatar is other.avatar and
                    @header is other.header and
                    @isLocked is other.isLocked and
                    @username is other.username and
                    @localAccount is other.localAccount and
                    @account is other.account and
                    @href is other.href
                )

###  Defining profile relationships:

Here we define profile relationships, as specified above.

    Profile.Relationship = Enumeral.generate
        NOT_FOLLOWING           : 0b00000000
        FOLLOWER                : 0b00000001
        FOLLOWING               : 0b00000010
        MUTUAL                  : 0b00000011
        REQUESTED               : 0b00000100
        REQUESTED_MUTUAL        : 0b00000101
        BLOCKING                : 0b00001000
        MUTING                  : 0b00010000
        MUTING_FOLLOWER         : 0b00010001
        MUTING_FOLLOWING        : 0b00010010
        MUTING_MUTUAL           : 0b00010011
        MUTING_REQUESTED        : 0b00010100
        MUTING_REQUESTED_MUTUAL : 0b00010101
        UNKNOWN                 : 0b01000000
        SELF                    : 0b10000000


- - -

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


- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>Constructors/Rolodex.litcoffee</code></p>

#  THE ROLODEX CONSTRUCTOR  #

 - - -

##  Description  ##

The `Rolodex()` constructor creates a unique, read-only object which represents a list of [`Profile`](Profile.litcoffee)s.
Its properties are summarized below, alongside their Mastodon API equivalents:

|  Property  |  API Response  | Description |
| :--------: | :------------: | :---------- |
| `profiles` | [The response] | An ordered array of profiles, in reverse-chronological order |
|  `length`  | *Not provided* | The length of the `Rolodex` |

###  Rolodex types:

The possible `Rolodex.Type`s are as follows:

>   __[Issue #18](https://github.com/marrus-sh/laboratory/issues/18) :__
>   There should also be a follow-request rolodex.

| Enumeral | Hex Value | Description |
| :------: | :----------: | :---------- |
| `Rolodex.Type.UNDEFINED` | `0x00` | No type is defined |
| `Rolodex.Type.SEARCH` | `0x10` | A search of profiles |
| `Rolodex.Type.FOLLOWERS` | `0x21` | The followers of an account |
| `Rolodex.Type.FOLLOWING` | `0x22` | Those an account is following |
| `Rolodex.Type.FAVOURITED_BY` | `0x41` | Those who favourited a given status |
| `Rolodex.Type.REBLOGGED_BY` | `0x45` | Those who reblogged a given status |
| `Rolodex.Type.BLOCKS` | `0x83` | Those who have been blocked |
| `Rolodex.Type.MUTES` | `0x84` | Those who have been muted |
| `Rolodex.Type.FOLLOW_REQUESTS` | `0x86` | Those who have requested to follow the user |

###  Prototype methods:

####  `join()`.

>   ```javascript
>       Laboratory.Rolodex.prototype.join(data);
>   ```
>
>   - __`data` :__ A `Profile`, array of `Profile`s, or a `Rolodex`

The `join()` prototype method joins the `Profile`s of a `Rolodex` with that of the provided `data`, and returns a new `Rolodex` of the results.

####  `remove()`.

>   ```javascript
>       Laboratory.Rolodex.prototype.remove(data);
>   ```
>
>   - __`data` :__ A `Profile`, array of `Profile`s, or a `Rolodex`

The `remove()` prototype method collects the `Profile`s of a `Rolodex` except for those of the provided `data`, and returns a new `Rolodex` of the results.

 - - -

##  Examples  ##

>   __[Issue #53](https://github.com/marrus-sh/laboratory/issues/53) :__
>   Usage examples for constructors are forthcoming.

 - - -

##  Implementation  ##

###  The constructor:

The `Rolodex()` constructor takes a `data` object and uses it to construct a rolodex.
`data` can be either an API response or an array of `Profile`s.

    Laboratory.Rolodex = Rolodex = (data) ->

        unless this and this instanceof Rolodex
            throw new TypeError "this is not a Rolodex"
        unless data?
            throw new TypeError "Unable to create Rolodex; no data provided"

We'll use the `getProfile()` function in our profile getters.

        getProfile = (id) -> Store.profiles[id]

We sort our data according to their ids.

        data.sort (first, second) -> second.id - first.id

The following loop removes any duplicates from our `data`.

        prev = null
        if data.length > 0 then for index in [data.length - 1 .. 0]
            currentID = (current = data[index]).id
            if prev? and currentID is prev.id
                data.splice index, 1
                continue
            prev = current

Finally, we implement our list of `profiles` as getters such that they always return the most current data.
**Note that this will likely prevent optimization of the `profiles` array, so it is recommended that you make a static copy (using `Array.prototype.slice()` or similar) before doing intensive array operations with it.**

>   __[Issue #28](https://github.com/marrus-sh/laboratory/issues/28) :__
>   At some point in the future, `Rolodex` might instead be implemented using a linked list.

        @profiles = []
        Object.defineProperty @profiles, index, {
            enumerable: yes
            get: getProfile.bind(this, value.id)
        } for value, index in data
        Object.freeze @profiles

        @length = data.length

        return Object.freeze this

###  The prototype:

The `Rolodex` prototype has two functions.

    Object.defineProperty Rolodex, "prototype",
        value: Object.freeze

####  `join()`.

The `join()` function creates a new `Rolodex` which combines the `Profile`s of the original and the provided `data`.
Its `data` argument can be either a `Profile`, an array thereof, or a `Rolodex`.
We don't have to worry about duplicates here because the `Rolodex()` constructor should take care of them for us.

            join: (data) ->
                return this unless data instanceof Profile or data instanceof Array or
                    data instanceof Rolodex
                combined = profile for profile in switch
                    when data instanceof Profile then [data]
                    when data instanceof Rolodex then data.profiles
                    else data
                combined.push profile for profile in @profiles
                return new Rolodex combined

####  `remove()`.

The `remove()` function returns a new `Rolodex` with the provided `Profile`s removed.
Its `data` argument can be either a `Profile`, an array thereof, or a `Rolodex`.

            remove: (data) ->
                return this unless data instanceof Profile or data instanceof Array or
                    data instanceof Rolodex
                redacted = (profile for profile in @profiles)
                redacted.splice index, 1 for profile in (
                    switch
                        when data instanceof Profile then [data]
                        when data instanceof Rolodex then data.profiles
                        else data
                ) when (index = redacted.indexOf profile) isnt -1
                return new Rolodex redacted

###  Defining rolodex types:

Here we define our `Rolodex.Type`s, as described above:

>   __[Issue #18](https://github.com/marrus-sh/laboratory/issues/18) :__
>   There should also be a follow-request rolodex.

    Rolodex.Type = Enumeral.generate
        UNDEFINED       : 0x00
        SEARCH          : 0x10
        FOLLOWERS       : 0x21
        FOLLOWING       : 0x22
        FAVOURITED_BY   : 0x41
        REBLOGGED_BY    : 0x45
        BLOCKS          : 0x83
        MUTES           : 0x84
        FOLLOW_REQUESTS : 0x86


- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>Constructors/Timeline.litcoffee</code></p>

#  THE TIMELINE CONSTRUCTOR  #

 - - -

##  Description  ##

The `Timeline()` constructor creates a unique, read-only object which represents a Mastodon timeline.
Its properties are summarized below, alongside their Mastodon API equivalents:

| Property  |  API Response  | Description |
| :-------: | :------------: | :---------- |
|  `posts`  | [The response] | An ordered array of posts in the timeline, in reverse-chronological order |
| `length`  | *Not provided* | The length of the timeline |

###  Timeline types:

The possible `Timeline.Type`s are as follows:

| Enumeral | Hex Value | Description |
| :------: | :----------: | :---------- |
| `Timeline.Type.UNDEFINED` | `0x00` | No type is defined |
| `Timeline.Type.PUBLIC` | `0x10` | A public timeline |
| `Timeline.Type.HOME` | `0x20` | A user's home timeline |
| `Timeline.Type.NOTIFICATIONS` | `0x21` | A user's notifications |
| `Timeline.Type.FAVOURITES` | `0x22` | A list of a user's favourites |
| `Timeline.Type.ACCOUNT` | `0x40` | A timeline of an account's posts |
| `Timeline.Type.HASHTAG` | `0x80` | A hashtag search |

###  Prototype methods:

####  `join()`.

>   ```javascript
>       Laboratory.Timeline.prototype.join(data);
>   ```
>
>   - __`data` :__ A `Post`, array of `Post`s, or a `Timeline`

The `join()` prototype method joins the `Post`s of a timeline with that of the provided `data`, and returns a new `Timeline` of the results.

####  `remove()`.

>   ```javascript
>       Laboratory.Timeline.prototype.remove(data);
>   ```
>
>   - __`data` :__ A `Post`, array of `Post`s, or a `Timeline`

The `remove()` prototype method collects the `Post`s of a timeline except for those of the provided `data`, and returns a new `Timeline` of the results.

 - - -

##  Examples  ##

>   __[Issue #53](https://github.com/marrus-sh/laboratory/issues/53) :__
>   Usage examples for constructors are forthcoming.

 - - -

##  Implementation  ##

###  The constructor:

The `Timeline()` constructor takes a `data` object and uses it to construct a timeline.
`data` can be either an API response or an array of `Post`s.

    Laboratory.Timeline = Timeline = (data) ->

        unless this and this instanceof Timeline
            throw new TypeError "this is not a Timeline"
        unless data?
            throw new TypeError "Unable to create Timeline; no data provided"

Mastodon keeps track of ids for notifications separately from ids for posts, as best as I can tell, so we have to verify that our posts are of matching type before proceeding.
Really all we care about is whether the posts are notifications, so that's all we test.

        isNotification = (object) -> !!(
            (
                switch
                    when object instanceof Post then object.type
                    when object.type? then Post.Type.NOTIFICATION  #  This is an approximation
                    else Post.Type.STATUS
            ) & Post.Type.NOTIFICATION
        )

We'll use the `getPost()` function in our post getters.

        getPost = (id, isANotification) ->
            if isANotification then Store.notifications[id] else Store.statuses[id]

We sort our data according to when they were created, unless two posts were created at the same time.
Then we use their ids.

>   __Note :__
>   Until/unless Mastodon starts assigning times to notifications, there are a few (albeit extremely unlikely) edge-cases where the following `sort()` function will cease to be well-defined.
>   Regardless, attempting to create a timeline out of both notifications and statuses will likely result in a very odd sorting.

        data.sort (first, second) ->
            if not (isNotification first) and not (isNotification second) and (
                a = Number first instanceof Post and first.datetime or Date first.created_at
            ) isnt (
                b = Number second instanceof Post and second.datetime or Date second.created_at
            ) then -1 + 2 * (a > b) else second.id - first.id

Next we walk the array and look for any duplicates, removing them.

>   __Note :__
>   Although `Timeline()` purports to remove all duplicate `Post`s, this behaviour is only guaranteed for *contiguous* `Post`s—given our sort algorithm, this means posts whose `datetime` values are also the same.
>   If the same post ends up sorted to two different spots, `Timeline()` will leave both in place.
>   (Generally speaking, if you find yourself with two posts with identical `id`s but different `datetime`s, this is a sign that something has gone terribly wrong.)

        prev = null
        if data.length > 0 then for index in [data.length - 1 .. 0]
            currentID = (current = data[index]).id
            if prev? and currentID is prev.id and
                (isNotification prev) is (isNotification current)
                    data.splice index, 1
                    continue
            prev = current

Finally, we implement our list of `posts` as getters such that they always return the most current data.
**Note that this will likely prevent optimization of the `posts` array, so it is recommended that you make a static copy (using `Array.prototype.slice()` or similar) before doing intensive array operations with it.**

>   __[Issue #28](https://github.com/marrus-sh/laboratory/issues/28) :__
>   At some point in the future, `Timeline` might instead be implemented using a linked list.

        @posts = []
        Object.defineProperty @posts, index, {
            enumerable: yes
            get: getPost.bind(this, value.id, isNotification value)
        } for value, index in data
        Object.freeze @posts

        @length = data.length

        return Object.freeze this

###  The prototype:

The `Timeline` prototype has two functions.

    Object.defineProperty Timeline, "prototype",
        value: Object.freeze

####  `join()`.

The `join()` function creates a new `Timeline` which combines the `Post`s of the original and the provided `data`.
Its `data` argument can be either a `Post`, an array thereof, or a `Timeline`.
We don't have to worry about duplicates here because the `Timeline()` constructor should take care of them for us.

            join: (data) ->
                return this unless data instanceof Post or data instanceof Array or
                    data instanceof Timeline
                combined = post for post in switch
                    when data instanceof Post then [data]
                    when data instanceof Timeline then data.posts
                    else data
                combined.push post for post in @posts
                return new Timeline combined

####  `remove()`.

The `remove()` function returns a new `Timeline` with the provided `Post`s removed.
Its `data` argument can be either a `Post`, an array thereof, or a `Timeline`.

            remove: (data) ->
                return this unless data instanceof Post or data instanceof Array or
                    data instanceof Timeline
                redacted = (post for post in @posts)
                redacted.splice index, 1 for post in (
                    switch
                        when data instanceof Post then [data]
                        when data instanceof Timeline then data.posts
                        else data
                ) when (index = redacted.indexOf post) isnt -1
                return new Timeline redacted

###  Defining timeline types:

Here we define our `Timeline.Type`s, as described above:

    Timeline.Type = Enumeral.generate
        UNDEFINED     : 0x00
        PUBLIC        : 0x10
        HOME          : 0x20
        NOTIFICATIONS : 0x21
        FAVOURITES    : 0x22
        ACCOUNT       : 0x40
        HASHTAG       : 0x80


- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>API/README.litcoffee</code></p>

#  LABORATORY API  #

 - - -

##  Description  ##

Laboratory does not give you direct access to the information it receives from a Mastodon server.
Instead, it makes this information available through the __Laboratory API,__ which is documented here.
This page will provide the basics on the API and how it works, and then direct you to further resources for specific components.

The Laboratory API is split up into two parts, both of which you will need a basic understanding of in order to use the script.
These are the __Event API__ and the __Request API__.
Generally speaking, you will use the Event API to initialize your scripts and create Laboratory extensions, while you will use the Request API for making API requests and retreiving information.

###  Understanding the Event API:

In order to understand Laboratory's Event API, you first need to understand how Laboratory stores its data.
All of the information that Laboratory receives and keeps track of from a Mastodon server is kept within a single central __store__, which is essentially just a large JavaScript object.
The idea of a central store might be familiar to you if you've used systems like Redux before.

However, unlike with Redux, many areas of Laboratory's store are left fully mutable.
This means that the store can be quickly modified in-place to add and remove data.
However, it also means that, in order to maintain the sanctity of its data, the Laboratory store can't be exposed to the public view.
**Laboratory's store is declared inside of a closure for which there is no external access.**
The only functions which are allowed to modify the Laboratory store are a collection of __Laboratory Event Handlers__ (colloquially, just "handlers"), which listen for Laboratory-specific events dispatched to the `document`.

The only means outside programs have to interact with the Laboratory store is then through a series of pre-defined __Laboratory Events__, which can be issued, listened for, and logged by external parties.
The Laboratory Event API describes these events and their function.

####  What events do, and why they are needed.

Laboratory events generally serve two main purposes:

1.  They provide new information to the Laboratory store
2.  They inform Laboratory scripts and extensions that the information has been updated

When a `Profile`, `Post`, `Timeline`, or `Rolodex` is received, events are dispatched containing all the `Profile`s and `Post`s that were created during the process.
This means that, if a `Timeline.Request` discovers that a user's avatar has changed, a `Profile.Request` that is listening for updates will be able to detect the change and update its value accordingly.
Clients can also create and dispatch their own events (for example, to insert custom notifications into a user's Notifications timeline); however, at the moment this functionality is somewhat limited.

####  Creating, issuing, and listening for Laboratory Events.

Laboratory Events are implemented as DOM `CustomEvents`.
Consequently, each event has just two pieces of information that you need to account for: its `type`, which identifies the event, and its `detail`, which is an object holding the event's data.
Every Laboratory Event will have a `detail` which is an immutable object.

Laboratory events are dispatched to the `document` and can be listened for using `document.addEventListener()`.
The `dispatch()` function has been created to make dispatching Laboratory events easier, and it is __strongly recommended__ that you use it instead of, say, `document.dispatchEvent()`.
`dispatch()` will automatically handle `CustomEvent` creation and `detail` assignment, and will fill in default values as necessary for the events you dispatch.
For example, the following code will dispatch a `LaboratorySomeEvent` event for you:

>   ```javascript
>   Laboratory.dispatch("LaboratorySomeEvent", detail);
>   ```

####  Event details.

Dispatching most events requires calling `Laboratory.dispatch()` with not only a string specifying the event, but also a `detail`, which is an object containing additional event information.
Generally, the type of this object is provided in its name: `LaboratoryProfileReceived`, for example, requires a `detail` which is a `Profile`.
When listening for events, the `detail` property on the event can be used to access this data.

###  Understanding the Request API:

Constantly calling, listening for, and handling events can get tedious, so Laboratory also comes with a Request API.
Generally speaking, using this API means following these basic steps:

1.  Create a new `Request` object, for example by calling `new Laboratory.Post.Request()`
2.  Associate the `Request` with a callback using `request.assign()`
3.  Send the request using `request.start()`

Every `Request` object has `start()` and `stop()` methods which can be used to send and cancel the request.
In order to prevent memory leaks, it is recommended that you always call `stop()` when you are done with a `Request`.
However, this is only required if the `Request` you are using is listening for live updates.

The first argument of a `Request()` constructor is always a `data` object whose properties further clarify the request.
The specifics of this object depends on the kind of `Request` you are trying to make.
Some `Request`s take further arguments, so be sure to consult the documentation.
However, only the `data` object is ever required.

###  API reference:

The Laboratory API is broken up into several __modules__, each of which is documented within its source.
These are as follows:

- [__Initialization__](Initialization.litcoffee)
- [__Request__](Request.litcoffee)
- [__Client__](Client.litcoffee)
- [__Authorization__](Authorization.litcoffee)
- [__Profile__](Profile.litcoffee)
- [__Rolodex__](Rolodex.litcoffee)
- [__Attachment__](Attachment.litcoffee)
- [__Post__](Post.litcoffee)
- [__Timeline__](Timeline.litcoffee)

 - - -

##  Examples  ##

###  Listening for `LaboratoryInitializationReady`:

>   ```javascript
>   document.addEventListener("LaboratoryInitializationReady", callback);
>   ```

###  Requesting authorization:

>   ```javascript
>   request = Laboratory.Authorization.Request({
>       origin: "https://myinstance.social",
>       name: "My Laboratory Client",
>       redirect: "/",
>       scope: Laboratory.Authorization.READWRITEFOLLOW
>   });
>   request.assign(callback);
>   request.send();
>   ```

 - - -

##  Implementation  ##

###  Event processing:

There is a fair amount that goes on behind-the-scenes to make Laboratory events easy to dispatch and listen for.
Roughly speaking, we have to:

1.  Keep a record of all accepted Laboratory events.
2.  Specify what is expected of an event's `detail`, and give default values
3.  Associate our handlers with events and keep track of them for later
4.  Create the `dispatch()` function to dispatch events

For simplicity's sake, we will store our events inside an object called `LaboratoryEvent`, whose methods will greatly ease this process.
`LaboratoryEvent` won't be exposed to the window, it's just for our own internal use.

    LaboratoryEvent =

        Events: {}
        Handlers: []

####  Adding new events.

The `LaboratoryEvent.create()` function registers a new event and associates it with a `detail`.
If the provided `detail` is an object, then its own properties will determine the allowed and default properties of the event's detail; if it is a constructor, then the provided detail must be an instance (or `null`).

        create: (type, detail) ->
            LaboratoryEvent.Events[type] = Object detail unless LaboratoryEvent.Events[type]?
            return LaboratoryEvent

####  Setting up handlers.

The `LaboratoryEvent.handle()` function just associates a `type` with a `callback`.
It sets things up so we can easily add our handlers later.

>   __Note :__
>   The `handle()` function directly modifies and stores its `callback` argument, which would definitely be a no-go if we were exposing it to outsiders.
>   It saves us having to wrap the callback in an object or, worse, yet another function though, so let's just treat it responsibly and keep this between us.

        handle: (type, callback) ->
            return LaboratoryEvent unless LaboratoryEvent.Events[type = String type]?
            callback.type = type
            LaboratoryEvent.Handlers.push callback
            return LaboratoryEvent

####  Dispatching events.

We can now create our `dispatch()` function.
It just sets up our detail and dispatches the event to `document`.

>   __[Issue #30](https://github.com/marrus-sh/laboratory/issues/30) :__
>   Event dispatching may be metered in the future.

    Laboratory.dispatch = dispatch = (event, props) ->
        return no unless (initials = LaboratoryEvent.Events[event = String event])?
        if typeof initials is "function"
            return no unless (detail = props) instanceof initials
        else if props?
            detail = {}
            for prop, initial of initials
                detail[prop] = if props[prop]? then props[prop] else initial
            Object.freeze detail
        document.dispatchEvent new CustomEvent event, {detail}
        return yes


- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>API/Attachment.litcoffee</code></p>

#  ATTACHMENT REQUESTS  #

 - - -

##  Description  ##

The __Attachment__ module of the Laboratory API is comprised of those requests which are related to Mastodon media attachments.

###  Quick reference:

####  Requests.

| Request | Description |
| :------ | :---------- |
| `Attachment.Request()` | Requests a media attachment from the Mastodon server. |

###  Requesting an attachment:

>   ```javascript
>   request = new Laboratory.Attachment.Request(data);
>   ```
>
>   - __API equivalent :__ `/api/v1/media`
>   - __Data parameters :__
>       - __`file` :__ The file to upload
>   - __Response :__ An [`Attachment`](../Constructors/Attachment.litcoffee)

Laboratory Attachment requests are used to upload files to the server and receive media `Attachment`s which can then be linked to posts.
The only relevant parameter is `file`, which should be the `File` to upload.

 - - -

##  Examples  ##

###  Uploading an attachment to the Mastodon server:

>   ```javascript
>   //  Suppose `myAttachment` is a `File`.
>   var request = new Laboratory.Attachment.Request({
>       file: myAttachment
>   });
>   request.assign(requestCallback);
>   request.start();
>   ```

###  Using the result of an Attachment request:

>   ```javascript
>   function requestCallback(event) {
>       useAttachment(event.response);
>   }
>   ```

 - - -

##  Implementation  ##

###  Making the request:

    Object.defineProperty Attachment, "Request",
        configurable: no
        enumerable: yes
        writable: no
        value: do ->

            AttachmentRequest = (data) ->

Our first order of business is checking that we were provided a `File` and that `FormData` is supported on our platform.
If not, that's a `TypeError`.

                unless this and this instanceof AttachmentRequest
                    throw new TypeError "this is not an AttachmentRequest"
                unless typeof File is "function" and (file = data.file) instanceof File
                    throw new TypeError "Unable to create attachment; none provided"
                unless typeof FormData is "function"
                    throw new TypeError "Unable to create attachment; `FormData` not supported"

We create a new `form` and add the `file` to it.
This will be directly uploaded to the server during the request.

                form = new FormData
                form.append "file", file

Here we create the request.

                Request.call this, "POST", Store.auth.origin + "/api/v1/media", form,
                    Store.auth.accessToken, (result) =>
                        dispatch "LaboratoryAttachmentReceived", decree =>
                            @response = police -> new Attachment result

                Object.freeze this

Our `Attachment.Request.prototype` just inherits from `Request`.

            Object.defineProperty AttachmentRequest, "prototype",
                configurable: no
                enumerable: no
                writable: no
                value: Object.freeze Object.create Request.prototype,
                    constructor:
                        enumerable: no
                        value: AttachmentRequest

            return AttachmentRequest


- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>API/Authorization.litcoffee</code></p>

#  AUTHORIZATION REQUESTS  #

 - - -

##  Description  ##

The __Authorization__ module of the Laboratory API is comprised of those requests which are related to OAuth registration of the Laboratory client with the Mastodon server.

###  Quick reference:

####  Requests.

| Request | Description |
| :------ | :---------- |
| `Authorization.Request()` | Requests authorization from the Mastodon server. |

####  Events.

| Event | Description |
| :---- | :---------- |
| `LaboratoryAuthorizationReceived` | Fires when an access token has been received from the OAuth server |

>   __[Issue #50](https://github.com/marrus-sh/laboratory/issues/50) :__
>   Authorization events may not fire in the future.

###  Requesting authorization:

>   ```javascript
>   request = new Laboratory.Authorization.Request(data);
>   ```
>
>   - __API equivalent :__ `/oauth/token`, `/api/v1/verify_credentials`
>   - __Data parameters :__
>       - __`name` :__ The name of the client application (default: `"Laboratory"`)
>       - __`origin` :__ The location of the Mastodon server (default: `"/"`)
>       - __`redirect` :__ The base url for the application (default: `""`)
>       - __`scope` :__ An `Authorization.Scope` (default: `Authorization.Scope.READ`)
>       - __`accessToken` :__ If provided, Laboratory should attempt to use the given access token instead of fetching a new one of its own.
>   - __Response :__ An [`Authorization`](../Constructors/Authorization.litcoffee)

`Authorization.Request()` is used to request an access token for use with OAuth.
This will likely be the first request you make when interacting with Laboratory.
This data will be made available through the `Laboratory` object, so you probably don't need to keep track of its response yourself.

The OAuth request for authorization needs to take place in a separate window; you can specify this by passing it as an argument to `request.start()`.
If unspecified, Laboratory will try to open a window on its own (named `LaboratoryOAuth`); note that popup blockers will likely block this though.
You don't need to specify a `window` if you're passing through an `accessToken`.

 - - -

##  Examples  ##

###  Getting authorization:

>   ```javascript
>   function requestCallback(event) {
>       if (event.response instanceof Laboratory.Authorization) startMyApplication();
>   }
>
>   var request = new Laboratory.Authorization.Request({
>       name: "My Application",
>       origin: "https://myinstance.social",
>       redirect: "/",
>       scope: Laboratory.Authorization.Scope.READWRITEFOLLOW
>   });
>   request.assign(requestCallback);
>   request.start(authWindow);
>   ```

###  Using a predetermined access token:

>   ```javascript
>   function requestCallback(event) {
>       if (event.response instanceof Laboratory.Authorization) startMyApplication();
>   }
>
>   var request = new Laboratory.Authorization.Request({
>       origin: "https://myinstance.social",
>       accessToken: myAccessToken
>       scope: Laboratory.Authorization.Scope.READWRITEFOLLOW
>   });
>   request.assign(requestCallback);
>   request.start();
>   ```

 - - -

##  Implementation  ##

###  Making the request:

This code is very complex because OAuth is very complex lol.
It is split among a number of functions because it depends on several asynchronous calls.

    Object.defineProperty Authorization, "Request",
        configurable: no
        enumerable: yes
        writable: no
        value: do ->

####  Stopping an existing request.

The `stopRequest()` function closes out of any existing request.
We explicitly return nothing because `stopRequest` is actually made transparent to the window.

            stopRequest = ->

                unless this?.currentRequest instanceof Authorization.Request
                    throw new TypeError "No defined AuthorizationRequest"

                do @wrapup if typeof @wrapup is "function"
                do @waitingRequest.stop if typeof @waitingRequest?.stop is "function"
                do @window.close if @window instanceof Window
                @waitingRequest = @callback = @window = undefined
                return

####  Starting a new request.

The `startRequest()` function starts a new request.
Its `this` value is an object which contains the request parameters and will get passed along the entire request.

            startRequest = (window) ->

                unless this?.currentRequest instanceof Authorization.Request
                    throw new TypeError "No defined AuthorizationRequest"
                do @currentRequest.stop
                @window = window if window? and not window.closed

We can only make our request once we have been registered as a client.
Laboratory stores its client and authorization data in `localStorage`.
Here we try to access that data if present:

                [storedRedirect, @clientID, @clientSecret, storedScope, storedAccessToken] =
                    if localStorage?.getItem "Laboratory | " + @origin
                        (localStorage.getItem "Laboratory | " + @origin).split " ", 5
                    else []

If we have an access token which supports our `scope` then we can immediately try using it.
We'll just forward it to `finishRequest()`.
It is important that we `return` here or else we'll end up requesting another token anyway.

                if (accessToken = @accessToken) or (accessToken = storedAccessToken) and
                    (@scope & storedScope) is +@scope
                        finishRequest.call this,
                            access_token: accessToken
                            created_at: NaN
                            scope: (
                                scopeList = []
                                scopeList.push "read" if @scope & Authorization.Scope.READ
                                scopeList.push "write" if @scope & Authorization.Scope.WRITE
                                scopeList.push "follow" if @scope & Authorization.Scope.FOLLOW
                                scopeList.join " "
                            )
                            token_type: "bearer"
                        return

If we have client credentials and they are properly associated with our `redirect` and `scope`, we can go ahead and `makeRequest()`.

                if storedRedirect is @redirect and (@scope & storedScope) is +@scope and
                    @clientID and @clientSecret then makeRequest.call this

Otherwise, we need to get new client credentials before proceeding.

                else

                    handleClient = (request) =>
                        return unless (client = request.response) instanceof Client and
                            @currentRequest and client.origin is @origin and
                            (@scope & client.scope) is +@scope and client.redirect is @redirect and
                            client.clientID and client.clientSecret
                        [@clientID, @clientSecret] = [client.clientID, client.clientSecret]
                        localStorage.setItem "Laboratory | " + @origin, [
                            client.redirect,
                            client.clientID,
                            client.clientSecret,
                            +client.scope
                        ].join " "
                        clearTimeout timeout
                        @wrapup = undefined
                        do @waitingRequest.stop
                        @waitingRequest.remove handleClient
                        makeRequest.call this

                    @waitingRequest = new Client.Request {@name, @origin, @redirect, @scope}

                    @waitingRequest.assign handleClient
                    @wrapup = => @waitingRequest.remove handleClient
                    do @waitingRequest.start

If we aren't able to acquire a client ID within 30 seconds, we timeout.

                    timeout = setTimeout (
                        =>
                            do @currentRequest.stop
                            do @waitingRequest.stop
                            decree => @response = police ->
                                new Failure "Unable to authorize client"
                    ), 30000

Again, we have to explicitly return nothing because the window can see us.

                return

####  Requesting a token.

The `makeRequest()` function will request our token once we acquire a client id and secret.
Of course, it is possible that we already have these.

            makeRequest = ->

                unless this?.currentRequest instanceof Authorization.Request
                    throw new TypeError "No defined AuthorizationRequest"

The actual token requesting takes place after authorization has been granted by the popup window (see the script at the beginning of [README](../README.litcoffee)); but we open it up here.

>   __Note :__
>   This window **will be blocked** by popup blockers unless it has already been opened previously in response to a click or keyboard event.

                location = @origin + "/oauth/authorize?" + (
                    (
                        (encodeURIComponent key) + "=" + (encodeURIComponent value) for key, value of {
                            client_id: @clientID
                            response_type: "code"
                            redirect_uri: @redirect
                            scope: (
                                scopeList = []
                                scopeList.push "read" if @scope & Authorization.Scope.READ
                                scopeList.push "write" if @scope & Authorization.Scope.WRITE
                                scopeList.push "follow" if @scope & Authorization.Scope.FOLLOW
                                scopeList.join " "
                            )
                        }
                    ).join "&"
                )
                if @window then @window.location = location
                else @window = window.open location, "LaboratoryOAuth"

Now we wait for a message from the popup window containing its key.

                callback = (event) =>
                    return unless event.source is @window and event.origin is window.location.origin
                    getToken.call this, event.data
                    do event.source.close
                    @window = null
                    @wrapup = undefined
                    window.removeEventListener "message", callback
                    callback = undefined

                window.addEventListener "message", callback
                @wrapup = -> window.removeEventListener "message", callback

####  Getting an access token.

The `getToken()` function takes a code received from a Laboratory popup and uses it to request a new access token from the server.

            getToken = (code) ->

                unless this?.currentRequest instanceof Authorization.Request
                    throw new TypeError "No defined AuthorizationRequest"

                do @waitingRequest.stop if typeof @waitingRequest?.stop is "function"

                do (
                    @waitingRequest = new Request "POST", @origin + "/oauth/token", {
                        client_id: @clientID
                        client_secret: @clientSecret
                        redirect_uri: @redirect
                        grant_type: "authorization_code"
                        code: code
                    }, null, finishRequest.bind this
                ).start

####  Finishing the request.

The `finishRequest()` function takes the server response from a token request and uses it to verify our token, and complete our authorization request.
During verification, the Mastodon server will provide us with the current user's data, which we will dispatch via a `LaboratoryProfileReceived` event to our store.

            finishRequest = (result) ->

                unless this?.currentRequest instanceof Authorization.Request
                    throw new TypeError "No defined AuthorizationRequest"

                do @waitingRequest.stop if typeof @waitingRequest?.stop is "function"
                location = @origin + "/api/v1/accounts/verify_credentials"
                @accessToken = String result.access_token

                do (
                    @waitingRequest = new Request "GET", location, null, @accessToken, (mine) =>
                        decree => @currentRequest.response = police =>
                            new Authorization result, @origin, mine.id
                        dispatch "LaboratoryAuthorizationReceived", @currentRequest.response
                        localStorage.setItem "Laboratory | " + @origin, [
                            @redirect
                            @clientID
                            @clientSecret
                            Authorization.Scope.READ *
                                ("read" in (scopes = result.scope.split /[\s\+]+/g)) +
                                Authorization.Scope.WRITE * ("write" in scopes) +
                                Authorization.Scope.FOLLOW * ("follow" in scopes)
                            @accessToken
                        ].join " "
                        dispatch "LaboratoryProfileReceived", new Profile mine
                        do @currentRequest.stop
                ).start

####  Defining the `Authorization.Request()` constructor.

            AuthorizationRequest = (data) ->

                unless this and this instanceof AuthorizationRequest
                    throw new TypeError "this is not an AuthorizationRequest"

If we weren't provided with a scope, we'll default to `READ`.
We store all our provided properties in an object called `recalled`, which we will pass along our entire request.

                recalled =
                    currentRequest: this
                    waitingRequest: undefined
                    callback: undefined
                    scope:
                        if data.scope instanceof Authorization.Scope then data.scope
                        else Authorization.Scope.READ
                    name: if data.name? then String data.name else "Laboratory"
                    accessToken:
                        if data.accessToken? then String data.accessToken
                        else undefined
                    window: undefined
                    clientID: undefined
                    clientSecret: undefined

We need to do some work to normalize our origin and get our final redirect URI.

                    origin: (
                        a = document.createElement "a"
                        a.href = data.origin or "/"
                        a.origin
                    )
                    redirect: (
                        a.href = data.redirect or ""
                        a.href
                    )

We now set up our `Request()`—although we won't actually use it to talk to the server.
Instead, the `start()` and `stop()` functions will handle this.

                Request.call this

                Object.defineProperties this,
                    start:
                        enumerable: no
                        value: startRequest.bind recalled
                    stop:
                        enumerable: no
                        value: stopRequest.bind recalled

                Object.freeze this

Our `Authorization.Request.prototype` just inherits from `Request`.

            Object.defineProperty AuthorizationRequest, "prototype",
                configurable: no
                enumerable: no
                writable: no
                value: Object.freeze Object.create Request.prototype,
                    constructor:
                        enumerable: no
                        value: AuthorizationRequest

            return AuthorizationRequest

###  Creating the events:

Here we create the events as per our specifications.

>   __[Issue #50](https://github.com/marrus-sh/laboratory/issues/50) :__
>   Authorization events may not fire in the future.

        LaboratoryEvent

            .create "LaboratoryAuthorizationReceived", Authorization

###  Handling the events:

Laboratory provides handlers for the following Authorization events:

- `LaboratoryAuthorizationReceived`

####  `LaboratoryAuthorizationReceived`.

The `LaboratoryAuthorizationReceived` handler just saves the provided `Authorization` to the `Store`.
It also exposes it to the window through `Exposed`.

>   __[Issue #36](https://github.com/marrus-sh/laboratory/issues/36) :__
>   Right now Laboratory is only set up to allow one active signin at a given time.
>   This may change in the future.

            .handle "LaboratoryAuthorizationReceived", (event) ->
                if event.detail instanceof Authorization
                    do reset
                    Exposed.auth = Store.auth = event.detail


- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>API/Client.litcoffee</code></p>

#  CLIENT REQUESTS  #

 - - -

##  Description  ##

The __Client__ module of the Laboratory API is comprised of those requests which are related to the OAuth registration of the Laboratory client with the Mastodon server.
You shouldn't typically need to interact with this module directly.

###  Quick reference:

####  Requests.

| Request | Description |
| :------ | :---------- |
| `Client.Request()` | Requests authorization from the Mastodon server. |

####  Events.

| Event | Description |
| :---- | :---------- |
| `LaboratoryClientReceived` | Fires when a client id and secret have been received from the OAuth server |

>   __[Issue #50](https://github.com/marrus-sh/laboratory/issues/50) :__
>   Client events may not fire in the future.

###  Requesting a client:

>   ```javascript
>   request = new Laboratory.Client.Request(data);
>   ```
>
>   - __API equivalent :__ `/api/v1/apps`
>   - __Data parameters :__
>       - __`name` :__ The name of the client application (default: `"Laboratory"`)
>       - __`origin` :__ The location of the Mastodon server (default: `"/"`)
>       - __`redirect` :__ The base url for the application (default: `""`)
>       - __`scope` :__ A `Laboratory.Authorization.Scope` (default: `Laboratory.Authorization.Scope.READ`)
>   - __Response :__ A [`Client`](../Constructors/Client.litcoffee)

`Client.Request()` requests a new client id for use with OAuth.
Laboratory will fire this event automatically as necessary during its operation of `Authorization.Request()`, so this isn't something you usually need to worry about.
However, you can request this yourself if you find yourself needing new client authorization.

 - - -

##  Examples  ##

###  Requesting client authorization:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the response
>   }
>
>   var request = new Laboratory.Client.Request({
>       name: "My Application",
>       origin: "https://myinstance.social",
>       redirect: "/",
>       scope: Laboratory.Authorization.Scope.READWRITEFOLLOW
>   });
>   request.assign(requestCallback);
>   request.start();
>   ```

 - - -

##  Implementation  ##

###  Making the request:

    Object.defineProperty Client, "Request",
        configurable: no
        enumerable: yes
        writable: no
        value: do ->

            ClientRequest = (data) ->

                unless this and this instanceof ClientRequest
                    throw new TypeError "this is not a ClientRequest"

If we weren't provided with a scope, we'll set it to the default.
We can set our default `name` here as well.

                name = (String data.name) or "Laboratory"
                scope =
                    if data.scope instanceof Authorization.Scope then data.scope
                    else Authorization.Scope.READ

First, we normalize our URL.
We also get our redirect URI at this point.

                a = document.createElement "a"
                a.href = data.origin or "/"
                origin = a.origin
                a.href = data.redirect or ""
                redirect = a.href

This creates our request.

                Request.call this, "POST", origin + "/api/v1/apps", {
                    client_name: name
                    redirect_uris: redirect
                    scopes: (
                        scopeList = []
                        scopeList.push "read" if scope & Authorization.Scope.READ
                        scopeList.push "write" if scope & Authorization.Scope.WRITE
                        scopeList.push "follow" if scope & Authorization.Scope.FOLLOW
                        scopeList.join " "
                    )
                }, null, (result) => dispatch "LaboratoryClientReceived", decree =>
                    @response = police -> new Client result, origin, name, scope

                Object.freeze this

We just let our prototype inherit from `Request`.

            Object.defineProperty ClientRequest, "prototype",
                configurable: no
                enumerable: no
                writable: no
                value: Object.freeze Object.create Request.prototype,
                    constructor:
                        enumerable: no
                        value: ClientRequest

            return ClientRequest

###  Creating the events:

Here we create the events as per our specifications.

>   __[Issue #50](https://github.com/marrus-sh/laboratory/issues/50) :__
>   Client events may not fire in the future.

    LaboratoryEvent
        .create "LaboratoryClientReceived", Client

###  Handling the events:

Laboratory Client events do not have handlers.


- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>API/Initialization.litcoffee</code></p>

#  INITIALIZATION  #

 - - -

##  Description  ##

The __Initialization__ module of the Laboratory API is comprised of a few events related to initialization of the Laboratory store and handlers.
These make up just two events: `LaboratoryInitializationLoaded` and `LaboratoryInitializationReady`.

You can check `window.Laboratory.ready` as a means of verifying if these events have fired after-the-fact:
If `window.Laboratory.ready` exists, then `LaboratoryInitializationLoaded` has fired.
If it is `true`, then `LaboratoryInitializationReady` has fired as well.

**You should not fire Laboratory Initialization events yourself.**
They will be ignored by Laboratory proper, but may confuse other components which you might have loaded.
However, you should listen for these events to know when proper communication with the Laboratory framework should begin.

###  Quick reference:

####  Events.

| Event | Description |
| :---- | :---------- |
| `LaboratoryInitializationLoaded` | Fires when the Laboratory script has been loaded and run |
| `LaboratoryInitializationReady` | Fires when the Laboratory event handlers are ready to receive events |

###  Checking initialization status:

>   - __API equivalent :__ _None_
>   - __Miscellanous events :__
>       - `LaboratoryInitializationLoaded`
>       - `LaboratoryInitializationReady`

The `LaboratoryInitializationLoaded` event fires when the Laboratory script has been loaded and run, and can be used when loading Laboratory in an asynchronous manner.
After this event fires, it is safe to use the `Laboratory` object in your code.
Before this event fires, the `Laboratory` object will likely not have been defined yet.

The `LaboratoryInitializationReady` event fires when the Laboratory handlers have been assigned to their appropriate events.
After this event fires, it is safe to dispatch `Laboratory` events.
Before this event fires, it is unlikely (although not *impossible*) that they will be acted upon.

Laboratory waits for the entire document to be loaded before assigning its handlers; consequently, there is a possibility that `LaboratoryInitializationLoaded` will fire well before `LaboratoryInitializationReady`, especially with scripts loaded synchronously.
Of the two, `LaboratoryInitializationReady` is almost always the one to listen for.

Neither of the Laboratory Initialization events have `detail`s.

 - - -

##  Examples  ##

###  Initializing an application:

>   ```javascript
>   if (Laboratory.ready) init();
>   else document.addEventListener("LaboratoryInitializationReady", init);
>   ```

 - - -

##  Implementation  ##

###  Creating the events:

Here we create the events as per our specifications.

    LaboratoryEvent
        .create "LaboratoryInitializationLoaded"
        .create "LaboratoryInitializationReady"

###  Handling the events:

Laboratory Initialization events do not have handlers.


- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>API/Post.litcoffee</code></p>

#  POST REQUESTS  #

 - - -

##  Description  ##

The __Post__ module of the Laboratory API is comprised of those requests which are related to Mastodon statuses and notifications.

###  Quick reference:

####  Requests.

| Request | Description |
| :------ | :---------- |
| `Post.Request()` | Requests a `Post` from the Mastodon server |
| `Post.Create()` | Petitions the Mastodon server to create a new status |
| `Post.Delete()` | Petitions the Mastodon server to delete an existing status |
| `Post.SetReblog()` | Petitions the Mastodon server to reblog or unreblog the provided status |
| `Post.SetFavourite()` | Petitions the Mastodon server to favourite or unfavourite the provided status |

####  Events.

| Event | Description |
| :---- | :---------- |
| `LaboratoryPostReceived` | Fires when a `Post` has been processed |
| `LaboratoryPostDeleted` | Fires when a `Post` has been deleted |

###  Requesting a post:

>   ```javascript
>   request = new Laboratory.Post.Request(data, isLive, useCached);
>   ```
>
>   - __API equivalent :__ `/api/v1/statuses/:id`, `/api/v1/notifications/:id`
>   - __Data parameters :__
>       - __`id` :__ The id of the status or notification to request
>       - __`type` :__ A `Post.Type` (default: `Post.Type.STATUS`)
>   - __Response :__ A [`Post`](../Constructors/Post.litcoffee)

Laboratory `Post.Request`s are used to request [`Post`](../Constructors/Post.litcoffee)s containing data on a specified status or notification.
The request takes an object whose `id` parameter specifies the account to fetch and whose `type` specifies whether the post is a status or notification.

Post requests may be either __static__ or __live__.
Static post requests don't update their responses when new information is received from the server, whereas live post requests do.
This behaviour is controlled by the `isLive` argument, which defaults to `true`.

>   __Note :__
>   You can call `request.stop()` to stop a live `Post.Request`, and `request.start()` to start it up again.
>   Always call `request.stop()` when you are finished using a live request to allow it to be freed from memory.

Laboratory keeps track of all of the `Post`s it receives in its internal store.
If the `useCached` argument is `true` (the default), then it will immediately load the stored value into its response if available.
It will still request the server for updated information unless `isLive` is `false`.

###  Creating new statuses:

>   ```javascript
>   request = new Laboratory.Post.Create(data);
>   ```
>
>   - __API equivalent :__ `/api/v1/statuses`
>   - __Data parameters :__
>       - __`text` :__ The text of the post
>       - __`visibility` :__ A `Post.Visibility` (default: `Post.Visibility.PRIVATE`)
>       - __`inReplyTo` :__ A status id if the post is a reply
>       - __`attachments` :__ An array of `Attachment`s
>       - __`message` :__ A content/spoiler warning
>       - __`makeNSFW` :__ Whether or not the attached media contains NSFW content (default: `true`)
>   - __Response :__ A [`Post`](../Constructors/Post.litcoffee)

`Post.Create()` attempts to create a new status on the Mastodon server.
You can see the parameters it accepts above.

###  Deleting statuses:

>   ```javascript
>   request = new Laboratory.Post.Delete(data);
>   ```
>
>   - __API equivalent :__ `/api/v1/statuses`
>   - __Data parameters :__
>       - __`id` :__ The id of the post to delete
>   - __Response :__ `null`

`Post.Delete()` event attempts to delete an existing status from the Mastodon server.
The `id` parameter provides the id of the status to delete.

###  Reblogging and favouriting posts:

>   ```javascript
>   request = new Laboratory.Post.SetReblog(data);
>   request = new Laboratory.Post.SetFavourite(data);
>   ```
>
>   - __API equivalent :__ `/api/v1/statuses/:id/reblog`, `/api/v1/statuses/:id/unreblog`
>   - __Data parameters :__
>       - __`id` :__ The id of the status to reblog
>       - __`value` :__ `true` if the post should be reblogged/favourited, `false` if the post should be unreblogged/unfavourited
>   - __Response :__ A [`Post`](../Constructors/Post.litcoffee)

`Post.SetReblog()` and `Post.SetFavourite()` can be used to set the reblog/favourited status of posts.
They will respond with the updated post if they succeed.

 - - -

##  Examples  ##

###  Requesting a post's data:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the post
>   }
>
>   var request = new Laboratory.Post.Request({
>       id: postID,
>       type: Laboratory.Post.Type.STATUS
>   });
>   request.assign(requestCallback);
>   request.start();
>   ```

###  Creating a new post:

>   ```javascript
>   var request = new Laboratory.Post.Create({
>       text: contents,
>       visibility: Laboratory.Post.Visibility.PUBLIC
>   });
>   request.start();
>   ```

###  Deleting a post:

>   ```javascript
>   var request = new Laboratory.Post.Delete({id: deleteThisID});
>   request.start();
>   ```

###  Reblogging a post:

>   ```javascript
>   function requestCallback(event) {
>       if (event.detail.response.isReblogged) success();
>   }
>
>   var request = new Laboratory.Post.SetReblog({
>       id: somePost.id,
>       value: true
>   });
>   request.assign(requestCallback);
>   request.start();
>   ```

###  Unfavouriting a post:

>   ```javascript
>   function requestCallback(event) {
>       if (!event.detail.response.isFavourited) success();
>   }
>
>   var request = new Laboratory.Post.SetFavourite({
>       id: somePost.id,
>       value: false
>   });
>   request.assign(requestCallback);
>   request.start();
>   ```

 - - -

##  Implementation  ##

###  Making the requests:

    Object.defineProperties Post,

>   __[Issue #58](https://github.com/marrus-sh/laboratory/issues/58) :__
>   The code for interacting with posts may be simplified via function binding in the future.

####  `Post.Request`s.

        Request:
            configurable: no
            enumerable: yes
            writable: no
            value: do ->

                PostRequest = (data, isLive = yes, useCached = yes) ->

                    unless this and this instanceof PostRequest
                        throw new TypeError "this is not a PostRequest"

First we need to handle our variables.

                    unless Infinity > (postID = Math.floor data?.id) > 0
                        throw new TypeError "Unable to request post; no id provided"
                    type = Post.Type.STATUS unless (type = Post.Type.fromValue data.type) and
                        type isnt Post.Type.UNKNOWN
                    isNotification = type & Post.Type.NOTIFICATION
                    store = if isNotification then Store.notifications else Store.statuses

This `callback()` updates our `Post.Request` if Laboratory receives another `Post` with the same `id` and `type`.

                    callback = (event) =>
                        response = event.detail
                        if response instanceof Post and response.id is postID and
                            (response.type & Post.Type.NOTIFICATION) is isNotification
                                unless response.compare? and response.compare @response
                                    decree => @response = response
                                do @stop unless isLive

We can now create our request.
We dispatch a failure unless the received post matches the requested `postID` and `type`, and `stop()` unless our request `isLive`.

                    Request.call this, "GET", Store.auth.origin + (
                        if isNotification then "/api/v1/notifications/"
                        else "/api/v1/statuses/"
                    ) + postID, null, Store.auth.accessToken, (result) =>
                        unless result.id is postID
                            @dispatchEvent new CustomEvent "failure",
                                request: this
                                response: new Failure "Unable to fetch post; returned post did
                                    not match requested id"
                            return
                        post = new Post result
                        unless (post.type & Post.Type.NOTIFICATION) is isNotification
                            @dispatchEvent new CustomEvent "failure",
                                request: this
                                response: new Failure "Unable to fetch post; returned post was
                                    not of specified type"
                            return
                        dispatch "LaboratoryPostReceived", post

We store the default `Request` `start()` and `stop()` values and then overwrite them with our own.
This allows us to handle our `useCached` and `isLive` arguments.

>   __[Issue #39](https://github.com/marrus-sh/laboratory/issues/39) :__
>   These functions should be declared outside of the constructor and then bound to their proper values.

                    requestStart = @start
                    requestStop = @stop

                    Object.defineProperties this,
                        start:
                            enumerable: no
                            value: ->
                                if useCached and store[postID] instanceof Post
                                    decree => @response = store[postID]
                                    return unless isLive
                                document.addEventListener "LaboratoryPostReceived", callback
                                do requestStart
                        stop:
                            enumerable: no
                            value: ->
                                document.removeEventListener "LaboratoryPostReceived", callback
                                do requestStop

                    Object.freeze this

Our `Post.Request.prototype` just inherits from `Request`.

                Object.defineProperty PostRequest, "prototype",
                    configurable: no
                    enumerable: no
                    writable: no
                    value: Object.freeze Object.create Request.prototype,
                        constructor:
                            enumerable: no
                            value: PostRequest

                return PostRequest

####  `Post.Create`s.

        Create:
            configurable: no
            enumerable: yes
            writable: no
            value: do ->

                PostCreate = (data) ->

                    unless this and this instanceof PostCreate
                        throw new TypeError "this is not a PostCreate"

First we need to handle our variables.

                    unless data?.text
                        throw new TypeError "Unable to create post; no text provided"
                    text = String data.text
                    unless visibility = Post.Visibility.fromValue data.visibility
                        visibility = Post.Visibility.PRIVATE
                    unless Infinity > (inReplyTo = Math.floor data.inReplyTo) > 0
                        inReplyTo = undefined
                    attachments = (
                        if data.attachments instanceof Array then data.attachments
                        else undefined
                    )
                    message = if data.message? then String data.message else undefined
                    makeNSFW = if data.makeNSFW? then !!data.makeNSFW else undefined

We can now create our request.
This is just a simple `POST` request to the mastodon server.

                    Request.call this, "POST", Store.auth.origin + "/api/v1/statuses/", {
                        status: text
                        in_reply_to_id: inReplyTo
                        media_ids: if attachments then (
                            for attachment in attachments when attachment instanceof Attachment
                                attachment.id
                        ) else undefined
                        sensitive: if makeNSFW then "true" else undefined
                        spoiler_text: message
                        visibility: switch visibility
                            when Post.Visibility.PUBLIC then "public"
                            when Post.Visibility.UNLISTED then "unlisted"
                            when Post.Visibility.DIRECT then "direct"
                            else "private"
                    }, Store.auth.accessToken, (result) =>
                        dispatch "LaboratoryPostReceived", decree =>
                            @response = police -> new Post result

                    Object.freeze this

Our `Post.Create.prototype` just inherits from `Request`.

                Object.defineProperty PostCreate, "prototype",
                    configurable: no
                    enumerable: no
                    writable: no
                    value: Object.freeze Object.create Request.prototype,
                        constructor:
                            enumerable: no
                            value: PostCreate

                return PostCreate

####  `Post.Delete`s.

>   __[Issue #21](https://github.com/marrus-sh/laboratory/issues/21) :__
>   There needs to be better responses and error checking with regards to post deletion.

>   __[Issue #40](https://github.com/marrus-sh/laboratory/issues/40) :__
>   `Post.Delete()` only works on statuses, which means there isn't currently a way to remove individual notifications from the `Store`.

        Delete:
            configurable: no
            enumerable: yes
            writable: no
            value: do ->

                PostDelete = (data) ->

                    unless this and this instanceof PostDelete
                        throw new TypeError "this is not a PostDelete"
                    unless Infinity > (postID = Math.floor data?.id) > 0
                        throw new TypeError "Unable to create post; no id provided"

`Post.Delete()` just sends a `DELETE` to the appropriate point in the Mastodon API.

                    Request.call this, "DELETE",
                        Store.auth.origin + "/api/v1/statuses/" + postID, null,
                        Store.auth.accessToken, (result) =>
                            dispatch "LaboratoryPostDeleted", {id: postID}

                    Object.freeze this

Our `Post.Delete.prototype` just inherits from `Request`.

                Object.defineProperty PostDelete, "prototype",
                    configurable: no
                    enumerable: no
                    writable: no
                    value: Object.freeze Object.create Request.prototype,
                        constructor:
                            enumerable: no
                            value: PostDelete

                return PostDelete

####  `Post.SetReblog`s.

        SetReblog:
            configurable: no
            enumerable: yes
            writable: no
            value: do ->

                PostSetReblog = (data) ->

                    unless this and this instanceof PostSetReblog
                        throw new TypeError "this is not a PostSetReblog"
                    unless Infinity > (postID = Math.floor data?.id) > 0
                        throw new TypeError "Unable to reblog post; no id provided"
                    value = if data.value then !!data.value else on

`Post.SetReblog()` is mostly just an API request.

                    Request.call this, "POST",
                        Store.auth.origin + "/api/v1/statuses/" + postID + (
                            if value then "/reblog" else "/unreblog"
                        ), null, Store.auth.accessToken, (result) =>
                            dispatch "LaboratoryPostReceived", decree =>
                                @response = police -> new Post result

                    Object.freeze this

Our `Post.SetReblog.prototype` just inherits from `Request`.

                Object.defineProperty PostSetReblog, "prototype",
                    configurable: no
                    enumerable: no
                    writable: no
                    value: Object.freeze Object.create Request.prototype,
                        constructor:
                            enumerable: no
                            value: PostSetReblog

                return PostSetReblog

####  `Post.SetFavourite`s.

        SetFavourite:
            configurable: no
            enumerable: yes
            writable: no
            value: do ->

                PostSetFavourite = (data) ->

                    unless this and this instanceof PostSetFavourite
                        throw new TypeError "this is not a PostSetFavourite"
                    unless Infinity > (postID = Math.floor data?.id) > 0
                        throw new TypeError "Unable to favourite post; no id provided"
                    value = if data.value then !!data.value else on

`Post.SetFavourite()` is mostly just an API request.

                    Request.call this, "POST",
                        Store.auth.origin + "/api/v1/statuses/" + postID + (
                            if value then "/favourite" else "/unfavourite"
                        ), null, Store.auth.accessToken, (result) =>
                            dispatch "LaboratoryPostReceived", decree =>
                                @response = police -> new Post result

                    Object.freeze this

Our `Post.SetFavourite.prototype` just inherits from `Request`.

                Object.defineProperty PostSetFavourite, "prototype",
                    configurable: no
                    enumerable: no
                    writable: no
                    value: Object.freeze Object.create Request.prototype,
                        constructor:
                            enumerable: no
                            value: PostSetFavourite

                return PostSetFavourite

###  Creating the events:

Here we create the events as per our specifications.

    LaboratoryEvent
        .create "LaboratoryPostReceived", Post
        .create "LaboratoryPostDeleted",
            id: undefined

###  Handling the events:

Laboratory provides handlers for the following Authorization events:

- `LaboratoryPostReceived`
- `LaboratoryPostDeleted`

####  `LaboratoryPostReceived`.

The `LaboratoryPostReceived` event simply adds a received post to our store.

>   __[Issue #35](https://github.com/marrus-sh/laboratory/issues/35) :__
>   The internal representation of the `Store` may change in the future to support custom notifications, et cetera.

>   __[Issue #36](https://github.com/marrus-sh/laboratory/issues/36) :__
>   The internal representation of the `Store` may similarly change to support multiple simultaneous signins.

        .handle "LaboratoryPostReceived", (event) ->
            if (post = event.detail) instanceof Post and
                (type = post.type) instanceof Post.Type and
                Infinity > (id = Math.floor post.id) > 0
                    Store[["notifications", "statuses"][+!(
                        type & Post.Type.NOTIFICATION
                    )]][id] = post

####  `LaboratoryPostDeletion`.

The `LaboratoryPostDeleted` event removes the given post from our store.

>   __[Issue #35](https://github.com/marrus-sh/laboratory/issues/35) :__
>   The internal representation of the `Store` may change in the future to support custom notifications, et cetera.

>   __[Issue #36](https://github.com/marrus-sh/laboratory/issues/36) :__
>   The internal representation of the `Store` may similarly change to support multiple simultaneous signins.

        .handle "LaboratoryPostDeleted", (event) ->
            delete Store.statuses[id] if Infinity > (id = Math.floor event.detail.id) > 0


- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>API/Profile.litcoffee</code></p>

#  PROFILE REQUESTS  #

 - - -

##  Description  ##

The __Profile__ module of the Laboratory API is comprised of those events which are related to Mastodon accounts.

###  Quick reference:

####  Requests.

| Request | Description |
| :------ | :---------- |
| `Profile.Request()` | Requests a `Profile` from the Mastodon server |
| `Profile.SetFollow()` | Petitions the Mastodon server to follow or unfollow the provided account |
| `Profile.SetBlock()` | Petitions the Mastodon server to block or unblock the provided account |
| `Profile.SetMute()` | Petitions the Mastodon server to mute or unmute the provided account |
| `Profile.LetFollow()` | Responds to a follow request |

####  Events.

| Event | Description |
| :---- | :---------- |
| `LaboratoryProfileReceived` | Fires when a `Profile` has been processed |

###  Requesting a profile:

>   ```javascript
>   request = new Laboratory.Profile.Request(data, isLive, useCached);
>   ```
>
>   - __API equivalent :__ `/api/v1/accounts/:id`, `/api/v1/accounts/relationships`
>   - __Request parameters :__
>       - __`id` :__ The id of the profile to request
>   - __Response :__ A [`Profile`](../Constructors/Profile.litcoffee)

Laboratory Profile events are used to request [`Profile`](../Constructors/Profile.litcoffee)s containing data on a specified account.
The request takes an object whose `id` parameter specifies the account to fetch.

Profile requests may be either __static__ or __live__.
Static profile requests don't update their responses when new information is received from the server, whereas live profile requests do.
This behaviour is controlled by the `isLive` argument, which defaults to `true`.

>   __Note :__
>   You can call `request.stop()` to stop a live `Profile.Request`, and `request.start()` to start it up again.
>   Always call `request.stop()` when you are finished using a live request to allow it to be freed from memory.

Laboratory Profile requests automatically retrieve up-to-date relationship information for the accounts they fetch.
However, this can only happen if `isLive` is `true`.
Otherwise, the profile relationship will likely end up as `Profile.Relationship.UNKNOWN`.

Laboratory keeps track of all of the `Profile`s it receives in its internal store.
If the `useCached` argument is `true` (the default), then it will immediately load the stored value into its response if available.
It will still request the server for updated information unless `isLive` is `false`.

A summary of these options is provided by the table below:

| `isLive` | `useCached` | Description |
| :------: | :---------: | :---------- |
|  `true`  |   `true`    | Laboratory will respond with the cached value if available, then query the server for both updated account information and relationship status. It will continue to update its response as new information becomes available. |
|  `true`  |   `false`   | Laboratory will not use the cached value, but will query the server for both updated account information and relationship status. It will continue to update its response as new information becomes available. |
| `false`  |   `true`    | Laboratory will respond with the cached value if available, and only query the server if it doesn't have the account in its cache. It won't check for updated relationship information or update its response over time. |
| `false`  |   `false`   | Laboratory will query the server once for the account information, but won't check for relationship information or update its response afterwards. In this case, the relationship will always be either `Profile.Relationship.SELF` or `Profile.Relationship.UNKNOWN`. |

###  Changing relationship status:

>   ```javascript
>       followRequest = new Laboratory.Profile.SetFollow(data);
>       blockRequest = new Laboratory.Profile.SetBlock(data);
>       muteRequest = new Laboratory.Profile.SetMute(data);
>       adjudicationRequest = new Laboratory.Profile.LetFollow(data);
>   ```
>
>   - __API equivalent :__ `/api/v1/accounts/follow`, `/api/v1/accounts/unfollow`, `/api/v1/accounts/block`, `/api/v1/accounts/unblock`, `/api/v1/accounts/mute`, `/api/v1/accounts/unmute`
>   - __Request parameters :__
>       - __`id` :__ The id of the account to change the relationship of
>       - __`value` :__ Whether to follow/block/mute/authorize an account or not
>   - __Response :__ A [`Profile`](../Constructors/Profile.litcoffee)

`Profile.SetFollow()`, `Profile.SetBlock()`, `Profile.SetMute()`, and `Profile.LetFollow()` can be used to modify the relationship status for an account.
They should be fired with two parameters: `id`, which gives the id of the account, and `value`, which should indicate whether to follow/block/mute/authorize an account, or do the opposite.

 - - -

##  Examples  ##

###  Requesting a profile's data:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the profile
>   }
>
>   var request = new Laboratory.Profile.Request({id: profileID});
>   request.assign(requestCallback);
>   request.start();
>   ```

###  Following a profile:

>   ```javascript
>   function requestCallback(event) {
>       if (event.detail.response.relationship & Laboratory.Profile.Relationship.FOLLOWING) success();
>   }
>
>   var request = new Laboratory.Profile.SetFollow({
>       id: someProfile.id,
>       value: true
>   });
>   request.assign(requestCallback);
>   request.start();
>   ```

###  Rejecting a follow request:

>   ```javascript
>   function requestCallback(event) {
>       if (event.detail.response.relationship & ~Laboratory.Profile.Relationship.FOLLOWED_BY) success();
>   }
>
>   var request = new Laboratory.Profile.LetFollow({
>       id: someProfile.id,
>       value: false
>   });
>   request.assign(requestCallback);
>   request.start();
>   ```

 - - -

##  Implementation  ##

###  Making the requests:

    Object.defineProperties Profile,

>   __[Issue #58](https://github.com/marrus-sh/laboratory/issues/58) :__
>   The code for interacting with profiles may be simplified via function binding in the future.

####  `Profile.Request`s.

        Request:
            configurable: no
            enumerable: yes
            writable: no
            value: do ->

                ProfileRequest = (data, isLive = yes, useCached = yes) ->

                    unless this and this instanceof ProfileRequest
                        throw new TypeError "this is not a ProfileRequest"
                    unless Infinity > (profileID = Math.floor data?.id) > 0
                        throw new TypeError "Unable to request profile; no id provided"

This `callback()` updates our `Profile.Request` if Laboratory receives another `Profile` with the same `id`.

                    callback = (event) =>
                        response = event.detail
                        if response instanceof Profile and response.id is profileID
                            unless response.compare? and response.compare @response
                                decree => @response = response
                            do @stop unless isLive

We can now create our request.
We dispatch a failure unless the received profile matches the requested `profileID`, and `stop()` unless our request `isLive`.

                    Request.call this, "GET",
                        Store.auth.origin + "/api/v1/accounts/" + profileID,
                        null, Store.auth.accessToken, (result) =>
                            unless result.id is profileID
                                @dispatchEvent new CustomEvent "failure",
                                    id: @id
                                    request: this
                                    response: new Failure "Unable to fetch profile; returned
                                        profile did not match requested id"
                                return
                            dispatch "LaboratoryProfileReceived", new Profile result
                            do relationshipRequest.start

If this `isLive`, then we also need to create a `Request` for our relationships.

                    relationshipRequest = new Request "GET",
                        Store.auth.origin + "/api/v1/accounts/relationships", {id: profileID},
                        Store.auth.accessToken, (result) =>
                            relationships = result[0]
                            relID = relationships.id
                            relationship = Profile.Relationship.fromValue (
                                Profile.Relationship.FOLLOWER * relationships.followed_by +
                                Profile.Relationship.FOLLOWING * relationships.following +
                                Profile.Relationship.REQUESTED * relationships.requested +
                                Profile.Relationship.BLOCKING * relationships.blocking +
                                Profile.Relationship.MUTING * relationships.muting +
                                Profile.Relationship.SELF * (relID is Store.auth.me)
                            ) or Profile.Relationship.UNKNOWN
                            unless Store.profiles[relID]?.relationship is relationship
                                dispatch "LaboratoryProfileReceived",
                                    new Profile (
                                        Store.profiles[relID] or {id: relID}
                                    ), relationship

We store the default `Request` `start()` and `stop()` values and then overwrite them with our own.
This allows us to handle our `useCached` and `isLive` arguments.

>   __[Issue #39](https://github.com/marrus-sh/laboratory/issues/39) :__
>   These functions should be declared outside of the constructor and then bound to their proper values.

                    requestStart = @start
                    requestStop = @stop

                    Object.defineProperties this,
                        start:
                            enumerable: no
                            value: ->
                                if useCached and Store.profiles[profileID] instanceof Profile
                                    decree => @response = Store.profiles[profileID]
                                    return unless isLive
                                document.addEventListener "LaboratoryProfileReceived", callback
                                do requestStart
                        stop:
                            enumerable: no
                            value: ->
                                document.removeEventListener "LaboratoryProfileReceived",
                                    callback
                                do requestStop
                                do relationshipRequest.stop

                    Object.freeze this

Our `Profile.Request.prototype` just inherits from `Request`.

                Object.defineProperty ProfileRequest, "prototype",
                    configurable: no
                    enumerable: no
                    writable: no
                    value: Object.freeze Object.create Request.prototype,
                        constructor:
                            enumerable: no
                            value: ProfileRequest

                return ProfileRequest

####  `Post.SetFollow`s.

>   __[Issue #47](https://github.com/marrus-sh/laboratory/issues/47) :__
>   There is currently no way to follow a remote user that doesn't already have an internal Mastodon representation (ie, an id).

        SetFollow:
            configurable: no
            enumerable: yes
            writable: no
            value: do ->

                ProfileSetFollow = (data) ->

                    unless this and this instanceof ProfileSetFollow
                        throw new TypeError "this is not a ProfileSetFollow"
                    unless Infinity > (profileID = Math.floor data?.id) > 0
                        throw new TypeError "Unable to follow account; no id provided"
                    value = if data.value then !!data.value else on

`Profile.SetFollow()` is mostly just an API request.

                    Request.call this, "POST",
                        Store.auth.origin + "/api/v1/accounts/" + profileID + (
                            if value then "/follow" else "/unfollow"
                        ), null, Store.auth.accessToken, (result) =>
                            dispatch "LaboratoryProfileReceived", decree =>
                                @response = police -> new Profile result

                    Object.freeze this

Our `Profile.SetFollow.prototype` just inherits from `Request`.

                Object.defineProperty ProfileSetFollow, "prototype",
                    configurable: no
                    enumerable: no
                    writable: no
                    value: Object.freeze Object.create Request.prototype,
                        constructor:
                            enumerable: no
                            value: ProfileSetFollow

                return ProfileSetFollow

####  `Post.SetBlock`s.

        SetBlock:
            configurable: no
            enumerable: yes
            writable: no
            value: do ->

                ProfileSetBlock = (data) ->

                    unless this and this instanceof ProfileSetBlock
                        throw new TypeError "this is not a ProfileSetBlock"
                    unless Infinity > (profileID = Math.floor data?.id) > 0
                        throw new TypeError "Unable to block account; no id provided"
                    value = if data.value then !!data.value else on

`Profile.SetBlock()` is mostly just an API request.

                    Request.call this, "POST",
                        Store.auth.origin + "/api/v1/accounts/" + profileID + (
                            if value then "/block" else "/unblock"
                        ), null, Store.auth.accessToken, (result) =>
                            dispatch "LaboratoryProfileReceived", decree =>
                                @response = police -> new Profile result

                    Object.freeze this

Our `Profile.SetBlock.prototype` just inherits from `Request`.

                Object.defineProperty ProfileSetBlock, "prototype",
                    configurable: no
                    enumerable: no
                    writable: no
                    value: Object.freeze Object.create Request.prototype,
                        constructor:
                            enumerable: no
                            value: ProfileSetBlock

                return ProfileSetBlock

####  `Post.SetMute`s.

        SetMute:
            configurable: no
            enumerable: yes
            writable: no
            value: do ->

                ProfileSetMute = (data) ->

                    unless this and this instanceof ProfileSetMute
                        throw new TypeError "this is not a ProfileSetMute"
                    unless Infinity > (profileID = Math.floor data?.id) > 0
                        throw new TypeError "Unable to mute account; no id provided"
                    value = if data.value then !!data.value else on

`Profile.SetMute()` is mostly just an API request.

                    Request.call this, "POST",
                        Store.auth.origin + "/api/v1/accounts/" + profileID + (
                            if value then "/mute" else "/unmute"
                        ), null, Store.auth.accessToken, (result) =>
                            dispatch "LaboratoryProfileReceived", decree =>
                                @response = police -> new Profile result

                    Object.freeze this

Our `Profile.SetMute.prototype` just inherits from `Request`.

                Object.defineProperty ProfileSetMute, "prototype",
                    configurable: no
                    enumerable: no
                    writable: no
                    value: Object.freeze Object.create Request.prototype,
                        constructor:
                            enumerable: no
                            value: ProfileSetMute

                return ProfileSetMute

####  `Post.LetFollow`s.

        LetFollow:
            configurable: no
            enumerable: yes
            writable: no
            value: do ->

                ProfileLetFollow = (data) ->

                    unless this and this instanceof ProfileLetFollow
                        throw new TypeError "this is not a ProfileLetFollow"
                    unless Infinity > (profileID = Math.floor data?.id) > 0
                        throw new TypeError "Unable to follow account; no id provided"
                    value = if data.value then !!data.value else on

`Profile.LetFollow()` is mostly just an API request.

>   __Note :__
>   Mastodon does not currently support returning the authorized/rejected account after responding to a follow request.

                    Request.call this, "POST",
                        Store.auth.origin + "/api/v1/follow_requests" + (
                            if value then "/authorize" else "/reject"
                        ), {id: profileID}, Store.auth.accessToken, (result) =>
                            #  dispatch "LaboratoryProfileReceived", decree =>
                                #  @response = police -> new Profile result

                    Object.freeze this

Our `Profile.LetFollow.prototype` just inherits from `Request`.

                Object.defineProperty ProfileLetFollow, "prototype",
                    configurable: no
                    enumerable: no
                    writable: no
                    value: Object.freeze Object.create Request.prototype,
                        constructor:
                            enumerable: no
                            value: ProfileLetFollow

                return ProfileLetFollow

###  Creating the events:

Here we create the events as per our specifications.

    LaboratoryEvent
        .create "LaboratoryProfileReceived", Profile

###  Handling the events:

Laboratory provides handlers for the following Authorization events:

- `LaboratoryProfileReceived`

####  `LaboratoryProfileReceived`.

The `LaboratoryProfileReceived` event simply adds a received profile to our store.

>   __[Issue #35](https://github.com/marrus-sh/laboratory/issues/35) :__
>   The internal representation of the `Store` may change in the future to support custom notifications, et cetera.

>   __[Issue #36](https://github.com/marrus-sh/laboratory/issues/36) :__
>   The internal representation of the `Store` may similarly change to support multiple simultaneous signins.

        .handle "LaboratoryProfileReceived", (event) ->
            if (profile = event.detail) instanceof Profile and
                Infinity > (id = Math.floor profile.id) > 0
                    Store.profiles[id] = profile


- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>API/Request.litcoffee</code></p>

#  REQUEST EVENTS  #

 - - -

##  Description  ##

The __Request__ module of the Laboratory API is comprised of a handlful of events which are related to Laboratory's various `XMLHttpRequest`s.
Generally speaking you shouldn't have to interact with these events yourself, but they provide an interface for logging which server requests Laboratory currently has open.

>   __[Issue #44](https://github.com/marrus-sh/laboratory/issues/44) :__
>   Request events may change significantly, or be removed, in the near future.
>   You may want to avoid using them in the meantime.

###  Quick reference:

####  Events.

| Event | Description |
| :---- | :---------- |
| `LaboratoryRequestOpen` | Fires when an XMLHttpRequest is opened |
| `LaboratoryRequestUpdate` | Fires when an XMLHttpRequest is updated |
| `LaboratoryRequestComplete` | Fires when an XMLHttpRequest is done loading |
| `LaboratoryRequestError` | Fires when an XMLHttpRequest fails |

###  Listening for requests:

>   - __API equivalent :__ _None_
>   - __Miscellanous events :__
>       - `LaboratoryRequestOpen`
>       - `LaboratoryRequestUpdate`
>       - `LaboratoryRequestComplete`
>       - `LaboratoryRequestError`

Laboratory Request events fire whenever the `readystate` of an `XMLHttpRequest` changes.
`LaboratoryRequestComplete` signifies that the request was successful; that is, it had an HTTP status code in the range `200`–`205` and its response could be parsed.
Alternatively, `LaboratoryRequestError` indicates that the request completed but one or both of those conditions was not true.

The `response` of each Laboratory Request event is the associated `XMLHttpRequest`.

 - - -
 
##  Examples  ##

_[None.]_
 
 - - -

##  Implementation  ##

###  Creating the events:

Here we create the events as per our specifications.

    LaboratoryEvent
        .create "LaboratoryRequestOpen", XMLHttpRequest
        .create "LaboratoryRequestUpdate", XMLHttpRequest
        .create "LaboratoryRequestComplete", XMLHttpRequest
        .create "LaboratoryRequestError", XMLHttpRequest

###  Handling the events:

Laboratory Request events do not have handlers.


- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>API/Rolodex.litcoffee</code></p>

#  ROLODEX REQUESTS  #

 - - -

##  Description  ##

The __Rolodex__ module of the Laboratory API is comprised of those requests which are related to rolodexes of Mastodon accounts.

###  Quick reference:

####  Requests.

| Request | Description |
| :------ | :---------- |
| `Rolodex.Request()` | Requests a `Rolodex` from the Mastodon server |

###  Requesting a rolodex:

>   ```javascript
>   request = new Laboratory.Rolodex.Request(data);
>   rangedRequest = new Laboratory.Rolodex.Request(data, before, after);
>   ```
>
>   - __API equivalent :__ `/api/v1/accounts/search`, `/api/v1/accounts/:id/followers`, `/api/v1/accounts/:id/following`, `/api/v1/statuses/:id/reblogged_by`, `/api/v1/statuses/:id/favourited_by`, `/api/v1/blocks`, `/api/v1/mutes`, `/api/v1/follow_requests`
>   - __Request parameters :__
>       - __`type` :__ The [`Rolodex.Type`](../Constructors/Rolodex.litcoffee) of the `Rolodex`
>       - __`query` :__ The associated query
>       - __`limit` :__ The number of accounts to show (for searches only)
>   - __Response :__ A [`Rolodex`](../Constructors/Rolodex.litcoffee)

Laboratory Rolodex events are used to request [`Rolodex`](../Constructors/Rolodex.litcoffee)es of accounts according to the specified `type` and `query`.
If the `type` is `Rolodex.Type.SEARCH`, then `query` should provide the string to search for; otherwise, `query` should be the id of the relevant account or status.
In the case of `Rolodex.Type.BLOCKS`, `Rolodex.Type.MUTES`, and `Rolodex.Type.FOLLOW_REQUESTS`, no `query` is required.

The `before` and `after` arguments can be used to modify the range of the `Rolodex`, but generally speaking you shouldn't need to specify these directly—instead use the built-in update and pagination functions to do this for you.

For `Rolodex.Type.SEARCH`es, the number of accounts to return can be specified using the `limit` parameter; for other `Rolodex.Type`s, this parameter is ignored.

####  Getting more entries.

The `update()` and `loadMore()` methods of a `Rolodex.Request` can be used to update a `Rolodex` with new entries, or older ones, respectively.

The `update()` method takes one argument: `keepGoing`, which tells Laboratory whether to keep loading new information until the `Rolodex` is caught up to the present.
The default value for this argument is `true`.

####  Pagination.

If you want to get more entries, but don't want them all collapsed into a single `Rolodex`, the `prev()` and `next()` methods can be used instead.
These return new `Rolodex.Request`s which will respond with the previous and next page of entries, respectively.

 - - -

##  Examples  ##

###  Requesting an account's followers:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the rolodex
>   }
>
>   var request = new Laboratory.Rolodex.Request({
>       type: Laboratory.Rolodex.Type.FOLLOWERS
>       query: someProfile.id
>   });
>   request.assign(requestCallback);
>   request.start();
>   ```

###  Searching for an account:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the rolodex
>   }
>
>   var request = new Laboratory.Rolodex.Request({
>       type: Laboratory.Rolodex.Type.SEARCH
>       query: "account"
>       limit: 5
>   });
>   request.assign(requestCallback);
>   request.start();
>   ```

###  Checking a user's blocks:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the rolodex
>   }
>
>   var request = new Laboratory.Rolodex.Request({
>       type: Laboratory.Rolodex.Type.BLOCKS
>   });
>   request.assign(requestCallback);
>   request.start();
>   ```

###  Updating a request:

>   ```javascript
>   request.update();  //  Will fire a "response" event for each update
>   ```

###  Paginating a request:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the rolodex
>   }
>
>   function loadNextPage (request) {
>       var newRequest = request.next();
>       newRequest.assign(requestCallback);
>       newRequest.start();
>       return newRequest;
>   }
>
>   function loadPrevPage (request) {
>       var newRequest = request.prev();
>       newRequest.assign(requestCallback);
>       newRequest.start();
>       return newRequest;
>   }
>   ```

 - - -

##  Implementation  ##

###  Making the request:

    Object.defineProperty Rolodex, "Request",

        configurable: no
        enumerable: yes
        writable: no
        value: do ->

            RolodexRequest = (data, before, after) ->

                unless this and this instanceof RolodexRequest
                    throw new TypeError "this is not a RolodexRequest"

First, we handle our `data`.

                unless (type = Rolodex.Type.fromValue data.type) and
                    type isnt Rolodex.Type.UNDEFINED
                        throw new TypeError "Unable to request rolodex; no type provided"
                query = if data.query? then String data.query else undefined
                limit =
                    if Infinity > data.limit > 0 then Math.floor data.limit else undefined

`before` and `after` will store the next and previous pages for our `Rolodex.Request`.

                before = undefined unless Infinity > before > 0
                after = undefined unless Infinity > after > 0

Next, we set up our `Request`.
Note that `Request()` ignores data parameters which have a value of `undefined` or `null`.

>   __[Issue #27](https://github.com/marrus-sh/laboratory/issues/27) :__
>   In the future, the events dispatched here may instead be dispatched from the `Rolodex()` constructor directly.

                Request.call this, "GET", Store.auth.origin + (
                        switch type
                            when Rolodex.Type.SEARCH then "/api/v1/accounts/search"
                            when Rolodex.Type.FOLLOWERS
                                "/api/v1/accounts/" + query + "/followers"
                            when Rolodex.Type.FOLLOWING
                                "/api/v1/accounts/" + query + "/following"
                            when Rolodex.Type.FAVOURITED_BY
                                "/api/v1/statuses/" + query + "/favourited_by"
                            when Rolodex.Type.REBLOGGED_BY
                                "/api/v1/statuses/" + query + "/reblogged_by"
                            when Rolodex.Type.BLOCKS then "/api/v1/blocks"
                            when Rolodex.Type.MUTES then "/api/v1/mutes"
                            when Rolodex.Type.FOLLOW_REQUESTS then "/api/v1/follow_requests"
                    ), (
                        switch type
                            when Rolodex.Type.SEARCH
                                q: query
                                limit: limit
                            else
                                max_id: before
                                since_id: after
                    ), Store.auth.accessToken, (result, params) =>
                        ids = []
                        before = ((params.prev?.match /.*since_id=([0-9]+)/) or [])[1]
                        after = ((params.next?.match /.*max_id=([0-9]+)/) or [])[1]
                        for account in result when account.id not in ids
                            ids.push account.id
                            dispatch "LaboratoryProfileReceived", new Profile account
                        decree => @response = police -> new Rolodex result

>   __[Issue #39](https://github.com/marrus-sh/laboratory/issues/39) :__
>   These functions should be declared outside of the constructor and then bound to their proper values.

                Object.defineProperties this,
                    before:
                        enumerable: yes
                        get: -> before
                    after:
                        enumerable: yes
                        get: -> after
                    prev:
                        enumerable: no
                        value: -> return new RolodexRequest {type, query, limit}, undefined, before
                    next:
                        enumerable: no
                        value: -> return new RolodexRequest {type, query, limit}, after
                    loadMore:
                        enumerable: no
                        value: =>
                            callback = (event) =>
                                after = next.after
                                decree => @response = police -> @response.join next.response
                                next.removeEventListener "response", callback
                            (next = do @next).addEventListener "response", callback
                            do next.start
                    update:
                        enumerable: no
                        value: (keepGoing) =>
                            callback = (event) =>
                                before = prev.before
                                decree => @response = police -> @response.join prev.response
                                prev.removeEventListener "response", callback
                                if keepGoing and prev.response.length
                                    (prev = do @prev).addEventListener "response", callback
                                    do prev.start
                            (prev = do @prev).addEventListener "response", callback
                            do prev.start

                Object.freeze this

Our `Rolodex.Request.prototype` inherits from `Request`, with additional dummy methods for the ones we define in our constructor.

            Object.defineProperty RolodexRequest, "prototype",
                configurable: no
                enumerable: no
                writable: no
                value: Object.freeze Object.create Request.prototype,
                    constructor:
                        enumerable: no
                        value: RolodexRequest
                    prev:
                        enumerable: no
                        value: ->
                    next:
                        enumerable: no
                        value: ->
                    loadMore:
                        enumerable: no
                        value: ->
                    update:
                        enumerable: no
                        value: ->

            return RolodexRequest


- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>API/Timeline.litcoffee</code></p>

#  TIMELINE REQUESTS  #

 - - -

##  Description  ##

The __Timeline__ module of the Laboratory API is comprised of those requests which are related to rolodexes of Mastodon accounts.

###  Quick reference:

####  Requests.

| Request | Description |
| :------ | :---------- |
| `Timeline.Request()` | Requests a `Timeline` from the Mastodon server |

###  Requesting a rolodex:

>   ```javascript
>   request = new Laboratory.Timeline.Request(data);
>   rangedRequest = new Laboratory.Timeline.Request(data, before, after);
>   ```
>
>   - __API equivalent :__ `/api/v1/timelines/home`, `/api/v1/timelines/public`, `/api/v1/timelines/tag/:hashtag`, `/api/v1/notifications/`, `/api/v1/favourites`
>   - __Request parameters :__
>       - __`type` :__ The [`Timeline.Type`](../Constructors/Timeline.litcoffee) of the `Timeline`
>       - __`query` :__ The associated query
>       - __`isLocal` :__ Whether to exclude federated posts (default: `false`)
>   - __Response :__ A [`Timeline`](../Constructors/Timeline.litcoffee)

Laboratory Rolodex events are used to request [`Timeline`](../Constructors/Timeline.litcoffee)s of accounts according to the specified `type` and `query`.
If the `type` is `Timeline.Type.HASHTAG`, then `query` should provide the hashtag; in the case of `Timeline.Type.ACCOUNT`, then `query` should provide the account id; otherwise, no `query` is required.

The `isLocal` parameter specifies whether to include federated posts in the resultant timeline; note however that this is only supported for some `Timeline.Type`s.

>   __[Issue #56](https://github.com/marrus-sh/laboratory/issues/56) :__
>   Future timelines should be able to limit their responses to just posts with media attachments.

>   __[Issue #57](https://github.com/marrus-sh/laboratory/issues/57) :__
>   Future timelines should be able to limit their responses to exclude posts with replies.

The `before` and `after` arguments can be used to modify the range of the `Timeline`, but generally speaking you shouldn't need to specify these directly—instead use the built-in update and pagination functions to do this for you.

####  Getting more entries.

The `update()` and `loadMore()` methods of a `Timeline.Request` can be used to update a `Timeline` with new entries, or older ones, respectively.

The `update()` method takes one argument: `keepGoing`, which tells Laboratory whether to keep loading new information until the `Timeline` is caught up to the present.
The default value for this argument is `true`.

####  Pagination.

If you want to get more entries, but don't want them all collapsed into a single `Timeline`, the `prev()` and `next()` methods can be used instead.
These return new `Timeline.Request`s which will respond with the previous and next page of entries, respectively.

 - - -

##  Examples  ##

###  Requesting an account's statuses:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the timeline
>   }
>
>   var request = new Laboratory.Timeline.Request({
>       type: Laboratory.Timeline.Type.ACCOUNT
>       query: someProfile.id
>   });
>   request.assign(requestCallback);
>   request.start();
>   ```

###  Getting posts for a hashtag:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the rolodex
>   }
>
>   var request = new Laboratory.Timeline.Request({
>       type: Laboratory.Timeline.Type.HASHTAG
>       query: "hashtag"
>   });
>   request.assign(requestCallback);
>   request.start();
>   ```

###  Getting the home timeline:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the rolodex
>   }
>
>   var request = new Laboratory.Timeline.Request({
>       type: Laboratory.Timeline.Type.HOME
>   });
>   request.assign(requestCallback);
>   request.start();
>   ```

###  Updating a request:

>   ```javascript
>   request.update();  //  Will fire a "response" event for each update
>   ```

###  Paginating a request:

>   ```javascript
>   function requestCallback(event) {
>       //  Do something with the rolodex
>   }
>
>   function loadNextPage (request) {
>       var newRequest = request.next();
>       newRequest.assign(requestCallback);
>       newRequest.start();
>       return newRequest;
>   }
>
>   function loadPrevPage (request) {
>       var newRequest = request.prev();
>       newRequest.assign(requestCallback);
>       newRequest.start();
>       return newRequest;
>   }
>   ```

 - - -

##  Implementation  ##

###  Making the request:

    Object.defineProperty Timeline, "Request",

        configurable: no
        enumerable: yes
        writable: no
        value: do ->

            TimelineRequest = (data, before, after) ->

                unless this and this instanceof TimelineRequest
                    throw new TypeError "this is not a TimelineRequest"

First, we handle our `data`.

                unless (type = Timeline.Type.fromValue data.type) and
                    type isnt Timeline.Type.UNDEFINED
                        throw new TypeError "Unable to request rolodex; no type provided"
                query = if data.query? then String data.query else undefined
                isLocal = !!data.isLocal
                limit =
                    if Infinity > data.limit > 0 then Math.floor data.limit else undefined

`before` and `after` will store the next and previous pages for our `Timeline.Request`.

                before = undefined unless Infinity > before > 0
                after = undefined unless Infinity > after > 0

Next, we set up our `Request`.
Note that `Request()` ignores data parameters which have a value of `undefined` or `null`.

>   __[Issue #27](https://github.com/marrus-sh/laboratory/issues/27) :__
>   In the future, the events dispatched here may instead be dispatched from the `Timeline()` constructor directly.

>   __[Issue #56](https://github.com/marrus-sh/laboratory/issues/56) :__
>   Future timelines should be able to limit their responses to just posts with media attachments.

>   __[Issue #57](https://github.com/marrus-sh/laboratory/issues/57) :__
>   Future timelines should be able to limit their responses to exclude posts with replies.

                Request.call this, "GET", Store.auth.origin + (
                        switch type
                            when Timeline.Type.HASHTAG then "/api/v1/timelines/tag/" + query
                            when Timeline.Type.PUBLIC then "/api/v1/timelines/public"
                            when Timeline.Type.HOME then "/api/v1/timelines/home"
                            when Timeline.Type.NOTIFICATIONS then "/api/v1/notifications"
                            when Timeline.Type.FAVOURITES then "/api/v1/favourites"
                            when Timeline.Type.ACCOUNT then "/api/v1/accounts/" + query +
                                "/statuses"
                            else "/api/v1"
                    ), {
                        local: isLocal or undefined
                        max_id: before
                        since_id: after
                    }, Store.auth.accessToken, (result, params) =>
                        acctIDs = []
                        mentions = []
                        mentionIDs = []
                        ids = []
                        before = ((params.prev?.match /.*since_id=([0-9]+)/) or [])[1]
                        after = ((params.next?.match /.*max_id=([0-9]+)/) or [])[1]
                        for status in result when status.id not in ids
                            ids.push status.id
                            for account in [
                                status.account
                                status.status?.account
                                status.reblog?.account
                            ] when account
                                acctIDs.push account.id
                                dispatch "LaboratoryProfileReceived", new Profile account
                            if (
                                srcMentions = status.mentions or status.status?.mentions or
                                    status.reblog?.mentions
                            ) instanceof Array
                                for account in srcMentions when account.id not in mentionIDs
                                    mentionIDs.push account.id
                                    mentions.push account
                            dispatch "LaboratoryPostReceived", new Post status
                        for mention in mentions when mention.id not in acctIDs and
                            not Store.profiles[mention.id]?
                                dispatch "LaboratoryProfileReceived", new Profile mention
                        decree => @response = police -> new Timeline result

>   __[Issue #39](https://github.com/marrus-sh/laboratory/issues/39) :__
>   These functions should be declared outside of the constructor and then bound to their proper values.

                Object.defineProperties this,
                    before:
                        enumerable: yes
                        get: -> before
                    after:
                        enumerable: yes
                        get: -> after
                    prev:
                        enumerable: no
                        value: -> return new TimelineRequest {type, query, isLocal}, undefined, before
                    next:
                        enumerable: no
                        value: -> return new TimelineRequest {type, query, isLocal}, after
                    loadMore:
                        enumerable: no
                        value: =>
                            callback = (event) =>
                                after = next.after
                                decree => @response = police -> @response.join next.response
                                next.removeEventListener "response", callback
                            (next = do @next).addEventListener "response", callback
                            do next.start
                    update:
                        enumerable: no
                        value: (keepGoing) =>
                            callback = (event) =>
                                before = prev.before
                                decree => @response = police -> @response.join prev.response
                                prev.removeEventListener "response", callback
                                if keepGoing and prev.response.length
                                    (prev = do @prev).addEventListener "response", callback
                                    do prev.start
                            (prev = do @prev).addEventListener "response", callback
                            do prev.start

                Object.freeze this

Our `Rolodex.Request.prototype` inherits from `Request`, with additional dummy methods for the ones we define in our constructor.

            Object.defineProperty TimelineRequest, "prototype",
                configurable: no
                enumerable: no
                writable: no
                value: Object.freeze Object.create Request.prototype,
                    constructor:
                        enumerable: no
                        value: TimelineRequest
                    prev:
                        enumerable: no
                        value: ->
                    next:
                        enumerable: no
                        value: ->
                    loadMore:
                        enumerable: no
                        value: ->
                    update:
                        enumerable: no
                        value: ->

            return TimelineRequest


- - -

<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>INSTALLING.litcoffee</code></p>

#  USING LABORATORY  #

 - - -

##  Description  ##

Laboratory is written in Literate CoffeeScript, designed to compile to a single minified JavaScript file.
This file is available in [`/dist/laboratory.min.js`](../dist/laboratory.min.js).
If for some reason you feel the need to compile Laboratory from source yourself, the [`Cakefile`](../Cakefile) can be used to do so.

All of Laboratory's components are available through the `window.Laboratory` object, which this file provides.
Additionally, the `window.Laboratory.ready` property can be used to check if `LaboratoryInitializationReady` has already fired, and the `window.Laboratory.auth` property can be used to obtain the current [`Authorization`](Constructors/Authorization.litcoffee) object.
Laboratory doesn't have any external dependencies, and should run in any modern (ECMAScript 5–compliant; eg IE9) browser.

 - - -

##  Examples  ##

###  Basic Laboratory Template:

>   ```html
>   <!DOCTYPE html>
>   <title>My Laboratory Project</title>
>   <meta charset="utf-8">
>
>   <script type="text/javascript" src="laboratory.min.js"></script>
>
>   <script type="text/javascript">
>
>       function init () {
>           var request = new Laboratory.Authorization.Request({
>               origin: "https://myinstance.social",
>               name: "My Laboratory Client",
>               redirect: "/",
>               scope: Laboratory.Authorization.READWRITEFOLLOW
>           });
>           request.assign(run);
>           request.start();
>       }
>
>       function run () {
>           //  Project code.
>       }
>
>       if (typeof Laboratory !== "undefined" && Laboratory.ready) init();
>       else document.addEventListener("LaboratoryInitializationReady", init);
>
>   </script>
>   ```

 - - -

##  Implementation  ##

This script loads and runs the Laboratory engine.
Consequently, it is the last thing we load.

###  The Store:

Laboratory data is all stored in a single `Store`, and then acted upon through events and event listeners.
The store is not exposed to the window.

    Store = null

The `reset()` function resets our `Store` to its initial state.
It's very important that we return nothing from this function and don't accidentially expose our `Store` lol.

>   __[Issue #35](https://github.com/marrus-sh/laboratory/issues/35) :__
>   The internal representation of the `Store` may change in the future to support custom notifications, et cetera.

>   __[Issue #36](https://github.com/marrus-sh/laboratory/issues/36) :__
>   The internal representation of the `Store` may similarly change to support multiple simultaneous signins.

    do Laboratory.reset = reset = ->
        Store =
            auth: null
            notifications: {}
            profiles: {}
            statuses: {}
        return

Because Laboratory is still in active development, `window["🏪"]` can be used to gain convenient access to our store.
Obviously, you shouldn't expect this to last.

>   __Note :__
>   It's an emoji because you're not supposed to use it in production code.
>   Don't use it in production code lmao.

    window["🏪"] = Store

###  Loading Laboratory:

We now make our `Laboratory` object available to the window.

    Object.defineProperty window, "Laboratory",
        value: Object.freeze Laboratory
        enumerable: yes

Now that the `Laboratory` object is available, we can fire our `LaboratoryInitializationLoaded` event.

    dispatch "LaboratoryInitializationLoaded"

###  Running Laboratory:

The `run()` function runs Laboratory once the document has finished loaded.

    run = ->

####  Adding our listeners.

Our first task is to initialize our event handlers.
It's pretty easy; we just enumerate over `LaboratoryEvent.Handlers`.

        document.addEventListener handler.type, handler for handler in LaboratoryEvent.Handlers

####  Starting operations.

Finally, we fire our `LaboratoryInitializationReady` event, signalling that our handlers are ready to go.
We also set `Exposed.ready` to `true` so that scripts can tell Laboratory is running after-the fact.

        Exposed.ready = yes
        dispatch "LaboratoryInitializationReady"

####  Running asynchronously.

We don't want the store loading before `document.body` or any of our other scripts, so we'll attach a `window.onload` event handler if our document isn't currently loaded.
(If it is, then we'll just call `run` right now.)

    if document.readyState is "complete" then do run else window.addEventListener "load", run
