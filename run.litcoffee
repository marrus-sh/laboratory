#  `run`  #

This script loads and runs the frontend.
Consequently, it should probably be the last thing you load.

##  Imports  ##

We need internationalization for our react components:

    {addLocaleData} = require "react-intl"
    en = require "react-intl/locale-data/en"
    de = require "react-intl/locale-data/de"
    es = require "react-intl/locale-data/es"
    fr = require "react-intl/locale-data/fr"
    pt = require "react-intl/locale-data/pt"
    hu = require "react-intl/locale-data/hu"
    uk = require "react-intl/locale-data/uk"

We also import `Howler` for some initial configuration.

    Howler = require "howler"

##  First Steps  ##

###  Freezing the Laboratory object:

We don't want nefarious entities meddling in our affairs, so let's freeze `研` and keep ourselves safe.

    冻 研[module] for module of 研
    冻 块[module] for module of 块

###  Disabling Howler:

Howler is used to manage Mastodon sounds.
By default, it sneakily enables sounds on mobile ASAP, but we don't actually want that lol.
So we disable it.

    Howler.mobileAutoEnable = false

###  Handling locale data:

This adds locale data so that our router can handle it:

    addLocaleData [en..., de..., es..., fr..., pt..., hu..., uk...]

##  The Store  ##

Laboratory data is all stored in a single store, and then acted upon through events and event listeners.
The store is not available outside of those events specified through `initialize`

###  Describing store data:

We will read in our store data using `Object.defineProperties`, but it is cumbersome to use property descriptors to define our entire initial store.
Consequently, we will treat `"key": value` as a synonym for `"key": {value: value, enumerable: true}` so long as none of `value`s own properties has a property descriptor property.
`propertyClone` handles this conversion while leaving the original object intact.

    propertyClone = (mixedobj) ->

The `objectDescribe()` function converts the object into a nested property definition.

        objectDescribe = (obj) ->
            此 = {}
            for own key, value of obj
                if value? and typeof value is "object"
                    if value instanceof Array then 此[key] = {value: value, enumerable: true}
                    else if (有(value, "configurable") or 有(value, "enumerable") or 有(value, "value") or 有(value, "writable"))
                        此[key] = value
                        此[key].value = objectDescribe(此[key].value) if 此[key].value? and typeof 此[key].value is "object" and not (此[key].value instanceof Array)
                    else 此[key] = {value: objectDescribe(value), enumerable: true}
                else 此[key] = {value: (value), enumerable: true}
            return 此

`objectDefine()` then iterates over this result to return the final object.

        objectDefine = (obj) ->
            此 = {}
            for own key, value of obj
                value.value = objectDefine value.value if typeof value.value is "object" and not (value.value instanceof Array)
            return 定定 此, obj

We string these functions together to get our final output.

        return objectDefine objectDescribe mixedobj


###  Loading the store:

We can now load the store.
We'll wrap this all in a closure to make extra sure that nobody has access to it except our handlers.

    run = ->

>   **ISSUE :**
>   Check to ensure that this hasn't already happened?

We generate our store from the JSON in `window.INITIAL_STATE` using `propertyClone`.

        store = propertyClone INITIAL_STATE

Now that our store is created, we can initialize our event handlers using it as input:

        理.initialize store

Finally, we fire the `Store.Up` event, which generates our engine and assigns it to `document.Laboratory` for later use.

        动.Store.Up()

        return

We don't want the store loading before `document.body`, so we'll attach a `DOMContentLoaded` event handler.

    听 "DOMContentLoaded", run
