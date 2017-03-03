#  LABORATORY CONSTRUCTORS  #

Laboratory has a number of constructors for various objects that you might encounter through interacting with the engine.
Using constructors makes it easy to check if an object is of the requested type; simply use `instanceof`.
However Laboratory never expects you to make use of its constructors in your own code.
This documentation exists to give you an idea of what properties and methods are available for Laboratory objects.

Of the Laboratory constructors, there is one which is mostly just for internal use; namely [`LaboratoryEvent()`](LaboratoryEvent.litcoffee).
You are welcome to use this constructor for your own purposes if you want, but note that any events you create using `LaboratoryEvent()` won't be picked up on by the Laboratory engine proper.

The other constructors all represent objects which you are likely to see in your callbacks and responses.
These are:

- [**Application**](Application.litcoffee)
- [**Enumeral**](Enumeral.litcoffee)
- [**Follow**](Follow.litcoffee)
- [**MediaAttachment**](MediaAttachment.litcoffee)
- [**Mention**](Mention.litcoffee)
- [**Post**](Post.litcoffee)
- [**Profile**](Profile.litcoffee)

##  Implementation  ##

Here we set up our internal `Constructors` object.
The own properties of this object will be copied to our global `window.Laboratory` object later.

    Constructors = {}

###  `CustomEvent()`:

`CustomEvent()` is required for our `LaboratoryEvent()` constructor.
This is a CoffeeScript re-implementation of the polyfill available on [the MDN](https://developer.mozilla.org/en-US/docs/Web/API/CustomEvent/CustomEvent).

    do ->

        return if typeof CustomEvent is "function"

        CustomEvent = (event, params) ->
            params = params or {bubbles: false, cancelable: false, detail: undefined}
            e = document.createEvent "CustomEvent"
            e.initCustomEvent event, params.bubbles, params.cancelable, params.detail
            return e
        CustomEvent.prototype = window.Event.prototype
        Object.freeze CustomEvent
        Object.freeze CustomEvent.prototype
