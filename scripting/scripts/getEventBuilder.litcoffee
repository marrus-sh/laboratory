#  `/scripting/scripts/getEventBuilder`  #

The `getEventBuilder` module contains a function used to generate event constructors on-the-fly.

##  The Function  ##

Laboratory events are just `CustomEvent` instances built using special functions created with `getEventBuilder`.
All these functions do is create a new `CustomEvent` with the given properties.
`getEventBuilder` takes two arguments: `type` gives the name of the event, and `data` is an object listing the valid properties for the event alongside their default values.

    getEventBuilder = (type, data) ->

`type` needs to be a string and `data` needs to be an object; we'll just use `String()` and `Object()` to ensure this is the case.
Furthermore `data` shouldn't contain the property `_builder`; if it does, this property will be ignored.

        type = String type
        data = Object data

###  Defining the event constructor:

Our event constructor simply creates a new `CustomEvent` and assigns it the necessary properties.
It sets the properties provided in `data` using `props`.
The `_builder` property is special and contains a reference to the event builder.

        result = (props) ->
            detail = {}
            for name, initial of data
                Object.defineProperty detail, name,
                    value: if props? and props[name]? and name isnt '_builder' then props[name] else initial
                    enumerable: name isnt '_builder'
            new CustomEvent type, {detail: detail}

        Object.defineProperty data, "_builder",
            value: result
            enumerable: true

        return result

##  Exports  ##

This module just exports the `getEventBuilder` function.

    `export default getEventBuilder`
