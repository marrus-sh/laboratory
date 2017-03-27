<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.4.0</i> <br> <code>INSTALLING.litcoffee</code></p>

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

##  Implementation  ##

This script loads and runs the Laboratory engine.
Consequently, it is the last thing we load.

###  The Store:

Laboratory data is all stored in a single `Store`, and then acted upon through events and event listeners.
The store is not exposed to the window.

    Store =
        auth: null
        notifications: {}
        profiles: {}
        statuses: {}

Because Laboratory is still in active development, `window["🏪"]` can be used to gain convenient access to our store.
Obviously, you shouldn't expect this to last.

>   __Note :__
>   It's an emoji because you're not supposed to use it in production code.
>   Don't use it in production code lol.

    window["🏪"] = Store

###  Loading Laboratory:

We now make our `Laboratory` object available to the window.

    Object.defineProperty window, "Laboratory",
        value: Object.freeze Laboratory
        enumerable: yes

Now that the `Laboratory` object is available to the `window`, we can fire our `LaboratoryInitializationLoaded` event.

    dispatch "LaboratoryInitializationLoaded"

###  Running Laboratory:

The `run()` function runs Laboratory once the document has finished loaded.

    run = ->

####  Adding our listeners.

Our first task is to initialize our event handlers.
It's pretty easy; we just enumerate over `LaboratoryEvent.Handlers`.

        listen handler.type, handler for handler in LaboratoryEvent.Handlers

####  Starting operations.

Finally, we fire our `LaboratoryInitializationReady` event, signalling that our handlers are ready to go.
We also set `Exposed.ready` to `true` so that scripts can tell Laboratory is running after-the fact.

        Exposed.ready = yes
        dispatch "LaboratoryInitializationReady"

####  Running asynchronously.

We don't want the store loading before `document.body` or any of our other scripts, so we'll attach a `window.onload` event handler if our window isn't currently loaded.
(If it is, then we'll just call `run` right now.)

    if document.readyState is "complete" then run() else window.addEventListener "load", run
