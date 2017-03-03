#  INSTALLING  #

Laboratory is written in Literate CoffeeScript, designed to compile to a single minified JavaScript file.
This file is available in [`/dist/laboratory.min.js`](../dist/laboratory.min.js).
If for some reason you feel the need to compile Laboratory from source yourself, the [`Cakefile`](../Cakefile) can be used to do so.

All of Laboratory's components are available through the `window.Laboratory` object, which this file provides.
Laboratory doesn't have any external dependencies, and should run in any modern (ECMAScript 5–compliant; eg IE9) browser.

##  Implementation  ##

This script loads and runs the Laboratory engine.
Consequently, it is the last thing we load.

###  First steps:

We include informative text about the `Laboratory` package on `Laboratory.ℹ` and give the version number on `Laboratory.Nº` for intersted parties.
Laboratory follows semantic versioning, which translates into `Nº` as follows: `Major * 100 + Minor + Patch / 100`.
Laboratory thus assures that minor and patch numbers will never exceed `99` (indeed this would be quite excessive!).

    Laboratory =
        ℹ: """
                ............. LABORATORY ..............

                A client-side API for Mastodon, a free,
                   open-source social network server
                          - - by Kibigo! - -

                    Licensed under the MIT License.
                       Source code available at:
                https://github.com/marrus-sh/laboratory

                            Version 0.1.0
            """
        Nº: 1.0

####  Exposing Laboratory objects.

We don't expose *all* of Laboratory to the `window`—just the useful bits for extensions.
Thus, the following parts are exposed:

- `Constructors`
- `Events`
- `Enumerals`

The following parts are *not* exposed:

- Local functions/variables
- `Handlers`

To keep things compact, we merge everything onto a single `Laboratory` object.
This of course means that none of the submodules in `Constructors`, `Events`, or `Enumerals` can share the same name.

    for module in [Constructors, Events, Enumerals]
        Object.defineProperty Laboratory, name, {value: submodule, enumerable: yes} for own name, submodule of module
    Object.defineProperty window, "Laboratory",
        value: Object.freeze Laboratory
        enumerable: yes

####  Declaring our objects have loaded.

Now that the `Laboratory` object is available to the `window`, we can fire our `Initialization.Loaded` event.

    Initialization.Loaded.dispatch()

###  The Store:

Laboratory data is all stored in a single store, and then acted upon through events and event listeners.
The store is not available outside of those events specified below.

####  Loading the store.

We can now load the store.
We'll wrap this all in a closure to make extra sure that nobody has access to it except our handlers.

    run = ->

        store = Object.freeze
            accounts: {}
            auth: Object.seal
                accessToken: null
                api: null
                clientID: null
                clientSecret: null
                me: null
                origin: null
                redirect: null
            interfaces: Object.freeze
                accounts: {}
                composer: []
                timelines: {}
            timelines: {}

Because Laboratory is still in active development, `window["🏪"]` can be used to gain convenient access to our store.
Obviously, you shouldn't expect this to last.

        window["🏪"] = store

####  Adding our listeners.

Now that our store is created, we can initialize our event handlers, binding them to its value.
It's pretty easy; we just enumerate over `Handlers`.

        for category, object of Handlers
            document.addEventListener handler.type, handler.bind store for name, handler of object

####  Starting operations.

Finally, we fire our `Initialization.Ready` event, signalling that our handlers are ready to go.

        Initialization.Ready.dispatch()

        return

####  Running asynchronously.

We don't want the store loading before `document.body` or any of our other scripts, so we'll attach a `window.onload` event handler if our window isn't currently loaded.
(If it is, then we'll just call `run` right now.)

    if document.readyState is "complete" then run() else window.addEventListener "load", run
