<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.3.1</i> <br> <code>Constructors/Rolodex.litcoffee</code></p>

#  THE ROLODEX CONSTRUCTOR  #

 - - -

##  Description  ##

The `Rolodex()` constructor creates a unique, read-only object which represents a list of [`Profile`](Profile.litcoffee)s.
Its properties are summarized below, alongside their Mastodon API equivalents:

>   __[Issue #15](https://github.com/marrus-sh/laboratory/issues/15) :__
>   The object returned by this constructor might be radically different in future versions of Laboratory.

|  Property  |  API Response  | Description |
| :--------: | :------------: | :---------- |
| `profiles` | [The response] | An ordered array of profiles, in reverse-chronological order |
|   `type`   | *Not provided* | A `Rolodex.Type` |
|  `query`   | *Not provided* | The query associated with the `Rolodex` |
|  `before`  | *Not provided* | The upper limit of the `Rolodex` |
|  `after`   | *Not provided* | The lower limit of the `Rolodex` |

Note that `before` and `after` are special identifiers which may depend on the `Rolodex.Type`.

###  Rolodex types:

The possible `Rolodex.Type`s are as follows:

>   __[Issue #18](https://github.com/marrus-sh/laboratory/issues/18) :__
>   There should also be a follow-request rolodex.

| Enumeral | Hex Value | Description |
| :------: | :----------: | :---------- |
| `Rolodex.Type.UNDEFINED` | `0x00` | No type is defined |
| `Rolodex.Type.SEARCH` | `0x10` | A search of profiles |
| `Rolodex.Type.FOLLOWERS` | `0x21` | The followers of an account |
| `Rolodex.Type.FOLLOWING` | `0x22` | Those following an account |
| `Rolodex.Type.FAVOURITED_BY` | `0x41` | Those who favourited a given status |
| `Rolodex.Type.REBLOGGED_BY` | `0x45` | Those who reblogged a given status |
| `Rolodex.Type.BLOCKS` | `0x83` | Those who have been blocked |
| `Rolodex.Type.MUTES` | `0x84` | Those who have been muted |

The `Rolodex()` constructor does not use or remember its `Rolodex.Type`, but these values are used when requesting new `Rolodex`es using `LaboratoryRolodexRequested`.

###  Prototype methods:

####  `join()`.

>   ```javascript
>       Laboratory.Rolodex.prototype.join(data);
>   ```
>
>   - __`data` :__ A `Profile`, array of `Profile`s, or a `Rolodex`

The `join()` prototype method joins the `Profile`s of a `Rolodex` with that of the provided `data`, and returns a new `Rolodex` of the results.
When merging two `Rolodex`es, the `type` and `query` parameters will only be preserved if they match across both; in this case, `before` and `after` will be adjusted such that both `Rolodex`es are contained in the range.
Otherwise, the `type` of the resultant `Rolodex` will be `Rolodex.Type.UNDEFINED` and its `query` will be the empty string.

When joining a `Rolodex` with a different data type, the `type`, `query`, `before`, and `after` parameters remain unchanged.

####  `remove()`.

>   ```javascript
>       Laboratory.Rolodex.prototype.remove(data);
>   ```
>
>   - __`data` :__ A `Profile`, array of `Profile`s, or a `Rolodex`

The `remove()` prototype method collects the `Profile`s of a `Rolodex` except for those of the provided `data`, and returns a new `Rolodex` of the results.
The `type`, `query`, `before`, and `after` parameters are preserved from the original.

 - - -

##  Implementation  ##

###  The constructor:

The `Rolodex()` constructor takes a `data` object and uses it to construct a rolodex.
`data` can be either an API response or an array of `Profile`s.
`params` provides additional information not given in `data`.

    Laboratory.Rolodex = Rolodex = (data, params) ->

        throw new Error "Laboratory Error : `Rolodex()` must be called as a constructor" unless this and this instanceof Rolodex
        throw new Error "Laboratory Error : `Rolodex()` was called without any `data`" unless data?

This loads our `params`.

        @type = if params.type instanceof Rolodex.Type then params.type else Rolodex.Type.UNDEFINED
        @query = String params.query
        @before = Number params.before if isFinite params.before
        @after = Number params.after if isFinite params.after

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
        Object.defineProperty @profiles, index, {get: getProfile.bind(this, value.id), enumerable: true} for value, index in data
        Object.freeze @profiles

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
                return this unless data instanceof Profile or data instanceof Array or data instanceof Rolodex
                combined = profile for profile in switch
                    when data instanceof Profile then [data]
                    when data instanceof Rolodex then data.profiles
                    else data
                combined.push profile for profile in @profiles
                return new Rolodex combined, (
                    if data instanceof Rolodex
                        if data.type is @type and data.query is @query
                            type: @type
                            query: @query
                            before: switch
                                when data.before >= @before then data.before
                                when data.before <= @before then @before
                                else undefined
                            after: switch
                                when data.after <= @after then data.after
                                when data.after >= @after then @after
                                else undefined
                        else
                            type: if data.type is @type then @type else Rolodex.Type.UNDEFINED
                            query: ""
                            before: undefined
                            after: undefined
                    else
                        type: @type
                        query: @query
                        before: @before
                        after: @after
                )

####  `remove()`.

The `remove()` function returns a new `Rolodex` with the provided `Profile`s removed.
Its `data` argument can be either a `Profile`, an array thereof, or a `Rolodex`.

            remove: (data) ->
                return this unless data instanceof Profile or data instanceof Array or data instanceof Rolodex
                redacted = (profile for profile in @profiles)
                redacted.splice index, 1 for profile in (
                    switch
                        when data instanceof Profile then [data]
                        when data instanceof Rolodex then data.profiles
                        else data
                ) when (index = redacted.indexOf profile) isnt -1
                return new Rolodex redacted,
                    type: @type
                    query: @query
                    before: @before
                    after: @after

###  Defining rolodex types:

Here we define our `Rolodex.Type`s, as described above:

>   __[Issue #18](https://github.com/marrus-sh/laboratory/issues/18) :__
>   There should also be a follow-request rolodex.

    Rolodex.Type = Enumeral.generate
        UNDEFINED     : 0x00
        SEARCH        : 0x10
        FOLLOWERS     : 0x21
        FOLLOWING     : 0x22
        FAVOURITED_BY : 0x41
        REBLOGGED_BY  : 0x45
        BLOCKS        : 0x83
        MUTES         : 0x84
