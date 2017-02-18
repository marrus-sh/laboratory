#  `run`  #

This script loads and runs the frontend.
Consequently, it should probably be the last thing you load.

##  Imports  ##

As this script activates everything else, it has a number of imports.
First, we need to import our event handlers:

    `import initializeHandlers from './scripting/handlers';`

We will need the `LaboratoryStoreUp` event to signal that our store has been created:

    `import {LaboratoryStoreUp} from './scripting/events/LaboratoryStore';`

`useRouterHistory` gives us access to the React router:

    `import useRouterHistory from 'react-router';`

We also need internationalization for our react components:

    `import {addLocaleData} from 'react-intl';
    import en from 'react-intl/locale-data/en';
    import de from 'react-intl/locale-data/de';
    import es from 'react-intl/locale-data/es';
    import fr from 'react-intl/locale-data/fr';
    import pt from 'react-intl/locale-data/pt';
    import hu from 'react-intl/locale-data/hu';
    import uk from 'react-intl/locale-data/uk';`

There are two final functions we need: one to create a WebSocket stream, and one to manage our browser history.
We also import `Howler` for some initial configuration.

    `import createStream from 'scripting/scripts/stream';
    import createBrowserHistory from 'history/lib/createBrowserHistory';
    import Howler from 'howler';`

##  First Steps  ##

###  Disabling Howler:

Howler is used to manage Mastodon sounds.
By default, it sneakily enables sounds on mobile ASAP, but we don't actually want that lol.
So we disable it.

    Howler.mobileAutoEnable = false

###  Tracking browser history:

There are a few more things we need to initialize.
Our browser history is the first…

    browserHistory = useRouterHistory(createBrowserHistory) {basename: '/web'}

###  Handling locale data:

…our locale data is the second.

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

If our application has already been created, then we shouldn't be running this function!

        if (document.Laboratory) return

We generate our store from the JSON in `window.INITIAL_STATE` using `objectDescribe`.

        store = {}
        Object.defineProperties store, objectDescribe JSON.parse INITIAL_STATE

Now that our store is created, we can initialize our event handlers using it as input:

        initializeHandlers store

Finally, we fire the `LaboratoryStoreUp` event, which generates our engine and assigns it to `document.Laboratory` for later use.

        document.dispatchEvent LaboratoryStoreUp

We don't want the store loading before `document.body`, so we'll attach a `DOMContentLoaded` event handler.

    document.addEventListener "DOMContentLoaded", run, false
