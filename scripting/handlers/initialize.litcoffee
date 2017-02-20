#  `理.initialize()`  #

##  Handler initialization  ##

The function `理.initialize()` adds event listeners to our handler functions and provides them with access to our store.
We use `Object.defineProperty` to set it because it shouldn't be enumerable.

     定 理, "initialize",
        value: (store) ->

###  Convenience functions:

The handy `using()` function packages our store with an event before calling its related handler.

            using = (fn) -> (event) -> fn event, store

The `listen()` function associates an event listener with an event handler—provided they have the same type, of course.

            listen = (handler) -> 听 handler.type, using(handler)

###  Adding our listeners:

It's pretty easy; we just enumerate over `理`.

            for category, object of 理
                listen handler for name, handler of object

            return
