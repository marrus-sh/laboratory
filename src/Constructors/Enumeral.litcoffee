<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.4.0</i> <br> <code>Constructors/Enumeral.litcoffee</code></p>

#  LABORATORY ENUMERALS  #

 - - -

##  Description  ##

If you have experience working with JavaScript and the DOM, you may have encountered DOM attributes whose values are described by an enumerated type.
For example, `Node.NodeType` can have values which include `Node.ELEMENT_NODE`, with a value of `1`, and `Node.TEXT_NODE`, with a value of `3`.
__Laboratory enumerals__ are an extension of this principle.
They aim to accomplish these things:

1.  **Provide a unique, static identifier for a response value.**
    Laboratory enumerals are unique, immutable objects that do not equate to anything but themselves under strict (`===`) equality.

2.  **Allow checking of specific properties using binary flags.**
    Laboratory enumerals compute to numbers which are non-arbitrary in their meaning.
    You can use binary tests to check for specific enumeral properties; for example, `visibility & Laboratory.Post.Visibility.LISTED` can be used to tell if a given `visibility` is listed or not.

3.  **Provide easy type identification.**
    Each Laboratory enumeral is an instance of the object in which it is contained.
    Thus, `Laboratory.PostType.STATUS instanceof Laboratory.PostType` evaluates to `true`.

4.  **Guarantee uniqueness of value.**
    It is guaranteed that no two enumerals of a given type will share the same value.

###  Enumeral types:

Enumeral types can be created by calling `Enumeral.generate()` with an object whose properties and values give the names and values for the resultant enumerals, like so:

>   ```javascript
>   MyType = Enumeral.generate({
>       TYPE_A: 1
>       TYPE_B: 2
>       TYPE_AB: 3
>       TYPE_C: 4
>       TYPE_F: 32
>   });
>   console.log(MyType.TYPE_A instanceof MyType && MyType.TYPE_A == 1 && !(MyType.TYPE_A === 1)); // -> `true`
>   ```

Further discussion of specific enumeral types takes place in the various files in which they are defined.

####  `fromValue()`.

>   ```javascript
>   MyType.fromValue(n);
>   ```
>
>   - __`n` :__ An integer value

The `fromValue()` method of an enumeral type can be used to get the enumeral associated with the given value.

 - - -

##  Implementation  ##

We implement `Enumeral` inside of a closure to prevent it from functioning outside of the context of `Enumeral.generate()`.

    Laboratory.Enumeral = Enumeral = null
    do ->

        generator = off

###  The constructor:

The `Enumeral()` constructor takes a numeric `value`, which the resultant enumeral will compute to.

        Laboratory.Enumeral = Enumeral = (value) ->

            unless generator
                throw new TypeError "Laboratory Error : The `Enumeral()` constructor cannot be
                    called directly—try `Enumeral.generate()` instead"
            unless this and this instanceof Enumeral
                throw new Error "Laboratory Error : `Enumeral()` must be called as a
                    constructor"

            @value = value | 0
            return Object.freeze this

###  The prototype:

The `Enumeral` prototype overwrites `valueOf()` to allow for easy numeric conversion.
It also adjusts `toString()` and `toSource()` slightly.

        Object.defineProperty Enumeral, "prototype",
            value: Object.freeze
                toString: -> "Enumeral(" + @value + ")"
                toSource: ->"Enumeral(" + @value + ")"
                valueOf: -> @value

###  Generating enumerals:

The `generate()` function creates an `Enumeral` type that meets our specifications.
The provided `data` should be an object whose enumerable own properties associate enumeral names with values.

        Enumeral.generate = (data) ->

First, we need to "fork" the main `Enumeral` constructor so that typechecking will work.
We create a new constructor that just passes everything on.

            type = (n) -> Enumeral.call this, n
            type.prototype = Object.create Enumeral.prototype

Next, we define our enumerals.
We also create a hidden object which store the relationship going the other way.
Note that since values are not guaranteed to be unique, this object may not contain every enumeral (some might be overwritten).

            generator = on
            byValue = {}
            for own enumeral, value of data
                continue if byValue[value]?
                type[enumeral] = new type value
                byValue[value] = type[enumeral]
            generator = off

This function allows quick conversion from value to enumeral.

            type.fromValue = (n) -> byValue[n | 0]

We can now freeze our enumerals and return them.

            return Object.freeze type
