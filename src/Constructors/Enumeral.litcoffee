#  THE ENUMERAL CONSTRUCTOR  #

The `Enumeral()` constructor creates a unique, read-only object which can be used as a unique identifier.
`Enumeral`s evaluate to numbers and can also be used with binary comparisons.

For more information on enumerals and how they work, see the documentation for [Laboratory enumerals](../Enumerals/).

##  Implementation  ##

###  The constructor:

The `Enumeral()` constructor takes a numeric `value`, which the resultant enumeral will compute to.

    Constructors.Enumeral = (value) ->

        return unless this and (this instanceof Constructors.Enumeral)

        @value = 0 unless isFinite @value = Number value

        return Object.freeze this

###  The prototype:

The `Enumeral` prototype overwrites `valueOf()` to allow for easy numeric conversion.
It also adjusts `toString()` and `toSource()` slightly.

    Object.defineProperty Constructors.Enumeral, "prototype",
        value: Object.freeze
            toString: -> "Enumeral(" + @value + ")"
            toSource: ->"Enumeral(" + @value + ")"
            valueOf: -> @value
