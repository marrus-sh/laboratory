#  `run`  #

This script loads and runs the frontend.
Consequently, it should probably be the last thing you load.

##  First Steps  ##

###  Freezing the Laboratory object:

We don't want nefarious entities meddling in our affairs, so let's freeze `Laboratory` and keep ourselves safe.

    Object.freeze Laboratory[module] for module of Laboratory
    for module of Laboratory.Components
        Object.freeze Laboratory.Components[module].parts
        Object.freeze Laboratory.Components[module].productions

###  Handling locale data:

This adds locale data so that our router can handle it:

    ReactIntl.addLocaleData [ReactIntlLocaleData.en..., ReactIntlLocaleData.de..., ReactIntlLocaleData.es..., ReactIntlLocaleData.fr..., ReactIntlLocaleData.pt..., ReactIntlLocaleData.hu..., ReactIntlLocaleData.uk...]

##  The Store  ##

Laboratory data is all stored in a single store, and then acted upon through events and event listeners.
The store is not available outside of those events specified through `initialize`

###  Loading the store:

We can now load the store.
We'll wrap this all in a closure to make extra sure that nobody has access to it except our handlers.

    run = ->

We initialize our store based on information provided in the `data-laboratory-config` attribute of our document's root element.
This data should be a JSON object.
For vanilla Mastodon installs, this information will be stored in the `window.INITIAL_STATE` object instead.

        config = JSON.parse(document.documentElement.getAttribute "data-laboratory-config")
        if not config
            if INITIAL_STATE? then config =
                baseName: INITIAL_STATE.meta.router_basename
                locale: INITIAL_STATE.meta.locale
            else config = {}

One item of note in our store is the entry `config.root`, which contains the React root.
The React root is determined according to the following rules:

1.  If the `config` object loaded above has a `root` property, the object whose id matches the string value of this property will be used.

2.  If there exists an element with id `"frontend"`, this will be used.
    This should be the case on Ardipithecus.

3.  If no such element exists, but there is at least one element of class name `"app-body"`, the first such element will be used.
    This should be the case on Mastodon.

4.  Otherwise, `document.body` is used as the React root.

As you can see, we also initialize a number of other data structures at this time.

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
            config: Object.freeze
                baseName: do (config) ->
                    a = document.createElement "a"
                    a.href = config.baseName || "."
                    return a.pathname
                locale: config.locale
                useBrowserHistory: config.useBrowserHistory or not config.useBrowserHistory?
                root: switch
                    when config.root and (elt = document.getElementById String config.root) then elt
                    when (elt = document.getElementById "frontend") then elt
                    when (elt = document.getElementsByClassName("app-body").item 0) then elt
                    else document.body
            interfaces: Object.freeze
                accounts: {}
                notifications: []
                timelines: {}
            notifications: Object.freeze
                itemOrder: Object.freeze []
                items: Object.freeze {}
            site: Object.seal
                title: undefined
                links: undefined
                maxChars: undefined
            timelines: {}

        window.store = store

###  Adding our listeners:

Now that our store is created, we can initialize our event handlers, binding them to its value.
It's pretty easy; we just enumerate over `Laboratory.Handlers`.

        for category, object of Laboratory.Handlers
            document.addEventListener handler.type, handler.bind store for name, handler of object

###  Rendering the sign-in form:

Finally, we render our initial sign-in form to allow the user to sign into the instance of their choice.

        ReactDOM.render 彁(Laboratory.Components.Shared.productions.InstanceQuery, {locale: store.config.locale}), store.config.root

        return

###  Running asynchronously:

We don't want the store loading before `document.body` or any of our other scripts, so we'll attach a `window.onload` event handler.

    window.addEventListener "load", run
