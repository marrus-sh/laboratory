#  `/scripting/handlers`  #

##  Imports  ##

In order to handle our events, we need to load all of our event handlers.
Here they are:

    `import * from './LaboratoryStore';`

##  Handler initialization  ##

The function `initializeHandlers()` adds event listeners to our handler functions and provides them with access to our store.

    initializeHandlers = (store) ->

###  Convenience functions:

The handy `using()` function packages our store with an event before calling its related handler.

        using = (fn) -> (event) -> fn event, store

The `listen()` function associates an event listener with an event handler—provided the event listener has the `forType` property set.

        listen = (fn) -> document.addEventListener fn.forType, using(fn), false

We can now add all of our event listeners.

        listen LaboratoryStoreUpHandler

        listen LaboratoryOpenHandler
        listen LaboratoryCloseHandler
        listen LaboratoryMessageHandler
        listen LaboratoryErrorHandler

##  Exports  ##

The only thing we're exporting here is our `initializeHandlers()` funciton.

    `export default initializeHandlers;`
