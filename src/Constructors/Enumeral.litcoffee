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
>   console.log(
>       MyType.TYPE_A instanceof MyType &&  //  TYPE_A is an instance of MyType
>       MyType.TYPE_A == 1 &&               //  TYPE_A.valueOf() is 1
>       !(MyType.TYPE_A === 1)              //  But TYPE_A isn't 1
>   );  //  `true`
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

##  Examples  ##

>   __[Issue #53](https://github.com/marrus-sh/laboratory/issues/53) :__
>   Usage examples for constructors are forthcoming.

 - - -

##  Implementation  ##

###  The constructor:

The `Enumeral()` constructor takes a numeric `value`, which the resultant enumeral will compute to.

    Enumeral = (value) ->

        throw new TypeError "this is not a Enumeral" unless this and this instanceof Enumeral

        @value = value | 0
        return Object.freeze this

###  The dummy:

External scripts don't actually get to access the `Enumeral()` constructor.
Instead, we feed them a dummy function with the same prototype—so `instanceof` will still match.
(The prototype is set in the next section.)

    Laboratory.Enumeral = (value) -> throw new TypeError "Illegal constructor"

###  The prototype:

The `Enumeral` prototype overwrites `valueOf()` to allow for easy numeric conversion.
It also adjusts `toString()` and `toSource()` slightly.
You'll note that `Enumeral.prototype.constructor` gives our dummy constructor, not the real one.

    Object.defineProperty Enumeral, "prototype",
        configurable: no
        enumerable: no
        writable: no
        value: Object.freeze Object.defineProperties {},
            constructor:
                enumerable: no
                value: Laboratory.Enumeral
            toString:
                enumerable: no
                value: -> "Enumeral(" + @value + ")"
            toSource:
                enumerable: no
                value: -> "Enumeral(" + @value + ")"
            valueOf:
                enumerable: no
                value: -> @value
    Object.defineProperty Laboratory.Enumeral, "prototype",
        configurable: no
        enumerable: no
        writable: no
        value: Enumeral.prototype

###  Generating enumerals:

The `generate()` constructor method creates an `Enumeral` type that meets our specifications.
The provided `data` should be an object whose enumerable own properties associate enumeral names with values.

    Enumeral.generate = (data) ->

First, we need to "fork" the main `Enumeral` constructor so that typechecking will work.
We create a new constructor that just passes everything on.

        type = (n) -> Enumeral.call this, n
        type.prototype = Object.create Enumeral.prototype

Next, we define our enumerals.
We also create a hidden object which store the relationship going the other way.
Note that since values are not guaranteed to be unique, this object may not contain every enumeral (some might be overwritten).

        byValue = {}
        for own enumeral, value of data
            continue if byValue[value]?
            type[enumeral] = new type value
            byValue[value] = type[enumeral]

This function allows quick conversion from value to enumeral.

        type.fromValue = (n) -> byValue[n | 0]

We can now freeze our enumerals and return them.

        return Object.freeze type
