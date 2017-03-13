#  THE LABORATORY EVENT CONSTRUCTOR  #

The `LaboratoryEvent()` constructor creates a new event builder, with an assigned `type` and default `props`.
Calling the `new()` function on an event builder returns a new `CustomEvent`, while calling `dispatch()` both creates and dispatches said event—by default, to the `document`.

##  Implementation

###  The constructor:

The `LaboratoryEvent()` constructor takes a string `type`, which names the event, and an object `props`, which defines its default `detail`.
It adds `_builder` as a default property, which is a reference to itself.

    Constructors.LaboratoryEvent = (type, props) ->

        return unless this and (this instanceof Constructors.LaboratoryEvent)

        @type = String type
        @defaultProps = Object props
        Object.defineProperty @defaultProps, "_builder",
            value: this
            enumerable: yes
        Object.freeze @defaultProps
        Object.defineProperties this,
            new:
                value: Constructors.LaboratoryEvent.prototype.new.bind this
            dispatch:
                value: Constructors.LaboratoryEvent.prototype.dispatch.bind this

        return Object.freeze this

###  The prototype:

    Object.defineProperty Constructors.LaboratoryEvent, "prototype",
        value: Object.freeze

####  `new()`.

The `new()` prototype function simply takes the provided `props` and copies them over to a `detail`, which it assigns to a new `CustomEvent` of type `@type`.
Only those properties which exist in an instance's `@defaultProps` are considered.

            new: (props) ->

                return unless this instanceof Constructors.LaboratoryEvent

                detail = {}

                for name, initial of @defaultProps
                    Object.defineProperty detail, name,
                        value: if props? and props[name]? and name isnt '_builder' then props[name] else initial
                        enumerable: name isnt '_builder'

                return new CustomEvent @type, {detail: Object.freeze detail}

####  `dispatch()`.

The `dispatch()` prototype function calls `new()` with the given `props`, and then immediately dispatches the resulting event at the provided `location`.
By default, it will dispatch to `document`.

            dispatch: (props, location) ->

                location = document unless location?.dispatchEvent?
                return unless (location.dispatchEvent instanceof Function) and (this instanceof Constructors.LaboratoryEvent)

                location.dispatchEvent @new(props)

                return
