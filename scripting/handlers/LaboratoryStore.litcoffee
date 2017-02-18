#  `scripting/handlers/LaboratoryStore`  #

##  Coverage  ##

**The following events from `LaboratoryStore` have handlers:**

- `LaboratoryStoreUp`

##  Handlers  ##

###  `LaboratoryStoreUpHandler`:

The `LaboratoryStoreUp` handler defines the root React component for our `Laboratory` engine and stores it in `document.Laboratory`.
We can't do this until our Laboratory store has been created because the engine requires the store to operate.
Of course, if our event isn't a `LaboratoryStoreUp` event then we don't want to handle it.

    LaboratoryStoreUpHandler = (event, store) ->

        return unless event? and store? and event.type = LaboratoryStoreUpHandler.forType

The `LaboratoryStoreUp` handler is just a wrapper for `目 'Laboratory'` that provides it with access to our access token and locale data, and then renders the final element in the React root.
The React root is determined according to the following rules:

1.  If there exists an element with id `"frontend"`, this will be used.
    This should be the case on Ardipithecus.

2.  If no such element exists, but there is at least one element of class name `"app-body"`, the first such element will be used.
    This should be the case on Mastodon.

3.  Otherwise, `document.body` is used as the React root.

        Laboratory = 目 'Laboratory',
            locale: store.meta.locale
            accessToken: store.meta.accessToken

        ReactDOM.render Laboratory, if (elt = document.getElementById("frontend")) then elt else if (elt = document.getElementsByClassName("app-body").item(0)) then elt else document.body

    Object.defineProperty LaboratoryStoreUpHandler, "forType", {value: "LaboratoryStoreUp"}

##  Exports  ##

The only thing we have to export is our `LaboratoryStoreUpHandler`:

    `export {LaboratoryStoreUpHandler};`
