<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.4.0</i> <br> <code>Constructors/Rolodex.litcoffee</code></p>

#  THE ROLODEX CONSTRUCTOR  #

 - - -

##  Description  ##

The `Rolodex()` constructor creates a unique, read-only object which represents a list of [`Profile`](Profile.litcoffee)s.
Its properties are summarized below, alongside their Mastodon API equivalents:

|  Property  |  API Response  | Description |
| :--------: | :------------: | :---------- |
| `profiles` | [The response] | An ordered array of profiles, in reverse-chronological order |
|  `length`  | *Not provided* | The length of the `Rolodex` |

###  Rolodex types:

The possible `Rolodex.Type`s are as follows:

>   __[Issue #18](https://github.com/marrus-sh/laboratory/issues/18) :__
>   There should also be a follow-request rolodex.

| Enumeral | Hex Value | Description |
| :------: | :----------: | :---------- |
| `Rolodex.Type.UNDEFINED` | `0x00` | No type is defined |
| `Rolodex.Type.SEARCH` | `0x10` | A search of profiles |
| `Rolodex.Type.FOLLOWERS` | `0x21` | The followers of an account |
| `Rolodex.Type.FOLLOWING` | `0x22` | Those an account is following |
| `Rolodex.Type.FAVOURITED_BY` | `0x41` | Those who favourited a given status |
| `Rolodex.Type.REBLOGGED_BY` | `0x45` | Those who reblogged a given status |
| `Rolodex.Type.BLOCKS` | `0x83` | Those who have been blocked |
| `Rolodex.Type.MUTES` | `0x84` | Those who have been muted |
| `Rolodex.Type.FOLLOW_REQUESTS` | `0x86` | Those who have requested to follow the user |

###  Prototype methods:

####  `join()`.

>   ```javascript
>       Laboratory.Rolodex.prototype.join(data);
>   ```
>
>   - __`data` :__ A `Profile`, array of `Profile`s, or a `Rolodex`

The `join()` prototype method joins the `Profile`s of a `Rolodex` with that of the provided `data`, and returns a new `Rolodex` of the results.

####  `remove()`.

>   ```javascript
>       Laboratory.Rolodex.prototype.remove(data);
>   ```
>
>   - __`data` :__ A `Profile`, array of `Profile`s, or a `Rolodex`

The `remove()` prototype method collects the `Profile`s of a `Rolodex` except for those of the provided `data`, and returns a new `Rolodex` of the results.

 - - -

##  Examples  ##

>   __[Issue #53](https://github.com/marrus-sh/laboratory/issues/53) :__
>   Usage examples for constructors are forthcoming.

 - - -

##  Implementation  ##

###  The constructor:

The `Rolodex()` constructor takes a `data` object and uses it to construct a rolodex.
`data` can be either an API response or an array of `Profile`s.

    Laboratory.Rolodex = Rolodex = (data) ->

        unless this and this instanceof Rolodex
            throw new TypeError "this is not a Rolodex"
        unless data?
            throw new TypeError "Unable to create Rolodex; no data provided"

We'll use the `getProfile()` function in our profile getters.

        getProfile = (id) -> Store.profiles[id]

We sort our data according to their ids.

        data.sort (first, second) -> second.id - first.id

The following loop removes any duplicates from our `data`.

        prev = null
        for index in [data.length - 1 .. 0]
            currentID = (current = data[index]).id
            if prev? and currentID is prev.id
                data.splice index, 1
                continue
            prev = current

Finally, we implement our list of `profiles` as getters such that they always return the most current data.
**Note that this will likely prevent optimization of the `profiles` array, so it is recommended that you make a static copy (using `Array.prototype.slice()` or similar) before doing intensive array operations with it.**

>   __[Issue #28](https://github.com/marrus-sh/laboratory/issues/28) :__
>   At some point in the future, `Rolodex` might instead be implemented using a linked list.

        @profiles = []
        Object.defineProperty @profiles, index, {
            enumerable: yes
            get: getProfile.bind(this, value.id)
        } for value, index in data
        Object.freeze @profiles

        @length = data.length

        return Object.freeze this

###  The prototype:

The `Rolodex` prototype has two functions.

    Object.defineProperty Rolodex, "prototype",
        value: Object.freeze

####  `join()`.

The `join()` function creates a new `Rolodex` which combines the `Profile`s of the original and the provided `data`.
Its `data` argument can be either a `Profile`, an array thereof, or a `Rolodex`.
We don't have to worry about duplicates here because the `Rolodex()` constructor should take care of them for us.

            join: (data) ->
                return this unless data instanceof Profile or data instanceof Array or
                    data instanceof Rolodex
                combined = profile for profile in switch
                    when data instanceof Profile then [data]
                    when data instanceof Rolodex then data.profiles
                    else data
                combined.push profile for profile in @profiles
                return new Rolodex combined

####  `remove()`.

The `remove()` function returns a new `Rolodex` with the provided `Profile`s removed.
Its `data` argument can be either a `Profile`, an array thereof, or a `Rolodex`.

            remove: (data) ->
                return this unless data instanceof Profile or data instanceof Array or
                    data instanceof Rolodex
                redacted = (profile for profile in @profiles)
                redacted.splice index, 1 for profile in (
                    switch
                        when data instanceof Profile then [data]
                        when data instanceof Rolodex then data.profiles
                        else data
                ) when (index = redacted.indexOf profile) isnt -1
                return new Rolodex redacted

###  Defining rolodex types:

Here we define our `Rolodex.Type`s, as described above:

>   __[Issue #18](https://github.com/marrus-sh/laboratory/issues/18) :__
>   There should also be a follow-request rolodex.

    Rolodex.Type = Enumeral.generate
        UNDEFINED       : 0x00
        SEARCH          : 0x10
        FOLLOWERS       : 0x21
        FOLLOWING       : 0x22
        FAVOURITED_BY   : 0x41
        REBLOGGED_BY    : 0x45
        BLOCKS          : 0x83
        MUTES           : 0x84
        FOLLOW_REQUESTS : 0x86
