#  LABORATORY ENUMERALS  #

If you have experience working with JavaScript and the DOM, you may have encountered DOM attributes whose values are described by an enumerated type.
For example, `Node.NodeType` can have values which include `Node.ELEMENT_NODE`, with a value of `1`, and `Node.TEXT_NODE`, with a value of `3`.
__Laboratory enumerals__ are an extension of this principle.
They aim to accomplish three things:

1.  **Provide a unique, static identifier for a response value.**
    Laboratory enumerals are unique, immutable objects that do not equate to anything but themselves under strict (`===`) equality.

2.  **Allow checking of specific properties using binary flags.**
    Laboratory enumerals compute to numbers which are non-arbitrary in their meaning.
    You can use binary tests to check for specific enumeral properties; for example, `visibility & Laboratory.Visibility.Listed` can be used to tell if a given `visibility` is listed or not.

3.  **Provide easy type identification.**
    Each Laboratory enumeral is an instance of the object in which it is contained.
    Thus, `Laboratory.PostType.STATUS instanceof Laboratory.PostType` evaluates to `true`.

The types of enumerals, and descriptions of their specific properties, are given below:

- [**MediaType**](MediaType.litcoffee)
- [**PostType**](PostType.litcoffee)
- [**Relationship**](Relationship.litcoffee)
- [**Visibility**](Visibility.litcoffee)

##  Implementation  ##

Here we set up our internal `Enumerals` object.
The own properties of this object will be copied to our global `window.Laboratory` object later.

    Enumerals = {}

###  `generateEnumerals()`:

The `generateEnumerals()` function creates an `Enumerals` type that meets our specifications.
The provided `data` should be an object whose enumerable own properties associate enumeral names with values.

    generateEnumerals = (data) ->

First, we need to "fork" the main `Enumeral` constructor so that typechecking will work.
We create a new constructor that just passes everything on.

        type = (n) -> Constructors.Enumeral.call(this, n)
        type.prototype = Object.create Constructors.Enumeral.prototype

Next, we define our enumerals.
We also create a hidden object which store the relationship going the other way.
Note that since values are not guaranteed to be unique, this object may not contain every enumeral (some might be overwritten).

        byValue = {}
        for own enumeral, value of data
            type[enumeral] = new type value
            byValue[value] = type[enumeral]

This function allows quick conversion from value to enumeral.

        type.fromValue = (n) -> byValue[Number n]

We can now freeze our enumerals and return them.

        return Object.freeze type
