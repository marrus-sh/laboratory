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

We don't want nefarious entities meddling in our affairs, so let's freeze `Laboratory` and keep ourselves safe.

    Object.freeze Laboratory[module] for module of Laboratory
    for module of Laboratory.Components
        Object.freeze Laboratory.Components[module].parts
        Object.freeze Laboratory.Components[module].productions

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

###  Loading the store:

We can now load the store.
We'll wrap this all in a closure to make extra sure that nobody has access to it except our handlers.

    run = ->

We generate our store from `window.INITIAL_STATE` by pulling the following attributes.
Most of these properties are set as non-writable and non-configurable, but there are some exceptions.
Notably, account objects are immutable but their properties are not.

The `apiURL` attribute is just the generic Mastodon API for now but we're setting it here anyway.

        return unless INITIAL_STATE?

        store = Object.defineProperties {},
            meta:
                value: Object.freeze
                    accessToken: INITIAL_STATE.meta.access_token
                    apiURL: "/api/v1/"
                    locale: INITIAL_STATE.meta.locale
                    routerBasename: INITIAL_STATE.meta.router_basename
                    me: INITIAL_STATE.meta.me
                enumerable: true
            site:
                value: Object.freeze
                    title: INITIAL_STATE.site.title
                    links: do ->
                        links = {}
                        links[name] = link for own name, link of INITIAL_STATE.site.links
                        return links
                enumerable: true
            compose:
                value: Object.seal Object.defineProperties {},
                    defaultPrivacy:
                        value: INITIAL_STATE.compose.default_privacy
                        writable: true
                        enumerable: true
                    maxChars:
                        value: INITIAL_STATE.compose.max_chars
                        enumerable: true
                enumerable: true
            accounts:
                value: do ->
                    accounts = JSON.parse JSON.stringify INITIAL_STATE.accounts
                    Object.defineProperty(accounts, index, {value: Object.seal account, enumerable: true}) for account, index in accounts
                    return accounts
                enumerable: true
            timelines:
                value: {}
                enumerable: true
            interfaces:
                value: Object.freeze
                    accounts: {}
                    notifications: {}
                    timelines: {}
                enumerable: true

        window.store = store

Once our store is created, we delete window.INITIAL_STATE to ensure that this function isn't somehow called more than once.

        delete window.INITIAL_STATE

###  Adding our listeners:

Now that our store is created, we can initialize our event handlers, binding them to its value.
It's pretty easy; we just enumerate over `Laboratory.Handlers`.

        for category, object of Laboratory.Handlers
            document.addEventListener handler.type, handler.bind store for name, handler of object

###  Firing our first event:

Finally, we fire the `Store.Up` event, which generates our engine and assigns it to `document.Laboratory` for later use.

        Laboratory.Events.Store.Up()

        return

###  Running asynchronously:

We don't want the store loading before `document.body` or any of our other scripts, so we'll attach a `window.onload` event handler.

    window.addEventListener "load", run
