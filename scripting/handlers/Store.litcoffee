#  `理.Store`  #

##  Coverage  ##

**The following events from `Store` have handlers:**

- `Store.Up`

##  Object Initialization  ##

    此 = 理.Store = {}

##  Handlers  ##

###  `Store.Up`:

The `Store.Up` handler defines the root React component for our `Laboratory` engine and stores it in `document.Laboratory`.
We can't do this until our Laboratory store has been created because the engine requires the store to operate.
Of course, if our event isn't a `Store.Up` event then we don't want to handle it.

    此.Up = (event, store) ->

        return unless event? and store? and event.type is 此.Up.type

The `Store.Up` handler is just a wrapper for `目 'Laboratory'` that provides it with access to our access token and locale data, and then renders the final element in the React root.
The React root is determined according to the following rules:

1.  If there exists an element with id `"frontend"`, this will be used.
    This should be the case on Ardipithecus.

2.  If no such element exists, but there is at least one element of class name `"app-body"`, the first such element will be used.
    This should be the case on Mastodon.

3.  Otherwise, `document.body` is used as the React root.

        Laboratory = 目 论.Laboratory,
            locale: store.meta.locale
            accessToken: store.meta.access_token
            title: store.site.title

        ReactDOM.render Laboratory, if (elt = document.getElementById("frontend")) then elt else if (elt = document.getElementsByClassName("app-body").item(0)) then elt else document.body

    此.Up.type = 动.Store.Up.type
    冻 此.Up

##  Object Freezing  ##

    冻 此
