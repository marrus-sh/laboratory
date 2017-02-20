#  `动.newBuilder`  #

The `newBuilder()` function is used to generate event constructors on-the-fly.

##  The Function  ##

Laboratory events are just `CustomEvent` instances built using special functions ("builders") created with `newBuilder()`.
All these functions do is create a new `CustomEvent` with the given properties.
`newBuilder()` takes two arguments: `type` gives the name of the event, and `data` is an object listing the valid properties for the event alongside their default values.
We use `Object.defineProperty` because this shouldn't be enumerable.

    Object.defineProperty 动, "newBuilder",
        value: (type, data) ->

`type` needs to be a string and `data` needs to be an object; we'll just use `String()` and `Object()` to ensure this is the case.
Furthermore `data` shouldn't contain the property `_builder`; if it does, this property will be ignored.

            type = String type
            data = Object data

###  Defining the event builder:

Our event builder simply creates a new `CustomEvent` and assigns it the necessary properties.
It then dispatches that event to `document` when it's done.
It sets the properties provided in `data` using `props`.
The `_builder` property is special and contains a reference to the event builder.

            此 = (props) ->
                detail = {}
                for name, initial of data
                    定 detail, name,
                        value: if props? and props[name]? and name isnt '_builder' then props[name] else initial
                        enumerable: name isnt '_builder'
                页.dispatchEvent new CustomEvent type, {detail: detail}
                return

            此.type = type
            冻 此

            定 data, "_builder",
                value: 此
                enumerable: true

            return 此
