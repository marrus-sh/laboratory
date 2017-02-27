#  `Laboratory.Handlers.Store`  #

##  Coverage  ##

**The following events from `Store` have handlers:**

- `Store.Up`

##  Object Initialization  ##

    current = Laboratory.Handlers.Store = {}

##  Handlers  ##

###  `Store.Up`:

The `Store.Up` handler defines the root React component for our `Laboratory` engine and stores it in `document.Laboratory`.
We can't do this until our Laboratory store has been created because the engine requires the store to operate.
Of course, if our event isn't a `Store.Up` event then we don't want to handle it.

    current.Up = (event) ->

        return unless event? and this? and event.type is current.Up.type

The `Store.Up` handler is mostly just a wrapper for `彁 'Laboratory'` that provides it with the data that it needs to run, and then renders the final element in the React root.
The React root is determined according to the following rules:

1.  If there exists an element with id `"frontend"`, this will be used.
    This should be the case on Ardipithecus.

2.  If no such element exists, but there is at least one element of class name `"app-body"`, the first such element will be used.
    This should be the case on Mastodon.

3.  Otherwise, `document.body` is used as the React root.

We don't give our React components direct access to our store so there's quite a few properties we need to set instead.

        frontend = 彁 Laboratory.Components.Shared.productions.Laboratory,
            locale: @meta.locale
            accessToken: @meta.accessToken
            myAcct: @accounts[@meta.me]
            routerBase: @meta.routerBasename
            title: @site.title
            links: @site.links
            maxChars: @compose.maxChars
            defaultPrivacy: @compose.defaultPrivacy

        ReactDOM.render frontend, if (elt = document.getElementById("frontend")) then elt else if (elt = document.getElementsByClassName("app-body").item(0)) then elt else document.body

    current.Up.type = Laboratory.Events.Store.Up.type
    Object.freeze current.Up

##  Object Freezing  ##

    Object.freeze current
