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

    Object.freeze 研[module] for module of 研
    Object.freeze 研.components[module] for module of 研.components

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
Consequently, we will treat `"key": value` as a synonym for `"key": {value: value}` so long as none of `value`s own properties has a property descriptor property.
The `objectDescribe()` function handles this conversion.

    objectDescribe = (obj) ->
        for own key, value of obj
            if typeof value is "object" and not (value.hasOwnProperty("configurable") or value.hasOwnProperty("enumerable") or value.hasOwnProperty("value") or value.hasOwnProperty("writable") or value.hasOwnProperty("get") or value.hasOwnProperty("set")) then obj[key] = objectDescribe value
            else obj[key] = {value: value} unless typeof value is "object"
        return obj

###  Loading the store:

We can now load the store.
We'll wrap this all in a closure to make extra sure that nobody has access to it except our handlers.

    run = ->

>   **ISSUE :**
>   Check to ensure that this hasn't already happened?

We generate our store from the JSON in `window.INITIAL_STATE` using `objectDescribe`.

        store = {}
        Object.defineProperties store, objectDescribe JSON.parse INITIAL_STATE

Now that our store is created, we can initialize our event handlers using it as input:

        研.handlers.initialize store

Finally, we fire the `LaboratoryStore.StoreUp` event, which generates our engine and assigns it to `document.Laboratory` for later use.

        document.dispatchEvent 研.events.LaboratoryStore.StoreUp

We don't want the store loading before `document.body`, so we'll attach a `DOMContentLoaded` event handler.

    document.addEventListener "DOMContentLoaded", run, false
