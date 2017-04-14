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
