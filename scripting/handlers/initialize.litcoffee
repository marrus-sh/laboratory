#  `研.handlers.initialize()`  #

##  Handler initialization  ##

The function `研.handlers.initialize()` adds event listeners to our handler functions and provides them with access to our store.
We use `Object.defineProperty` to set it because it shouldn't be enumerable.

     Object.defineProperty 研.handlers, "initialize",
        value: (store) ->

###  Convenience functions:

The handy `using()` function packages our store with an event before calling its related handler.

            using = (fn) -> (event) -> fn event, store

The `listen()` function associates an event listener with an event handler—provided they have the same type, of course.

            listen = (handler) -> document.addEventListener handler.type, using(handler), false

###  Adding our listeners:

It's pretty easy; we just enumerate over `研.handlers`.

            for category, object of 研.handlers
                listen handler for name, handler of object
