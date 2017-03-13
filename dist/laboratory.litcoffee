#  README  #

Welcome to the Laboratory source code!
Laboratory is an open-source, client-side engine for Mastodon written in Literate CoffeeScript.
Its source files are parseable as regular Markdown documents, and this file is in fact part of the Laboratory source!

##  How to Read Laboratory Source Code  ##

With the exception of the [Events](Events/) and [Handlers](Handlers/) of the __Laboratory Event API,__ each Laboratory source code file is broadly split up into two parts: the *description*, which describes what the file does and how to use it, and the *implementation*, which actually implements the described algorithms and processes.
The implementation will always be the last section in the document, and it is the one that it is safest to ignore—any important information should have already been covered in the description of what goes on in the file.
However, you can turn to the implementation if you are curious on how specific Laboratory features are actually coded.
(And, of course, if you are a computer, the compiled implementation is the only part of this file you will ever see!)

###  What to read:

If you're looking to use Laboratory in your project, then you should definitely familiarize yourself with the [Events API](Events/), as this is the primary means of interfacing with the Laboratory engine.
You might also be interested in the Laboratory [Constructors](Constructors/) and [Enumerals](Enumerals/), as these describe the data types which you are likely to encounter in your adventures.

The [Handlers](Handlers/) folder contains details on the specific details of the Laboratory Event Handlers.
Generally you can get along fine without knowing all of these specifics, but if you want to know exactly what Laboratory does when you issue an event, this is the place to go.

##  Contributing  ##

Want to contribute to Laboratory?
That's great!
Feel free to submit a Pull Request through Github.
However, here are some guidelines to help your work be successful:

###  Document your code:

Laboratory is written in Literate CoffeeScript, so be literate about it!
Code should be written in a manner that flows well narratively, and written documentation explaining what it does in plain English should accompany any code.
It should be possible to understand *what* a file does by only reading the Markdown; the code exists to describe to a computer *how*.

###  Be mindful of data mutability:

If a property shouldn't be overwritten, you should define it with `Object.definePropery()`.
If an object should be considered immutable, use `Object.freeze()`.
You will find that most of the time when defining objects in our code one or both of these functions will come into play.

###  Be concise and elegant:

CoffeeScript is a very powerful language for writing code that is elegant and easy-to-read.
Take advantage of this!
Having text explanations above and below doesn't excuse messy code.

##  Style Guide  ##

This section describes the style conventions you are likely to encounter when reading Laboratory source.

###  Markdown:

Except where otherwise noted, prose should attempt to follow the Chicago Manual of Style.
Em dashes with no surrounding spaces are used for parantheticals.
Abbreviations are written either all-lowercase or all-uppercase, with the former preferred except at the beginning of sentences, and no trailing period (eg: url, id, html).
The following sections provide more information on Markdown-specific conventions.

####  Headings.

Headings should always be indicated using hash marks, as shown in the code below.
Place two spaces between the hash marks and the heading text.

```markdown
    #  THIS IS A TITLE  #
    ##  This Is A H2 Heading  ##
    ###  This is a H3 heading:
    ####  This is a H4 heading.
    #####  THIS IS A H5 HEADING
    ######  this is a h6 heading
```

####  Paragraphs.

Markdown paragraphs are written with one sentence per line.
This helps document which sentences have changed when looking at git diffs.
Don't break a sentence across multiple lines; similarly, don't put more than one sentence on the same line.

####  Lists.

Markdown lists come in two forms: expanded and condensed.
Condensed lists look like this:

- This is an unnumbered list item.
    - This is a sub-item.
- Note that there is a space before and after the list, but not in-between items.
- Never use a condensed list for something more than one sentence long.

Expanded lists look like this:

 -  This is an expanded list.
    Use this for lists that contain multiple sentences.

 -  You'll notice that there is a blank line between each list item.
    This renders each list as a paragraph.

1.  Numbered lists should always be rendered in an expanded form.

2.  Even though Markdown doesn't require it, try to keep numbering accurate for numbered lists.

####  Code blocks.

Code blocks in source code files should always be placed inside blockquotes using GFM fenced code syntax, like this:

>   ```coffeescript
>       -> "Here is some CoffeeScript code."
>   ```

Literate CoffeeScript will interpret any indented lines as source code, so encapsulating documentation code in blockquotes helps keep everything nicely separated.

#####  LANGUAGES

Laboratory is written in CoffeeScript, but documentation code should be written instead using plain JavaScript.
Knowledge of CoffeeScript should not be a prerequisite for interfacing with the Laboratory engine.

####  Issues and notes.

If you want to reference an open issue, or make a note, the syntax for this is as follows:

>   __Note :__
>   This is a note.

Note the space between the colon and the word "Note".
Again, each sentence should be on its own line.
If the issue has a GitHub link, you might include that:

>   __[Issue #XX](https://github.com/marrus-sh/laboratory/issues/XX) :__
>   Here is a comment regarding that issue

Following this syhtax will make finding references to notes and issues easy when searching through pages of source.

####  Other considerations.

If you need to make a line-break, **always** use a `<br>` element.
**Never** use blank spaces at the end of a line to indicate a manual break.

Two asterisks are used for **important content**, while one asterisk is used for *emphasis*.
Use underscores if you need __boldfaced__ or _italicized_ text without these semantics.

References to code should use `backticks`.
HTML elements should be lowercase and surrounded by angle brackets, like `<this>`.
You may optionally specify attributes as well; `<div class="so">` refers to `<div>` elements with the class `so`.
Functions and constructors should be followed by parentheses, like `this()`.
However, when referring to instances and prototypes, no parentheses are used; for example, one might say `something` is an instance of `ThisOne` even though it was created using the constructor `ThisOne()`.

###  CoffeeScript:

####  Variable naming.

Variables and functions are named using `camelCase`, with the first letter lowercase.
Functions which are meant to serve as constructors, objects which act as modules, and event builders are named using `CamelCase`, with the first letter capitalized.
Enumerals and other constants are named using `UPPERCASE_LETTERS_WITH_UNDERSCORES`.

The Mastodon API frequently makes use of `lowercase_letters_with_underscores` for its parameter names, although we rarely have to deal with this directly.
Event types should follow the syntax `LaboratoryModuleEventName`, where this is a reference to an event dispatched by `Laboratory.Module.EventName`.

####  Spacing.

Lines should be indented using 4 spaces.
This is very important as it keeps code readable even when it is broken up by long paragraphs of text documentation.

####  Strings.

Strings are double-quoted where possible.
Generally speaking, try to avoid performing substitutions in stings using the `"#{}"` syntax; instead concatenate multiple strings with your code using `+`.

####  Functions.

Generally speaking, if you can avoid using parentheses when calling a function, do.
Include parentheses only if the code becomes very ambiguous to readers otherwise.

####  Objects.

Only wrap an object in `{}` if you are declaring it all on one line; using the multi-line YAML-like syntax is greatly preffered.
This includes in function calls—you don't need parentheses around the object either in this case.

####  Constructors.

Constructors should be written as functions with separate prototypes.
**Do not use CoffeeScript's `class` syntax to write constructors.**
Constructors and their prototypes should always be frozen using `Object.freeze` to prevent them from being modified after creation.

####  Local variables and closure.

Because our CoffeeScript files are concatenated into a single file before compilation, local variables from one file are also available in another.
In general, **you should not use local variables**, and whenever you need to declare a variable outside of the scope of a function you should encapsulate it in a `do ->` statement.

####  Postfix forms.

Generally speaking, you should use the postfix forms of `if`, `unless`, `for`, `while`, etc. where possible.

##  Implementation  ##

This file doesn't actually do much, but it's the first thing that our Laboratory script runs.
In case this is a popup generated by an OAuth request, we handle the information quickly now so that the user can proceed uninterrupted.

###  Introduction:

This is the first file in our compiled source, so let's identify ourselves real fast.

    ###

        ............. LABORATORY ..............

        A client-side API for Mastodon, a free,
           open-source social network server
                  - - by Kibigo! - -

            Licensed under the MIT License.
               Source code available at:
        https://github.com/marrus-sh/laboratory

                    Version 0.2.0

    ###

Laboratory uses an [MIT License](../LICENSE.md) because it's designed to be included in other works.
Feel free to make it your own!

###  Popup handling:

If this is a popup (`window.opener.Laboratory` exists) and an API redirect (a `code` parameter exists in our query), then we hand our opener our code.

    do ->
        codesearch = location.search.match /code=([^&]*)/
        code = codesearch[1] if codesearch?
        window.opener.Laboratory.Authorization.Granted.dispatch {window: window, code: code} if code? and window.opener.Laboratory

When the `LaboratoryAuthorizationGranted` event gets processed, this window will be closed.

###  Exposed properties:

Although Laboratory does not expose its store to outsiders, it does carefully reveal a few key properties.
These are:

- `ready`, which indicates whether `LaboratoryInitializationReady` has fired yet
- `user`, which gives the id of the currently-logged-in user, or `null` if no user is logged in

For now, we'll keep these properties in the `Exposed` object.

    Exposed =
        ready: no
        user: null


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


#  THE APPLICATION CONSTRUCTOR  #

The `Application()` constructor creates a unique, read-only object which represents an application used to interface with the Mastodon API.
Its properties are summarized below, alongside their Mastodon API equivalents:

| Property | API Response | Description |
| :------: | :----------: | :---------- |
|  `name`  |    `name`    | The name of the application |
|  `href`  |  `website`   | The url of the application's homepage or website |

##  Implementation  ##

###  The constructor:

The `Application()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.

    Constructors.Application = (data) ->

        return unless this and (this instanceof Constructors.Application) and data?

        @name = data.name
        @href = data.website

        return Object.freeze this

###  The prototype:

The `Application` prototype just inherits from `Object`.

    Object.defineProperty Constructors.Application, "prototype",
        value: Object.freeze {}


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


#  THE FOLLOW CONSTRUCTOR  #

The `Follow()` constructor creates a unique, read-only object which represents a follow by another user.
Its properties are summarized below, alongside their Mastodon API equivalents:

|  Property  | API Response | Description |
| :--------: | :----------: | :---------- |
|    `id`    |     `id`     | The id of follow notification |
| `follower` |  `account`   | The account who issued the follow |

##  Implementation  ##

###  The constructor:

The `Follow()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.
In order to ensure that `Follow`s always have the most recent account data, they will calculate their `account` parameter on-demand by looking up the account's id from a list of `accounts`.
(This should be a list of `Profile`s, although this is not enforced.)

    Constructors.Follow = (data, accounts) ->

        return unless this and (this instanceof Constructors.Follow) and data?

        @follower = data.account.id

        @id = data.id
        Object.defineProperty this, "follower",
            get: -> accounts[author]
            enumerable: yes

        return Object.freeze this

###  The prototype:

The `Follow` prototype just inherits from `Object`.

    Object.defineProperty Constructors.Follow, "prototype",
        value: Object.freeze {}


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


#  THE MEDIA ATTACHMENT CONSTRUCTOR  #

The `MediaAttachment()` constructor creates a unique, read-only object which represents an attached piece of media sent through the Mastodon API.
Its properties are summarized below, alongside their Mastodon API equivalents:

| Property  | API Response  | Description |
| :-------: | :-----------: | :---------- |
|   `id`    |     `id`      | The id of the media attachment |
|  `href`   |     `url`     | The url of the media attachment |
| `preview` | `preview_url` | The url of a preview for the media attachment |
|  `type`   |    `type`     | A [`Laboratory.MediaType`](../Enumerals/MediaType.litcoffee) |

##  Implementation  ##

###  The constructor:

The `MediaAttachment()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.

    Constructors.MediaAttachment = (data) ->

        return unless this and (this instanceof Constructors.MediaAttachment) and data?

        @id = data.id
        @href = data.url
        @preview = data.preview_url
        @type = if data.type is "image" then Enumerals.MediaType.IMAGE else if data.type is "video" then Enumerals.MediaType.VIDEO else Enumerals.MediaType.UNKNOWN

        return Object.freeze this

###  The prototype:

The `MediaAttachment` prototype just inherits from `Object`.

    Object.defineProperty Constructors.MediaAttachment, "prototype",
        value: Object.freeze {}


#  THE MENTION CONSTRUCTOR  #

The `Mention()` constructor creates a unique, read-only object which represents a user mention.
Its properties are summarized below, alongside their Mastodon API equivalents:

|    Property    | API Response  | Description |
| :------------: | :-----------: | :---------- |
|      `id`      |     `id`      | The id of the mentioned account |
|     `href`     |     `url`     | The url of the mentioned account's profile |
|   `username`   |  `username`   | The mentioned account's username |
|   `account`    | Not provided  | The mentioned account's username, followed by their domain |
| `localAccount` |    `acct`     | The mentioned account's username, followed by their domain for remote users only |

##  Implementation  ##

###  The constructor:

The `Mention()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.
It uses the `origin` argument to help fill out account handles.

    Constructors.Mention = (data, origin) ->

        return unless this and (this instanceof Constructors.Mention) and data?

        @id = data.id
        @href = data.url
        @username = data.username
        @account = data.acct + (if origin? and data.acct.indexOf("@") is -1 then origin else "")
        @localAccount = data.acct

        return Object.freeze this

###  The prototype:

The `Mention` prototype just inherits from `Object`.

    Object.defineProperty Constructors.Mention, "prototype",
        value: Object.freeze {}


#  THE POST CONSTRUCTOR  #

The `Post()` constructor creates a unique, read-only object which represents an account's profile information.
Its properties are summarized below, alongside their Mastodon API equivalents:

|      Property      |    API Response     | Description |
| :----------------: | :-----------------: | :---------- |
|       `type`       |    Not provided     | A [`Laboratory.PostType`](../Enumerals/PostType.litcoffee) |
|       `id`         |        `id`         | The id of the post |
|       `uri`        |        `uri`        | A fediverse-unique identifier for the post |
|      `href`        |        `url`        | The url of the post's page |
|     `author`      |       `account`      | The account who made the post |
|    `inReplyTo`     |  `in_reply_to_id`   | The id of the account who made the post |
|     `content`      |      `content`      | The content of the status |
|     `datetime`     |    `created_at`     | The time when the post was created |
|   `reblogCount`    |   `reblogs_count`   | The number of reblogs the post has |
|  `favouriteCount`  | `favourites_count`  | The number of favourites the post has |
|   `isReblogged`    |     `reblogged`     | Whether or not the user has reblogged the post |
|   `isFavourited`   |    `favourited`     | Whether or not the user has favourited the post |
|      `isNSFW`      |     `sensitive`     | Whether or not the post's media contains sensitive content |
|     `message`      |   `spoiler_text`    | The message to hide the post behind, if any |
|    `visibility`    |    `visibility`     | A [`Laboratory.Visibility`](../Enumerals/Visibility.litcoffee) |
| `mediaAttachments` | `media_attachments` | An array of [`Laboratory.MediaAttachment`](MediaAttachment.litcoffee)s |
|     `mentions`     |     `mentions`      | An array of [`Laboratory.Mention`](Mention.litcoffee)s |
|   `application`    |   `application`     | A [`Laboratory.Application`](Application.litcoffee) identifying the application which created the post |
|   `rebloggedBy`    |    Not provided     | The id of the account who reblogged the post; only set for reblog notifications |
|   `favouritedBy`   |    Not provided     | The id of the account who favourited the post; only set for favourite notifications |

##  Implementation  ##

###  The constructor:

The `Post()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.
In order to ensure that `Post`s always have the most recent account data, they will calculate their `account` parameter on-demand by looking up the account's id from a list of `accounts`.
(This should be a list of `Profile`s, although this is not enforced.)

    Constructors.Post = (data, accounts) ->

        return unless this and (this instanceof Constructors.Post) and data?

The `Post()` constructor can be called with either a status response or a notification one.
We can check this fairly readily by checking for the presence of the `status` attibute.
If `data` has an associated `status`, then it must be a notification.
We pull the notification data and then overwrite `data` to just show the post.

        if data.status
            @type = Enumerals.PostType.NOTIFICATION
            @id = data.id
            switch data.type
                when "reblog"
                    Object.defineProperty this, "rebloggedBy",
                        get: -> accounts[data.account.id]
                        enumerable: yes
                when "favourite"
                    Object.defineProperty this, "favouritedBy",
                        get: -> accounts[data.account.id]
                        enumerable: yes
                # when "mention" then the mentioner is just the author of the post :P
            data = data.status

If our `data` isn't a notification then we can use its `id` like normal.

        else
            @type = Enumerals.PostType.STATUS
            @id = data.id

That said, it is possible our `data` is a normal (non-notification) reblog.
In which case, we want to use the original post for extracting our data.

            if data.reblog
                Object.defineProperty this, "rebloggedBy",
                    get: -> accounts[data.account.id]
                    enumerable: yes
                data = data.reblog

Now we can set the rest of our properties.

        @uri = data.uri
        @href = data.url
        Object.defineProperty this, "author",
            get: -> accounts[data.account.id]
            enumerable: yes
        @inReplyTo = data.in_reply_to_id
        @content = data.content
        @datetime = data.created_at
        @reblogCount = data.reblogs_count
        @favouriteCount = data.favourites_count
        @isReblogged = data.reblogged
        @isFavourited = data.favourited
        @isNSFW = data.sensitive
        @message = data.spoiler_text
        @visibility = {
            private: Enumerals.Visibility.PRIVATE
            unlisted: Enumerals.Visibility.UNLISTED
            public: Enumerals.Visibility.PUBLIC
        }[data.visibility] || Enumerals.Visibility.UNLISTED
        @mediaAttachments = (new Constructors.MediaAttachment item for item in data.media_attachments)
        @mentions = (new Constructors.Mention item for item in data.mentions)
        @application = new Constructors.Application data.application

        return Object.freeze this

###  The prototype:


The `Post` prototype has one function.

    Object.defineProperty Constructors.Post, "prototype",
        value: Object.freeze

`compare` does a quick comparison between two `Post`s, and tells whether or not they are equivalent.
For efficiency's sake, if the ids of the two posts are the same, it only compares those values which should be considered mutable.

            compare: (other) ->

                return false unless other instanceof Constructors.Post

                return (
                    @type is other.type and
                    @id is other.id and
                    @reblogCount is other.reblogCount and
                    @favouriteCount is other.favouriteCount and
                    @isReblogged is other.isReblogged and
                    @isFavourited is other.isFavourited
                )


#  THE PROFILE CONSTRUCTOR  #

The `Profile()` constructor creates a unique, read-only object which represents an account's profile information.
Its properties are summarized below, alongside their Mastodon API equivalents:

|     Property     |    API Response   | Description |
| :--------------: | :---------------: | :---------- |
|       `id`       |       `id`        | The id of the account |
|    `username`    |    `username`     | The account's username |
|     `account`    |   Not provided    | The account's username, followed by their domain |
|  `localAccount`  |      `acct`       | The account's username, followed by their domain for remote users only |
|  `displayName`   |  `display_name`   | The account's display name |
|      `bio`       |      `note`       | The account's profile bio |
|      `href`      |      `url`        | The URL for the account's profile page |
|     `avatar`     |     `avatar`      | The URL for the account's avatar |
|     `header`     |     `header`      | The URL for the account's header |
|    `isLocked`    |     `locked`      | `true` if the account is locked; `false` otherwise |
| `followerCount`  | `followers_count` | The number of accounts following the given one |
| `followingCount` | `following_count` | The number of accounts that the given one is following |
|  `statusCount`   | `statuses_count`  | The number of statuses that the given account has posted |
|  `relationship`  |   Not provided    | A [`Laboratory.Relationship`](../Enumerals/Laboratory.Relationship) providing the relationship between the given account and the current user. |

##  Implementation  ##

###  The constructor:

The `Profile()` constructor takes a `data` object from an API response (or another `Profile` object) and reads its attributes into an instance's properties.
It uses the `origin` argument to help fill out account handles.
The `relationship` argument can be used to set the Profile relationship.

    Constructors.Profile = (data, origin, relationship) ->

        return unless this and (this instanceof Constructors.Profile) and data?

If our `data` is already a `Profile`, we can just copy its info over.

        if (data instanceof Constructors.Profile) then {@id, @username, @account, @localAccount, @displayName, @bio, @href, @avatar, @header, @isLocked, @followerCount, @followingCount, @statusCount, @relationship} = data

Otherwise, we have to change some variable names around.

        else
            @id = data.id
            @username = data.username
            @account = data.acct + (if origin? and data.acct.indexOf("@") is -1 then origin else "")
            @localAccount = data.acct
            @displayName = data.display_name
            @bio = data.note
            @href = data.url
            @avatar = data.avatar
            @header = data.header
            @isLocked = data.locked
            @followerCount = data.followers_count
            @followingCount = data.following_count
            @statusCount = data.statuses_count
            @relationship = Enumerals.Relationship.UNKNOWN

We set the relationship last, overwriting any previous relationship if one is provided.
This code will coerce the provided relationship into an Number and then back to an enumeral if possible.
Note that because enumerals are objects, they will always evaluate to `true` even if their value is `0x00`.

        @relationship = Enumerals.Relationship.fromValue(relationship) || @relationship if relationship?

        return Object.freeze this

###  The prototype:

The `Profile` prototype has one function.

    Object.defineProperty Constructors.Profile, "prototype",
        value: Object.freeze

`compare` does a quick comparison between two `Profile`s, and tells whether or not they are equivalent.
For efficiency's sake, it compares attributes with the most-likely-to-be-different ones first.

            compare: (other) ->

                return false unless other instanceof Constructors.Profile

                return (
                    @id is other.id and
                    @relationship is other.relationship and
                    @followerCount is other.followerCount and
                    @followingCount is other.followingCount and
                    @statusCount is other.statusCount and
                    @bio is other.bio and
                    @displayName is other.displayName and
                    @avatar is other.avatar and
                    @header is other.header and
                    @isLocked is other.isLocked and
                    @username is other.username and
                    @localAccount is other.localAccount and
                    @account is other.account and
                    @href is other.href
                )


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


#  MEDIA TYPE ENUMERALS  #

This file provides enumerals for various media types.
The options are as follows:

| Enumeral | Numeric Value | Description |
| :------: | :-----------: | :---------- |
| `Laboratory.MediaType.UNKNOWN` | `0x00` | The media type cannot be determined |
| `Laboratory.MediaType.PHOTO` | `0x01` | The media is a photo |
| `Laboratory.MediaType.VIDEO` | `0x02` | The media is a video |

##  Implementation  ##

    Enumerals.MediaType = generateEnumerals
        UNKNOWN: 0x00
        PHOTO: 0x01
        VIDEO: 0x02


#  POST TYPE ENUMERALS  #

This file provides enumerals for various post types.
The options are as follows:

| Enumeral | Numeric Value | Description |
| :------: | :-----------: | :---------- |
| `Laboratory.PostType.UNKNOWN` | `0x00` | The post type cannot be determined |
| `Laboratory.PostType.STATUS` | `0x01` | The post is an status |
| `Laboratory.PostType.NOTIFICATION` | `0x02` | The post is a notification |

##  Implementation  ##

    Enumerals.PostType = generateEnumerals
        UNKNOWN: 0x00
        STATUS: 0x01
        NOTIFICATION: 0x02


#  RELATIONSHIP ENUMERALS  #

| Enumeral | Numeric Value | Description |
| :------: | :-----------: | :---------- |
| `Laboratory.Relationship.SELF` | `0x10` | The account is the user |
| `Laboratory.Relationship.FOLLOWING` | `0x02` | The account is being followed by the user |
| `Laboratory.Relationship.FOLLOWED_BY` | `0x01` | The user is being followed by the account |
| `Laboratory.Relationship.MUTUALS` | `0x03` | The user and the account are following each other |
| `Laboratory.Relationship.REQUESTED` | `0x04` | The user has requested to follow the account |
| `Laboratory.Relationship.REQUESTED_MUTUALS` | `0x05` | The account follows the user, and the user has requested to follow the account |
| `Laboratory.Relationship.NOT_FOLLOWING` | `0x00` | Neither the account nor the user are following each other |
| `Laboratory.Relationship.BLOCKING` | `0x08` | The user is blocking the account |
| `Laboratory.Relationship.UNKNOWN` | `0x20` | The relationship between the user and the account is unknown |

You can use bitwise comparisons on these enumerals to test for a specific relationship status.
Of course, many combinations are not possible.

|  Flag  | Meaning |
| :----: | ------- |
| `0x01` | The user is followed by the account |
| `0x02` | The account is followed by the user |
| `0x04` | The user has sent a follow request to the account |
| `0x08` | The user is blocking the account |
| `0x10` | The user is the same as the account |
| `0x20` | The relationship status between the user and the account is unknown |

##  Implementation  ##

    Enumerals.Relationship = generateEnumerals
        NOT_FOLLOWING: 0x00
        FOLLOWED_BY: 0x01
        FOLLOWING: 0x02
        MUTUALS: 0x03
        REQUESTED: 0x04
        REQUESTED_MUTUALS: 0x05
        BLOCKING: 0x08
        SELF: 0x10
        UNKNOWN: 0x20


#  VISIBILITY ENUMERALS  #

This file provides enumerals for post visibility.
The options are as follows:

| Enumeral | Numeric Value | Description |
| :------: | :-----------: | :---------- |
| `Laboratory.Visibility.PRIVATE` | `0x00` | The post cannot be reblogged and appears as unlisted |
| `Laboratory.Visibility.UNLISTED` | `0x01` | The post is unlisted but can be reblogged |
| `Laboratory.Visibility.UNREBLOGGABLE` | `0x02` | The post can be reblogged but is unlisted |
| `Laboratory.Visibility.PUBLIC` | `0x03` | The post is listed and can be reblogged |

However, `Laboratory.Visibility.UNREBLOGGABLE` (`0x02`) is not a valid visibility for a Mastodon post.
(The valid visibilities evaluate to `0x00`, `0x01`, and `0x03`, repsectively.)

Note that the visibility of the post can be evaluating using bitwise comparisons:

|  Flag  |          Meaning          |
| :----: | ------------------------- |
| `0x01` | The post can be reblogged |
| `0x02` | The post is listed        |

##  Implementation  ##

    Enumerals.Visibility = generateEnumerals
        PRIVATE: 0x00
        UNLISTED: 0x01
        UNREBLOGGABLE: 0x02
        PUBLIC: 0x03
        REQUESTED: 0x04
        REQUESTED_MUTUALS: 0x05
        BLOCKING: 0x08
        SELF: 0x10
        UNKNOWN: 0x20


#  LABORATORY EVENT API  #

Laboratory does not give you direct access to the information it receives from a Mastodon server.
Instead, it makes this information available using a special __Event API,__ which is documented here.
This page will provide the basics on the API and how it works, and then direct you to further resources for specific components.

##  Understanding the Event API  ##

In order to understand Laboratory's Event API, you first need to understand how Laboratory stores its data.
All of the information that Laboratory receives and keeps track of from a Mastodon server is kept within a single central __store,__ which is a large JavaScript object with numerous different parts.
The idea of a central store might be familiar to you if you've used systems like __Redux__ before.

However, unlike with Redux, many areas of Laboratory's store are left fully mutable.
This means that the store can be quickly modified in-place to add and remove data.
However, it also means that, in order to maintain the sanctity of its data, the Laboratory store can't be exposed to the public view.
**Laboratory's store is declared inside of a closure for which there is no external access.**
The only functions which are allowed to act on the Laboratory store are a collection of __Laboratory Event Handlers__ (colloquially, just "handlers"), which have been bound to the store and listen for Laboratory-specific events dispatched to the `document`.

Consequently, the only means outside programs have to interact with the Laboratory store is through a series of pre-defined __Laboratory Events__, which can be issued, listened for, and logged by external parties.
The Laboratory Event API describes these events and their function.

##  Creating and Issuing Laboratory Events ##

Laboratory Events are implemented as `CustomEvents`.
Consequently, each event has just two pieces of information that you need to account for: its `type`, which identifies the event, and its `detail`, which is an object holding the event's data.
Every Laboratory Event will have a `detail` which is an immutable object.

There is no restriction on creating Laboratory Events from scratch; however, this is **not recommended.**
Instead, a number of __event builders__ have been provided, which can be used to create and dispatch Laboratory Events.
Each of these is an instance of `Laboratory.LaboratoryEvent`, and can be used in the following manner:

###  Creating a Laboratory Event:

The `Laboratory.LaboratoryEvent.prototype.new()` function is used to create a new `CustomEvent` with the appropriate `type` and `detail`.

```javascript
    //  Suppose SomeEventBuilder is an instance of Laboratory.LaboratoryEvent:
    var event = SomeEventBuilder.new(props);
```

You can pass this function an object containing properties and values which should be included in the event; however, only those properties defined by the API will be included.

###  Dispatching a Laboratory Event:

You can dispatch a Laboratory Event created with `Laboratory.LaboratoryEvent.prototype.new()` in the usual manner—by calling `document.dispatchEvent()` with the Laboratory Event as its argument.
Laboratory Events should always be dispatched on the `document`.

Usually, you want to create and dispatch an event at the same time.
The `Laboratory.LaboratoryEvent.prototype.dispatch()` function does this for you.
It has the same syntax as `Laboratory.LaboratoryEvent.prototype.new()`:

```javascript
    //  Suppose SomeEventBuilder is an instance of Laboratory.LaboratoryEvent:
    SomeEventBuilder.dispatch(props);
    SomeEventBuilder.dispatch(props, location);
```

You will note that there is an optional `location` argument on the `Laboratory.LaboratoryEvent.prototype.dispatch()` function.
You can use this argument to dispatch the event to a location other than `document`.
However, this is **not recommended,** as Laboratory handlers all listen for events on the `document` and nowhere else.

##  Listening for Laboratory Events  ##

You may find yourself not wanting to create Laboratory Events, but to listen for them.
Unlike the Laboratory handlers, you do not have access to Laboratory's store, but listening for events can still be useful when it comes to interacting with the Laboratory framework.

All Laboratory Events have a type that resembles `LaboratoryModuleEventName`, where the appropriate event builder for this event would be located at `Laboratory.Module.EventName`.
Just add an event listener to `document` with your callback to listen for these events:

```javascript
    //  Suppose LaboratorySomeEvent is a Laboratory Event:
    document.addEventListener("LaboratorySomeEvent", callback);
```

The most important event to listen for is the `LaboratoryInitializationReady` event, which tells you when Laboratory handlers have been assigned and are now listening.
This event should be used as a trigger for starting any of your Laboratory-related code.

##  How to Read This Source  ##

Unlike with most other Laboratory source files, Laboratory events interweave their source code with their documentation.
Generally speaking, you can completely ignore the source code, as the surrounding text is much more useful and informative.
However, the source code does provide one useful bit of information not disclosed anywhere else: the default values for event properties.
Supposing you see the following source code…

>   ```coffeescript
>       Event: new Constructors.LaboratoryEvent "LaboratorySomeEvent",
>           key1: null
>           key2: ""
>   ```

…you can see that the default value for `key1` of `LaboratorySomeEvent` is `null` and the default value for `key2` is the empty string.

##  Laboratory Event Reference  ##

Laboratory Events are broken up into several __modules__, each of which is documented within its source.
These are as follows:

- [__Initialization__](Initialization.litcoffee)
- [__Authorization__](Authorization.litcoffee)
- [__Account__](Account.litcoffee)
- [__Timeline__](Timeline.litcoffee)
- [__Status__](Status.litcoffee)
- [__Composer__](Composer.litcoffee)

##  Implementation  ##

Here we set up our internal `Events` object.
The own properties of this object will be copied to our global `window.Laboratory` object later.

    Events = {}


#  ACCOUNT EVENTS  #

    Events.Account = Object.freeze

The __Account__ module of Laboratory Events is comprised of those events which are related to Mastodon accounts.

| Event / Builder | Description |
| :-------------- | :---------- |
| `LaboratoryAccountRelationshipsRequested` / `Laboratory.Account.RelationshipsRequested` | Fires when an account's relationship data should be requested |
| `LaboratoryAccountRelationshipsReceived` / `Laboratory.Account.RelationshipsReceived` | Fires when an account's relationship data has been received |
| `LaboratoryAccountRequested` / `Laboratory.Account.Requested` | Fires when an account's data should be requested |
| `LaboratoryAccountReceived` / `Laboratory.Account.Received` | Fires when an account's data has been received |
| `LaboratoryAccountRemoved` / `Laboratory.Account.Removed` | Fires when an account's callback should be removed |
| `LaboratoryAccountFollowers` / `Laboratory.Account.Followers` | Fires when an account's followers should be requested |
| `LaboratoryAccountFollowing` / `Laboratory.Account.Following` | Fires when data on who an account is following should be requested |
| `LaboratoryAccountSearch` / `Laboratory.Account.Search` | Fires when a search for an account should be requested |
| `LaboratoryAccountFollow` / `Laboratory.Account.Follow` | Fires when a request for a follow has been made |
| `LaboratoryAccountBlock` / `Laboratory.Account.Block` | Fires when a request for a block should be requested |

##  `LaboratoryAccountRelationshipsRequested`  ##

>   - __Builder :__ `Laboratory.Account.RelationshipsRequested`
>   - __Properties :__
>       - `id` – The id(s) of the account.

        RelationshipsRequested: new Constructors.LaboratoryEvent "LaboratoryAccountRelationshipsRequested",
            id: null

The `LaboratoryAccountRelationshipsRequested` event requests that the relationship(s) between the provided account `id`(s) and the user be updated.
If multiple `id`s are are provided, they should be given in an `Array`.

When the account relationships are received, they will be passed through the related account callbacks, so `LaboratoryAccountRelationshipsRequested` only works if the requested account(s) is/are already in the Laboratory store and have callbacks associated with them.
Since it's rare that you will want the relationship information without other information about the account, usually it's best if you just call `LaboratoryAccountRequested` instead.

##  `LaboratoryAccountRelationshipsReceived`  ##

>   - __Builder :__ `Laboratory.Account.RelationshipsReceived`
>   - __Properties :__
>       - `data` – The response from the server.

        RelationshipsReceived: new Constructors.LaboratoryEvent "LaboratoryAccountRelationshipsReceived",
            data: null

The `LaboratoryAccountRelationshipsReceived` event provides the server response for a relationship request.
The handler for this event will update the associated accounts' `relationship` property, firing their callbacks if anything changed.

##  `LaboratoryAccountRequested` ##

>   - __Builder :__ `Laboratory.Account.Requested`
>   - __Properties :__
>       - `id` – The id of the account to fetch data for.
>       - `callback` – A callback function which will be passed the information from the account.

        Requested: new Constructors.LaboratoryEvent "LaboratoryAccountRequested",
            id: null,
            callback: null

The `LaboratoryAccountRequested` event requests information about an account, and associates the account with a provided `callback`.
If information about the given account already exists in the Laboratory store the callback will be called immediately; regardless, a request for updated information will be sent.
`LaboratoryAccountRequested` will automatically also dispatch a `LaboratoryAccountRelationshipsRequested` event to inquire about the account's relationship to the current user.

`callback`s remain associated with an account until a `LaboratoryAccountRemoved` event is fired to remove them.
Whenever an account's information is updated, they are called with a new immutable `Laboratory.Profile` object whose own properties contain the new account data.

The `relationship` will initially be given as `Laboratory.Relationship.UNKNOWN`, and this value will be updated (with a new call to the callback function) once the request for the account's relationship data has gone through.

##  `Account.Received`  ##

>   - __Builder :__ `Laboratory.Account.Received`
>   - __Properties :__
>       - `data` – The response from the server.

        Received: new Constructors.LaboratoryEvent "LaboratoryAccountReceived",
            data: null

The `LaboratoryAccountReceived` event provides the server response for a relationship request.
This event is fired by a number of other handlers when they find themselves with account data—for example, the handler for `LaboratoryTimelineReceived` will fire this event for each account on its timeline.

The handler for `LaboratoryAccountReceived` will fire the associated account's callback functions if the account data has changed.
See the description for `LaboratoryAccountRequested` for more information on the type of data these callbacks will receive.

##  `LaboratoryAccountRemoved`  ##

>   - __Builder :__ `Laboratory.Account.Removed`
>   - __Properties :__
>       - `id` – The account to remove the callback for.
>       - `callback` – The callback to remove.

        Removed: new Constructors.LaboratoryEvent "LaboratoryAccountRemoved",
            id: null,
            callback: null

The `LaboratoryAccountRemoved` event requests a callback be removed from an account.
If the given `callback` has not been associated with the account with the given `id`, this event's handler does nothing.

##  `LaboratoryAccountFollowers`  ##

>   - __Builder :__ `Laboratory.Account.Followers`
>   - __Properties :__
>       - `id` – The id of the account.
>       - `callback` – The callback to call when the follower list is received.
>       - `before` – The status id at which to end the timeline request.
>       - `after` – The status id at which to start the timeline request.

        Followers: new Constructors.LaboratoryEvent "LaboratoryAccountFollowers",
            id: null
            callback: null
            before: null
            after: null

The `LaboratoryAccountFollowers` event requests that the list of followers for the provided account `id` be retrieved.
The range of ids covered by this list can be provided through `before` and `after`.
The `callback` provided to this event will not be remembered later—so make sure one is specified each time.

##  `LaboratoryAccountFollowing`  ##

>   - __Builder :__ `Laboratory.Account.Following`
>   - __Properties :__
>       - `id` – The id of the account.
>       - `callback` – The callback to call when the follower list is received.
>       - `before` – The status id at which to end the timeline request.
>       - `after` – The status id at which to start the timeline request.

        Following: new Constructors.LaboratoryEvent "LaboratoryAccountFollowing",
            id: null
            callback: null
            before: null
            after: null

The `LaboratoryAccountFollowing` event requests that the list people following the provided account `id` be retrieved.
The range of ids covered by this list can be provided through `before` and `after`.
The `callback` provided to this event will not be remembered later—so make sure one is specified each time.

##  `LaboratoryAccountSearch`  ##

>   - __Builder :__ `Laboratory.Account.Search`
>   - __Properties :__
>       - `query` – The query to search for.
>       - `callback` – The callback to call when the follower list is received.
>       - `limit` – The maximum number of results to return from the search.

        Search: new Constructors.LaboratoryEvent "LaboratoryAccountSearch",
            query: null
            callback: null
            limit: null

The `LaboratoryAccountSearch` event requests that an account search be performed for the specified query.
You can limit the number of results returned with the `limit` property.
The `callback` provided to this event will not be remembered later—so make sure one is specified each time.

##  `LaboratoryAccountFollow`  ##

>   - __Builder :__ `Laboratory.Account.Follow`
>   - __Properties :__
>       - `id` – The id of the account.
>       - `value` – `true` if the account should be followed; `false` if the account should be unfollowed

        Follow: new Constructors.LaboratoryEvent "LaboratoryAccountFollow",
            id: null
            value: true

The `LaboratoryAccountFollow` event requests a follow for the specified user id.
Once the server processes this request, a `LaboratoryAccountRelationshipsReceived` event will trigger with the updated relationship for the given account.

##  `LaboratoryAccountBlock`  ##

>   - __Builder :__ `Laboratory.Account.Block`
>   - __Properties :__
>       - `id` – The id of the account.
>       - `value` – `true` if the account should be followed; `false` if the account should be unfollowed

        Block: new Constructors.LaboratoryEvent "LaboratoryAccountBlock",
            id: null
            value: true

The `LaboratoryAccountBlock` event requests a block for the specified user id.
Once the server processes this request, a `LaboratoryAccountRelationshipsReceived` event will trigger with the updated relationship for the given account.


#  AUTHORIZATION EVENTS  #

    Events.Authorization = Object.freeze

The __Authorization__ module of Laboratory Events is comprised of those events which are related to OAuth authorization and authentication between the user, Laboratory, and the Mastodon server.
The only Authorization event you should fire yourself is `LaboratoryAuthorizationRequested`; the remainder are used by Laboratory to document various stages in the authentication process.

| Event / Builder | Description |
| :-------------- | :---------- |
| `LaboratoryAuthorizationClientRequested` / `Laboratory.Authorization.ClientRequested` | Fires when a client id and secret should be requested from the OAuth server |
| `LaboratoryAuthorizationClientReceived` / `Laboratory.Authorization.ClientReceived` | Fires when a client id and secret have been received from the OAuth server |
| `LaboratoryAuthorizationRequested` / `Laboratory.Authorization.Requested` | Fires when an access token should be requested from the OAuth server |
| `LaboratoryAuthorizationGranted` / `Laboratory.Authorization.Granted` | Fires when a user has granted authorization for Laboratory to receive an access token from the OAuth server |
| `LaboratoryAuthorizationReceived` / `Laboratory.Authorization.Received` | Fires when an access token has been received from the OAuth server |
| `LaboratoryAuthorizationVerified` / `Laboratory.Authorization.Verified` | Fires when an access token has been verified and the account data for the user has been received |
| `LaboratoryAuthorizationFavourites` / `Laboratory.Authorization.Favourites` | Requests the list of favourited statuses for the currently authenticated user |
| `LaboratoryAuthorizationBlocks` / `Laboratory.Authorization.Blocks` | Requests the list of favourited statuses for the currently authenticated user |

##  `LaboratoryAuthorizationClientRequested`  ##

>   - __Builder :__ `Laboratory.Authorization.ClientRequested`
>   - __Properties :__
>       - `url` – Provides the URL of the Mastodon server (only the origin is used).
>       - `redirect` – Provides the base URL for your application. This URL must be in the same domain as the current page and must have the Laboratory script loaded. Furthermore, if your application has multiple pages, it should be the same for each.
>       - `name` – Provides the name to use when registering the Mastodon client.

        ClientRequested: new Constructors.LaboratoryEvent 'LaboratoryAuthorizationClientRequested',
            url: "/"
            redirect: ""
            name: "Laboratory Web Client"

The `LaboratoryAuthorizationClientRequested` event fires when the Laboratory script is requesting a new client id for use with OAuth.
Laboratory will fire this event automatically if it needs to during the handling of `LaboratoryAuthorizationRequested`, so it isn't usually something you need to worry about.

##  `LaboratoryAuthorizationClientReceived`  ##

>   - __Builder :__ `Laboratory.Authorization.ClientReceived`
>   - __Properties :__
>       - `data` – Provides the response from the server.
>       - `params` – Provides parameters remembered from the initial request.

        ClientReceived: new Constructors.LaboratoryEvent 'LaboratoryAuthorizationClientReceived',
            data: null
            params: null

The `LaboratoryAuthorizationClientReceived` event fires when the Mastodon server has responded to its request for a client id.
Hopefully, the `data` of this request will contain a client id and secret for Laboratory to use.
These aren't anything you should need to use yourself—especially since Laboratory will be acquiring a much-more-useful access token for you here shortly.

##  `LaboratoryAuthorizationRequested`  ##

>   - __Builder :__ `Laboratory.Authorization.Requested`
>   - __Properties :__
>       - `url` – Provides the URL of the Mastodon server (only the origin is used).
>       - `redirect` – Provides the base URL for your application. This URL must be in the same domain as the current page and must load the Laboratory script. Furthermore, if your application has multiple pages, this URL should be the same for each.
>       - `name` – Provides the name to use when registering the Mastodon client.

        Requested: new Constructors.LaboratoryEvent 'LaboratoryAuthorizationRequested',
            url: "/"
            redirect: ""
            name: "Laboratory Web Client"

The `LaboratoryAuthorizationRequested` event asks Laboratory to seek authorization from a Mastodon server, provided with `url`.
If it is fired with a `name`, then that name will be used when registering the Laboratory client.
(If no client registration is needed, the `name` will be discarded.)

The OAuth authorization window opened by `LaboratoryAuthorizationRequested` will be treated as a popup by most browsers unless you've opened it ahead of time as the result of a click or a keypress.
The name of this window should be `LaboratoryOAuth`.
One good workflow is to open this window preemptively when a user clicks to submit the name of their instance.
If you know the name of the instance ahead of time, using a "connect" button might work just as well.

`LaboratoryAuthorizationClientReceived` automatically fires this event during its handler, so you don't need to dispatch it twice if client registration happens to be needed.

##  `LaboratoryAuthorizationGranted`  ##

>   - __Builder :__ `Laboratory.Authorization.Granted`
>   - __Properties :__
>       - `window` – A reference to the `window` popup which authorized the application
>       - `code` – The authorization code which will be used to retreive an access token.

        Granted: new Constructors.LaboratoryEvent 'LaboratoryAuthorizationGranted',
            window: null
            code: null

The `LaboratoryAuthorizationGranted` event is called from a Laboratory popup window once the user has signed in and authorized the application.
The handler for this event closes the popup and requests an access token from the Mastodon API.

##  `LaboratoryAuthorizationReceived`  ##

>   - __Builder :__ `Laboratory.Authorization.Received`
>   - __Properties :__
>       - `data` – The response from the server.

        Received: new Constructors.LaboratoryEvent 'LaboratoryAuthorizationReceived',
            data: null

The `LaboratoryAuthorizationReceived` event fires once the server has responded to a request for an access token.
The token is—hopefully—contained inside `data`; otherwise Laboratory will start the whole process over again from the beginning.
It is unlikely that you would ever need access to Laboratory's access token, since the whole point of Laboratory is to make it handle the API stuff for you.
However, if you do, **now is the time to secure it**, since after this event is fired it will disappear into the unknowable depths of the Laboratory store.
You can access it at `event.detail.data.access_token`—note the underscore, because this is an API response.

##  `LaboratoryAuthorizationVerified`  ##

>   - __Builder :__ `Laboratory.Authorization.Verified`
>   - __Properties :__
>       - `data` – The response from the server.

        Verified: new Constructors.LaboratoryEvent 'LaboratoryAuthorizationVerified',
            data: null

The `LaboratoryAuthorizationVerified` event fires when the first request non–OAuth-related API request goes through.
This is always a request to `/api/v1/accounts/verify_credentials`, and the response will always be the account data for the newly–signed-in user.
If you need to know the current user's id, listing for this event is your best hope of getting it.
A `LaboratoryAccountReceived` event with containing the account's `data` will be fired by this event's handler.

##  `LaboratoryAuthorizationFavourites`  ##

>   - __Builder :__ `Laboratory.Authorization.Favourites`
>   - __Properties :__
>       - `callback` – A function to call with the response.
>       - `before` – The status id at which to end the request.
>       - `after` – The status id at which to start the request.

        Favourites: new Constructors.LaboratoryEvent 'LaboratoryAuthorizationFavourites',
            callback: null
            before: null
            after: null

The `LaboratoryAuthorizationFavouritesRequested` event asks for the current user's favourites from the server.
The `callback` will not be remembered for future instances of this request.

##  `LaboratoryAuthorizationBlocks`  ##

>   - __Builder :__ `Laboratory.Authorization.Blocks`
>   - __Properties :__
>       - `callback` – A function to call with the response.
>       - `before` – The account id at which to end the request.
>       - `after` – The account id at which to start the request.

        Blocks: new Constructors.LaboratoryEvent 'LaboratoryAuthorizationBlocks',
            callback: null
            before: null
            after: null

The `LaboratoryAuthorizationBlocksRequested` event asks for the current user's blocks from the server.
The `callback` will not be remembered for future instances of this request.


#  COMPOSER EVENTS  #

    Events.Composer = Object.freeze

The __Composer__ module of Laboratory Events is comprised of those events which are related to composing and posting statuses.

| Event / Builder | Description |
| :-------------- | :---------- |
| `LaboratoryComposerUploadRequested` / `Laboratory.Composer.UploadRequested` | Fires when a media file should be sent to the server |
| `LaboratoryComposerUploadReceived` / `Laboratory.Composer.UploadReceived` | Fires when a media file has been received by the server |
| `LaboratoryComposerRequested` / `Laboratory.Composer.Requested` | Registers a composer callback function |
| `LaboratoryComposerPost` / `Laboratory.Composer.Post` | Fires when a post should be made to the server |
| `LaboratoryComposerRemoved` / `Laboratory.Composer.Removed` | Asks to remove a composer callback function |

##  `LaboratoryComposerUploadRequested`  ##

>   - __Builder :__ `Laboratory.Composer.UploadRequested`
>   - __Properties :__
>       - `file` – The file which should be uploaded.

        UploadRequested: new Constructors.LaboratoryEvent 'LaboratoryComposerUploadRequested',
            file: null

The `LaboratoryComposerUploadRequested` event sends a `file` to the Mastodon server for uploading.

##  `LaboratoryComposerUploadReceived`  ##

>   - __Builder :__ `Laboratory.Composer.UploadReceived`
>   - __Properties :__
>       - `data` – The response from the server.

        UploadReceived: new Constructors.LaboratoryEvent 'LaboratoryComposerUploadReceived',
            data: null

The `LaboratoryComposerUploadReceived` fires when an upload has been received by the Mastodon server, and its `data` contains the server's response.
The handler for `LaboratoryComposerUploadReceived` will call any composer callbacks with an immutable `Laboratory.MediaAttachment` object with the following properties:

| Property  | API Response  | Description |
| :-------: | :-----------: | :---------- |
|   `id`    |     `id`      | The id of the media attachment |
|  `href`   |     `url`     | The url of the media attachment |
| `preview` | `preview_url` | The url of a preview for the media attachment |
|  `type`   |    `type`     | Either `Laboratory.MediaType.PHOTO` (for a photo attachment) or `Laboratory.MediaType.VIDEO` (for a video attachment) |

##  `LaboratoryComposerRequested`:  ##

>   - __Builder :__ `Laboratory.Composer.Requested`
>   - __Properties :__
>       - `callback` – The callback to associate with the composer.

        Requested: new Constructors.LaboratoryEvent 'LaboratoryComposerRequested',
            file: null

The `LaboratoryComposerRequested` event requests an association between composer events and a provided `callback`.
This `callback` will receive media uploads from the handler for `LaboratoryComposerUploadReceived`; see the description of that event for more information.

##  `LaboratoryComposerPost`  ##

>   - __Builder :__ `Laboratory.Composer.Post`
>   - __Properties :__
>       - `text` – The text of the post.
>       - `inReplyTo` – The id of the post this post is replying to.
>       - `mediaAttachments` – An array of `Laboratory.MediaAttachment`s.
>       - `message` – A message to hide the post behind.
>       - `makePublic` – Whether to make the post public.
>       - `makeListed` – Whether to make the post listed.
>       - `makeNSFW` – Whether to mark the post's media as sensitive.

        Post: new Constructors.LaboratoryEvent "LaboratoryComposerPost",
            text: ""
            inReplyTo: null
            mediaAttachments: null
            message: null
            makePublic: false
            makeListed: false
            makeNSFW: true

The `LaboratoryComposerPost` event sends a post to the server.

##  `LaboratoryComposerRemove`  ##

>   - __Builder :__ `Laboratory.Composer.Remove`
>   - __Properties :__
>       - `callback` – The callback to disassociate from the composer.

        Remove: new Constructors.LaboratoryEvent 'LaboratoryComposerRemove',
            callback: null

The `LaboratoryComposerRemove` event requests that an association between composer events and the given `callback` be broken.
If no association has been made, the handler for this event does nothing.


#  INITIALIZATION EVENTS  #

    Events.Initialization = Object.freeze

The __Initialization__ module of Laboratory Events is comprised of those events which are related to initialization of the Laboratory store and handlers.
It is comprised of two events: `LaboratoryInitializationLoaded` and `LaboratoryInitializationReady`.

You can check `window.Laboratory.ready` as a means of verifying if these events have fired after-the-fact:
If `window.Laboratory.ready` exists, then `LaboratoryInitializationLoaded` has fired.
If it is `true`, then `LaboratoryInitializationReady` has fired as well.

**You should not fire Laboratory Initialization Events yourself.**
They will be ignored by Laboratory proper, but may confuse other components which you might have loaded.
However, you should listen for these events to know when proper communication with the Laboratory framework should begin.

| Event / Builder | Description |
| :-------------- | :---------- |
| `LaboratoryInitializationLoaded` / `Laboratory.Initialization.Loaded` | Fires when the Laboratory script has been loaded and run |
| `LaboratoryInitializationReady` / `Laboratory.Initialization.Ready` | Fires when the Laboratory event handlers are ready to receive events |

##  `LaboratoryInitializationLoaded`  ##

>   - __Builder :__ `Laboratory.Initialization.Loaded`
>   - __Properties :__ None.

        Loaded: new Constructors.LaboratoryEvent 'LaboratoryInitializationLoaded'

The `LaboratoryInitializationLoaded` event fires when the Laboratory script has been loaded and run, and can be used when loading Laboratory in an asynchronous manner.
After this event fires, it is safe to use the `Laboratory` object in your code.
Before this event fires, the `Laboratory` object will likely not have been defined yet.

Note that this event does not indicate whether the `Laboratory` handlers have been assigned to their appropriate events yet; for that, use `LaboratoryInitializationReady`.

##  `LaboratoryInitializationReady`  ##

>   - __Builder :__ `Laboratory.Initialization.Ready`
>   - __Properties :__ None.

        Ready: new Constructors.LaboratoryEvent 'LaboratoryInitializationReady'

The `LaboratoryInitializationReady` event fires when the Laboratory handlers have been assigned to their appropriate events.
After this event fires, it is safe to dispatch `Laboratory` events.
Before this event fires, it is unlikely (although not *impossible*) that they will be acted upon.

Laboratory waits for the entire document to be loaded before assigning its handlers; consequently, there is a possibility that `LaboratoryInitializationLoaded` will fire well before `LaboratoryInitializationReady`, especially with scripts loaded synchronously.
Of the two, `LaboratoryInitializationReady` is almost always the one to listen for.


#  STATUS EVENTS  #

    Events.Status = Object.freeze

The __Status__ module of Laboratory Events is comprised of those events which are related to interacting with Mastodon statuses.

| Event / Builder | Description |
| :-------------- | :---------- |
| `LaboratoryStatusRequested` / `Laboratory.Status.Requested` | Requests a status from the Mastodon API |
| `LaboratoryStatusReceived` / `Laboratory.Status.Received` | Fired when a status is received from the Mastodon API |
| `LaboratoryStatusReblogs` / `Laboratory.Status.Reblogs` | Requests the users which have reblogged a status from the Mastodon API |
| `LaboratoryStatusFavourites` / `Laboratory.Status.Favourites` | Requests the users which have favourited a status from the Mastodon API |
| `LaboratoryStatusSetReblog` / `Laboratory.Status.SetReblog` | Informs the Mastodon API that a status should be (un-)reblogged |
| `LaboratoryStatusSetFavourite` / `Laboratory.Status.SetFavourite` | Informs the Mastodon API that a status should be (un-)favourited |
| `LaboratoryStatusDeletion` / `Laboratory.Status.Deletion` | Informs the Mastodon API that a status should be deleted |

##  `LaboratoryStatusRequested`  ##

>   - __Builder :__ `Laboratory.Status.Requested`
>   - __Properties :__
>       - `id` – The id of the status.
>       - `callback` – The callback to call when the status is received.

        Requested: new Constructors.LaboratoryEvent "LaboratoryStatusRequested",
            id: null
            callback: null

The `LaboratoryStatusRequested` event requests detailed information on a status with the given `id`.
Its `callback` will receive a [`Laboratory.Post`](../Constructors/Post.litcoffee) object containing the status.
This callback is not remembered so be sure to specify one each time.

##  `LaboratoryStatusReceived`  ##

>   - __Builder :__ `Laboratory.Status.Received`
>   - __Properties :__
>       - `data` – The response from the server.

        Received: new Constructors.LaboratoryEvent "LaboratoryStatusReceived",
            data: null

The `LaboratoryStatusReceived` event describes a response from the server for a Laboratory status request.
It will also update any timelines in which the status is contained.
Generally speaking, this isn't something you need to listen for yourself, as the callback you provided when you requested the data will have also been called.

##  `LaboratoryStatusReblogs`  ##

>   - __Builder :__ `Laboratory.Status.Reblogs`
>   - __Properties :__
>       - `id` – The id of the status.
>       - `callback` – The callback to call when the reblogs are received.
>       - `before` – The id at which to end the request.
>       - `after` – The id at which to start the request.

        Reblogs: new Constructors.LaboratoryEvent "LaboratoryStatusReblogs",
            id: null
            callback: null
            before: null
            after: null

The `LaboratoryStatusReblogs` event requests who has reblogged a status with the given `id`.
Its `callback` will receive an array of [`Laboratory.Profile`](../Constructors/Profile.litcoffee) objects, containing the requested users.
The range of ids covered by this list can be provided through `before` and `after`.

##  `LaboratoryStatusFavourites`  ##

>   - __Builder :__ `Laboratory.Status.Favourites`
>   - __Properties :__
>       - `id` – The id of the status.
>       - `callback` – The callback to call when the favourites are received.
>       - `before` – The id at which to end the request.
>       - `after` – The id at which to start the request.

        Favourites: new Constructors.LaboratoryEvent "LaboratoryStatusFavourites",
            id: null
            callback: null
            before: null
            after: null

The `LaboratoryStatusFavourites` event requests who has favourited a status with the given `id`.
Its `callback` will receive an array of [`Laboratory.Profile`](../Constructors/Profile.litcoffee) objects, containing the requested users.
The range of ids covered by this list can be provided through `before` and `after`.

##  `LaboratoryStatusSetReblog`  ##

>   - __Builder :__ `Laboratory.Status.SetReblog`
>   - __Properties :__
>       - `id` – The id of the status.

        SetReblog: new Constructors.LaboratoryEvent "LaboratoryStatusSetReblog",
            id: null

The `LaboratoryStatusSetReblog` event requests a reblog on a status with the given `id`.
Once this request goes through, a `LaboratoryStatusReceived` event will fire with the updated status information.

##  `LaboratoryStatusSetFavourite`  ##

>   - __Builder :__ `Laboratory.Status.SetFavourite`
>   - __Properties :__
>       - `id` – The id of the status.

        SetFavourite: new Constructors.LaboratoryEvent "LaboratoryStatusSetFavourite",
            id: null

The `LaboratoryStatusSetFavourite` event requests a favourite on a status with the given `id`.
Once this request goes through, a `LaboratoryStatusReceived` event will fire with the updated status information.

##  `LaboratoryStatusDeletion`  ##

>   - __Builder :__ `Laboratory.Status.Deletion`
>   - __Properties :__
>       - `id` – The id of the status.

        Deletion: new Constructors.LaboratoryEvent "LaboratoryStatusDeletion",
            id: null

The `LaboratoryStatusDeletion` event requests a deletion on a status with the given `id`.
It will also remove the status from the Laboratory internal store.


#  TIMELINE EVENTS  #

    Events.Timeline = Object.freeze

The __Timeline__ module of Laboratory Events is comprised of those events which are related to Mastodon timelines.
Laboratory makes no external distinction between timelines of statuses and timelines of notifications, and you can use these events to interface with both.

| Event / Builder | Description |
| :-------------- | :---------- |
| `LaboratoryTimelineRequested` / `Laboratory.Timeline.Requested` | Fires when a connection to a timeline is requested |
| `LaboratoryTimelineReceived` / `Laboratory.Timeline.Received` | Fires when information posts from a timeline have been received from the server. |
| `LaboratoryTimelineRemoved` / `Laboratory.Timeline.Removed` | Fires when a connection to a timeline should be removed |

##  `LaboratoryTimelineRequested`  ##

>   - __Builder :__ `Laboratory.Timeline.Requested`
>   - __Properties :__
>       - `name` – The name of the timeline.
>       - `callback` – The callback to associate with the timeline.
>       - `before` – The status id at which to end the timeline request.
>       - `after` – The status id at which to start the timeline request.

        Requested: new Constructors.LaboratoryEvent 'LaboratoryTimelineRequested',
            name: null
            callback: null
            before: null
            after: null

The `LaboratoryTimelineRequested` event requests a timeline's data, and associates a `callback` function to be called when the data is received.
You can optionally specify the range to pull the timeline from with `before` and `after`.

The `name` sent with the event is used to determine which timeline to fetch, and must take one of the following values:

- __`home` :__ Retrieves the user's home timeline.
- __`community` :__ Retrieves the local timeline.
- __`global` :__ Retrieves the global timeline.
- __`hashtag/…` :__ Retrieves the given hashtag.
- __`user/…` :__ Retrieves the timeline for the given user.
- __`notifications` :__ Retrieves the user's notifications timeline.

Timeline data is sent to callbacks via an immutable object with two properties.
The first, `postOrder`, is an array of the ids of every post in the timeline, in order from newest to oldest.
The second, `posts`, is an object whose properties are post ids and whose values are either [`Laboratory.Post`](../Constructors/Post.litcoffee) objects or (in the case of a notifications timeline) [`Laboratory.Follow`](../Constructors/Follow.litcoffee) objects.

##  `LaboratoryTimelineReceived`  ##

>   - __Builder :__ `Laboratory.Timeline.Received`
>   - __Properties :__
>       - `data` – The response from the server.
>       - `params` – Parameters passed through from the request.

        Received: new Constructors.LaboratoryEvent 'LaboratoryTimelineReceived',
            data: null
            params: null

The `LaboratoryTimelineReceived` event contains the server's response to a request for timeline data.
This data will be processed by the handler and sent to the associated callbacks, so it is unlikely you will need to interface with this event yourself.
The name of the timeline (see above) is stored in `params.name`, and the timeline data is stored as described in `data`.

When a timeline's data is processed, any embedded accounts will be dispatched to `LaboratoryAccountReceived`.
These will not necessarily be available in time for the callback itself (which is executed synchronously), but should be available in time for any asynchronous calls that the callback might trigger; for example, a call to the renderer.

##  `LaboratoryTimelineRemoved`  ##

>   - __Builder :__ `Laboratory.Timeline.Removed`
>   - __Properties :__
>       - `name` – The name of the timeline.
>       - `callback` – The callback to remove from the timeline.

        Removed: new Constructors.LaboratoryEvent 'LaboratoryTimelineRemoved',
            name: null
            callback: null

The `LaboratoryTimelineRemoved` event requests that a callback be removed from a timeline.
Unlike with accounts, timelines *must* have at least one callback associated with them or else their data will be deleted to free up memory.
Of course, this data can always be re-requested from the server at a later time.


#  LABORATORY EVENT HANDLERS  #

The __Laboratory Event Handlers__ provide the backend for the [__Laboratory Event API__](../Events/).
These files contain the actual server calls, information processing, and data handling of the Laboratory engine.

For the most part, you probably don't need to know what actually goes on in here to use Laboratory, because you will never have direct access to the Laboratory handlers or the store.
However, if you want to know what Laboratory is doing behind-the-scenes, this file is your answer.

##  Implementation  ##

Here we set up our internal `Handlers` object.
This object will *not* be made available to our external `window.Laboratory` object.

    Handlers = {}

###  `handle()`:

The `handle()` function just associates a `type` with a `callback`.
It sets things up so we can easily add our handlers to the document later.
We also do a few checks before running the callback to make sure it actually is receiving an appropriate event response.

    handle = (builder, callback) ->
        console.log callback if not builder
        typedCallback = (event) ->
            return unless event? and this? and event.type is builder.type
            callback.call this, event
        typedCallback.type = builder.type
        return Object.freeze typedCallback

###  `serverRequest()`:

The `serverRequest()` function conveniently performs an `XMLHttpRequest` and binds it to a callback with the response `data` and additional `params`.
We will use it in our handlers to actually send our requests to the API.

    serverRequest = (method, location, contents, accessToken, onComplete, params) ->

####  Creating the request.

This is fairly simple; we just create an XMLHttpRequest.
You can see we set the `Authorization` header using our access token, if one was provided.

        return unless method is "GET" or method is "POST" or method is "DELETE"
        request = new XMLHttpRequest()
        request.open method, location
        if method is "POST" and not (contents instanceof FormData) then request.setRequestHeader "Content-type", "application/x-www-form-urlencoded"
        else if method isnt "POST" then contents = undefined
        request.setRequestHeader "Authorization", "Bearer " + accessToken if accessToken

####  The callback.

This is the function that is called once the request finishes loading.
We define it inside our `requestFromAPI()` function so that it has access to our `request` and `onComplete` variables.
We also pass through any provided `params`.

        callback = ->
            prevMatches = request.getResponseHeader("Link")?.match /<\s*([^,]*)\s*>\s*;[^,]*[;\s]rel="?prev(?:ious)?"?/
            nextMatches = request.getResponseHeader("Link")?.match /<\s*([^,]*)\s*>\s*;[^,]*[;\s]rel="?next"?/
            return unless request.readyState is XMLHttpRequest.DONE and 200 <= request.status <= 205
            onComplete
                params: params
                data: if request.status <= 202 then JSON.parse request.responseText else null
                prev: if prevMatches? then prevMatches[1] else null
                next: if nextMatches? then nextMatches[1] else null
            request.removeEventListener "readystatechange", callback, false

####  Sending the request.

We can now add our event listener and send the request.

        request.addEventListener "readystatechange", callback, false
        request.send contents

        return


#  ACCOUNT HANDLERS  #

    Handlers.Account = Object.freeze

##  `LaboratoryAccountRelationshipsRequested`  ##

When an account's relationships are requested, we just forward the request to the server, with `Events.RelationshipsReceived()` as our callback.

        RelationshipsRequested: handle Events.Account.RelationshipsRequested, (event) ->
            return unless isFinite id = Number event.detail.id
            serverRequest "GET", @auth.api + "/accounts/relationships?id=" + id, null, @auth.accessToken, Events.Account.RelationshipsReceived.dispatch
            return

##  `LaboratoryAccountRelationshipsReceived`  ##

When an account's relationships are received, we need to update the related accounts to reflect this.
We also call any related callbacks with the new information.

        RelationshipsReceived: handle Events.Account.RelationshipsReceived, (event) ->

            return unless (data = event.detail.data) instanceof Array

            for relationships in data
                continue unless isFinite(id = Number relationships.id) and @accounts[id]?
                relationship = Enumerals.Relationship.fromValue(
                    Enumerals.Relationship.FOLLOWED_BY * relationships.followed_by +
                    Enumerals.Relationship.FOLLOWING * relationships.following +
                    Enumerals.Relationship.REQUESTED * relationships.requested +
                    Enumerals.Relationship.BLOCKING * relationships.blocking +
                    Enumerals.Relationship.SELF * (relationships.id is @auth.me)
                ) || Enumerals.Relationship.UNKNOWN
                if @accounts[id].relationship isnt relationship
                    @accounts[id] = new Constructors.Profile @accounts[id], @auth.origin, relationship
                    continue unless @interfaces.accounts[id]?
                    callback @accounts[id] for callback in @interfaces.accounts[id]

            return

##  `LaboratoryAccountRequested`  ##

We have two things that we need to do when an account is requested: query the server for its information, and hold onto the callback requesting access.
We do those here.

        Requested: handle Events.Account.Requested, (event) ->

            return unless isFinite id = Number event.detail.id
            callback = null unless typeof (callback = event.detail.callback) is "function"

The `interfaces.accounts` object will store our account callbacks, organized by the account ids.
We need to create an array to store our callback in if one doesn't already exist:

            Object.defineProperty @interfaces.accounts, id, {value: [], enumerable: yes} unless @interfaces.accounts[id] instanceof Array

We can now add our callback, if applicable.

            @interfaces.accounts[id].push callback unless not callback? or callback in @interfaces.accounts[id]

If we already have information on this account loaded into our store, we can send the callback that information right away.
Note that accounts are stored as immutable objects.

            callback @accounts[id] if @accounts[id] and callback?

Next, we send the request.
Upon completion, it should trigger an `LaboratoryAccountReceived` event so that we can handle the data.

            serverRequest "GET", @auth.api + "/accounts/" + id, null, @auth.accessToken, Events.Account.Received.dispatch

We also need to request the user's relationship to the account, since that doesn't come with our first request.
We can do that with a `LaboratoryAccountRelationshipsRequested` event.

            Events.Account.RelationshipsRequested.dispatch {id}

            return

##  `LaboratoryAccountReceived`  ##

When an account's data is received, we need to update its information both inside our store, and with any callbacks which might also be depending on it.

        Received: handle Events.Account.Received, (event) ->

            return unless (data = event.detail.data) instanceof Object and isFinite id = Number data.id

Right away, we can generate a `Profile` from our `data`.

            profile = new Constructors.Profile data, @auth.origin

If we already have a profile associated with this account id, then we need to check if anything has changed.
If it hasn't, we have nothing more to do.

            return if @accounts[id] and profile.compare @accounts[id]

Otherwise, something has changed.
We overwrite the previous data and fire all of our associated callback functions.

            @accounts[id] = profile
            return unless @interfaces.accounts[id]?
            callback @accounts[id] for callback in @interfaces.accounts[id]

            return

##  `LaboratoryAccountRemoved`  ##

`LaboratoryAccountRemoved` has a much simpler handler than our previous two:
We just look for the provided callback, and remove it from our account interface if it exists.

        Removed: handle Events.Account.Removed, (event) ->

Of course, if we don't have any callbacks assigned to the provided id, we can't do anything.

            return unless isFinite(id = Number event.detail.id) and typeof (callback = event.detail.callback) is "function" and @interfaces.accounts[id] instanceof Array

This iterates over our callbacks until we find the right one, and removes it from the array.

            index = 0;
            index++ until @interfaces.accounts[id][index] is callback or index >= @interfaces.accounts[id].length
            @interfaces.accounts[id].splice index, 1

…And we're done!

            return

##  `LaboratoryAccountFollowers`  ##

When a `LaboratoryAccountFollowers` event is fired, we simply petition the server for a list of followers and pass this to our callback.
We wrap the callback in a function which formats the follower list for us.

        Followers: handle Events.Account.Followers, (event) ->

            return unless isFinite(id = Number event.detail.id) and typeof (callback = event.detail.callback) is "function"

            query = ""
            query += "?max_id=" + Number event.detail.before if isFinite event.detail.before
            query += (if query then "&" else "?") + "since_id=" + Number event.detail.after if isFinite event.detail.after

            serverRequest "GET", @auth.api + "/accounts/" + id + "/followers" + query, null, @auth.accessToken, (response) -> callback(Constructors.Profile(data) for data in response.data)

##  `LaboratoryAccountFollowing`  ##

When a `LaboratoryAccountFollowing` event is fired, we simply petition the server for a list of people following the user and pass this to our callback.
We wrap the callback in a function which formats the list for us.

        Following: handle Events.Account.Following, (event) ->

            return unless isFinite(id = Number event.detail.id) and typeof (callback = event.detail.callback) is "function"

            query = ""
            query += "?max_id=" + Number event.detail.before if isFinite event.detail.before
            query += (if query then "&" else "?") + "since_id=" + Number event.detail.after if isFinite event.detail.after

            serverRequest "GET", @auth.api + "/accounts/" + id + "/following" + query, null, @auth.accessToken, (response) -> callback(Constructors.Profile(data) for data in response.data)

##  `LaboratoryAccountSearch`  ##

When a `LaboratoryAccountSearch` event is fired, we send the server a user search query and pass this to our callback.
We wrap the callback in a function which formats the list of results for us.

        Search: handle Events.Account.Search, (event) ->

            return unless isFinite(id = Number event.detail.id) and typeof (callback = event.detail.callback) is "function"

            query = ""
            query += "?q=" + event.detail.query if event.detail.query
            query += (if query then "&" else "?") + "limit=" + Number event.detail.limit if isFinite event.detail.limit

            serverRequest "GET", @auth.api + "/accounts/" + id + "/search" + query, null, @auth.accessToken, (response) -> callback(Constructors.Profile(data) for data in response.data)

##  `LaboratoryAccountFollow`  ##

When a `LaboratoryAccountFollow` event is fired, we send the server a request to follow/unfollow the specified user.
We issue `Events.Account.RelationshipsReceived()` as our callback function, since the result of this request should be an object giving the account's updated relationship to the user.

        Follow: handle Events.Account.Follow, (event) ->

            return unless isFinite(id = Number event.detail.id)

            serverRequest "POST", @auth.api + "/accounts/" + id + (if event.detail.value then "/follow" else "/unfollow"), null, @auth.accessToken, Events.Account.RelationshipsReceived.dispatch

##  `LaboratoryAccountBlock`  ##

When a `LaboratoryAccountBlock` event is fired, we send the server a request to block/unblock the specified user.
We issue `Events.Account.RelationshipsReceived()` as our callback function, since the result of this request should be an object giving the account's updated relationship to the user.

        Block: handle Events.Account.Block, (event) ->

            return unless isFinite(id = Number event.detail.id)

            serverRequest "POST", @auth.api + "/accounts/" + id + (if event.detail.value then "/block" else "/unblock"), null, @auth.accessToken, Events.Account.RelationshipsReceived.dispatch


#  AUTHORIZATION HANDLERS  #

    Handlers.Authorization = Object.freeze

##  `LaboratoryAuthorizationClientRequested`  ##

The `LaboratoryAuthorizationClientRequested` handler requests a new client id and secret from the API, and fires `LaboratoryAuthorizationClientReceived` when it is granted.

        ClientRequested: handle Events.Authorization.ClientRequested,  (event) ->

First, we normalize our URL.
We also get our redirect URI at this point.

            a = document.createElement("a")
            a.href = event.detail.url
            url = a.origin
            a.href = event.detail.redirect || ""
            authURL = a.href

Now we can send our request.

            serverRequest "POST", url + "/api/v1/apps", "client_name=" + encodeURIComponent(String(event.detail.name).replace " ", "+") + "&redirect_uris=" + encodeURIComponent(authURL) + "&scopes=read+write+follow", null, Events.Authorization.ClientReceived.dispatch, {url, redirect: authURL}

            return

##  `LaboratoryAuthorizationClientReceived`  ##

The `LaboratoryAuthorizationClientReceived` handler stores a received client id and secret from the API in `localStorage`.
It then fires `LaboratoryAuthorizationRequested` to attempt to authenticate the user.

        ClientReceived: handle Events.Authorization.ClientReceived, (event) ->

            localStorage.setItem "Laboratory | " + event.detail.params.url, event.detail.params.redirect + " " + event.detail.data.client_id + " " + event.detail.data.client_secret

            Events.Authorization.Requested.dispatch
                url: event.detail.params.url
                redirect: event.detail.params.redirect

            return

###  `LaboratoryAuthorizationRequested`:

The `LaboratoryAuthorizationRequested` handler requests authorization from the user through the API.

        Requested: handle Events.Authorization.Requested,  (event) ->

First, we normalize our URL.
We also get our redirect URI at this point.

            a = document.createElement "a"
            a.href = event.detail.url
            url = a.origin
            a.href = event.detail.redirect || ""
            authURL = a.href


If we don't have a client id or secret we need to get one.

            if localStorage.getItem("Laboratory | " + url) then [redirect, clientID, clientSecret, accessToken] = localStorage.getItem("Laboratory | " + url).split " ", 4

            unless (redirect and not event.detail.redirect? or redirect is authURL) and clientID? and clientSecret?
                Events.Authorization.ClientRequested.dispatch {url, redirect: authURL, name: event.detail.name}
                return

Otherwise, we can load our authorization data into our state for later use.

            @auth.origin = url
            @auth.api = @auth.origin + "/api/v1"
            @auth.clientID = clientID
            @auth.clientSecret = clientSecret
            @auth.redirect = authURL

If we have an access token, then we close our window (if open) and skip straight to verification.

            if accessToken
                @auth.accessToken = accessToken
                window.open("about:blank", "LaboratoryOAuth").close()
                serverRequest "GET", @auth.api + "/accounts/verify_credentials", null, @auth.accessToken, Events.Authorization.Verified.dispatch
                return

Otherwise, we open a popup for authorization.
It will fire `LaboratoryAuthorizationGranted` with the granted code if it succeeds.

            window.open url + "/oauth/authorize?client_id=" + clientID + "&response_type=code&redirect_uri=" + encodeURIComponent(authURL), "LaboratoryOAuth"

            return

###  `LaboratoryAuthorizationGranted`:

The `LaboratoryAuthorizationGranted` handler is called when the user grants access to the Laboratory app from a popup.

        Granted: handle Events.Authorization.Granted, (event) ->

If our authentication data hasn't been loaded into the state, then this event must have been called erroneously.

            return unless @auth.origin? and @auth.clientID? and @auth.clientSecret? and @auth.redirect?

We can now close our popup.

            event.detail.window.close() if event.detail.window?

Finally, we can request our authorization token from the server using the code we were just given.

            serverRequest "POST", @auth.origin + "/oauth/token", "client_id=" + @auth.clientID + "&client_secret=" + @auth.clientSecret + "&redirect_uri=" + encodeURIComponent(@auth.redirect) + "&grant_type=authorization_code&code=" + event.detail.code, null, Events.Authorization.Received.dispatch

            return

###  `LaboratoryAuthorizationReceived`:

The `LaboratoryAuthorizationReceived` handler is called when the user grants access to the Laboratory app from a popup.

        Received: handle Events.Authorization.Received, (event) ->

If our authorization failed, then we *sigh* have to start all over again from scratch.

            unless event.detail.data?.access_token
                localStorage.setItem "Laboratory | " + @auth.origin, ""
                Events.Authorization.Requested
                    url: @auth.origin
                    clientID: @auth.clientID
                    clientSecret: @auth.clientSecret
                return

We can now load our tokens.
We store our access token in `localStorage` for later use as well.

            @auth.accessToken = event.detail.data.access_token
            localStorage.setItem "Laboratory | " + @auth.origin, @auth.redirect + " " + @auth.clientID + " " + @auth.clientSecret + " " + @auth.accessToken

*Finally*, we try to grab the account of the newly-signed-in user, using `Authorization.Verified` as our callback.

            serverRequest "GET", @auth.api + "/accounts/verify_credentials", null, @auth.accessToken, Events.Authorization.Verified.dispatch

            return

###  `LaboratoryAuthorizationVerified`:

The `LaboratoryAuthorizationVerified` handler is called when the credentials of a user have been verified.
Its `data` contains the account information for the just-signed-in user.
We keep track of its id, but pass the rest on to `LaboratoryAccountReceived`.

        Verified: handle Events.Authorization.Verified, (event) ->
            unless isFinite event.detail.data?.id
                localStorage.setItem "Laboratory | " + @auth.origin, ""
                Events.Authorization.Requested
                    url: @auth.origin
                    clientID: @auth.clientID
                    clientSecret: @auth.clientSecret
                return
            @auth.me = Number event.detail.data.id
            Events.Account.Received.dispatch {data: event.detail.data}
            return

##  `LaboratoryAuthorizationFavourites`  ##

When a `LaboratoryAuthorizationFavourites` event is fired, we simply petition the server for a list of favourites for the current user.
We wrap the callback in a function which formats the list for us.

        Favourites: handle Events.Authorization.Favourites, (event) ->

            return unless typeof (callback = event.detail.callback) is "function"

            query = ""
            query += "?max_id=" + Number event.detail.before if isFinite event.detail.before
            query += (if query then "&" else "?") + "since_id=" + Number event.detail.after if isFinite event.detail.after

            serverRequest "GET", @auth.api + "/favourites" + query, null, @auth.accessToken, (response) -> callback(Constructors.Post(data) for data in response.data)

##  `LaboratoryAuthorizationBlocks`  ##

When a `LaboratoryAuthorizationBlocks` event is fired, we simply petition the server for a list of people following the user and pass this to our callback.
We wrap the callback in a function which formats the list for us.

        Blocks: handle Events.Authorization.Blocks, (event) ->

            return unless typeof (callback = event.detail.callback) is "function"

            query = ""
            query += "?max_id=" + Number event.detail.before if isFinite event.detail.before
            query += (if query then "&" else "?") + "since_id=" + Number event.detail.after if isFinite event.detail.after

            serverRequest "GET", @auth.api + "/blocks" + query, null, @auth.accessToken, (response) -> callback(Constructors.Profile(data) for data in response.data)


#  COMPOSER HANDLERS  #

    Handlers.Composer = Object.freeze

##  `LaboratoryComposerUploadRequested`  ##

The `LaboratoryComposerUploadRequested` handler simply uploads the provided file to the server.

        UploadRequested: handle Events.Composer.UploadRequested, (event) ->

            return unless (file = event.detail.file) instanceof File

            form = new FormData()
            form.append "file", file
            serverRequest "POST", @auth.api + "/media", form, @auth.accessToken, Events.Composer.UploadReceived.dispatch

            return

##  `LaboratoryComposerUploadReceived`  ##

The `LaboratoryComposerUploadReceived` handler calls any registered composer callbacks with the `MediaAttachment` sent from the server as its response.

        UploadReceived: handle Events.Composer.UploadReceived, (event) ->
            callback new MediaAttachment event.detail.data for callback in @interfaces.composer
            return

##  `LaboratoryComposerRequested`  ##

The `LaboratoryComposerRequested` handler registers a callback with the composer if it hasn't been already.

        Requested: handle Events.Composer.Requested, (event) ->

            callback = null unless typeof (callback = event.detail.callback) is "function"
            @interfaces.composer.push callback unless not callback? or callback in @interfaces.composer

            return

##  `LaboratoryComposerPost`  ##

The `LaboratoryComposerPost` handler posts the given status, with the provided settings.

        Requested: handle Events.Composer.Requested, (event) ->
            form = new FormData()
            form.append "status", String event.detail.text
            form.append "in_reply_to_id", String Number event.detail.inReplyTo if isFinite event.detail.inReplyTo
            if event.detail.mediaAttachments instanceof Array
                form.append "media_ids[]", String Number attachment for attachment, index in event.detail.mediaAttachments when isFinite attachment
            form.append "sensitive", "true" if event.detail.makeNSFW
            form.append "spoiler_text", String event.detail.message if event.detail.message
            form.append "visibility", switch
                when not event.detail.makePublic then "private"
                when not event.detail.makeListed then "unlisted"
                else "public"
            serverRequest "POST", @auth.api + "/statuses", form, @auth.accessToken, Events.Status.Received.dispatch

            return

##  `LaboratoryComposerRemoved`  ##

The `LaboratoryComposerRemoved` handler removes a callback from the composer.

        Requested: handle Events.Composer.Requested, (event) ->

            index = 0;
            index++ until @interfaces.composer[index] is callback or index >= @interfaces.composer.length
            @interfaces.composer.splice index, 1

            return


#  INITIALIZATION HANDLERS  #

    Handlers.Initialization = Object.freeze {}

Laboratory doesn't handle its initialization events.
They exist for the sake of users only!


#  STATUS HANDLERS  #

    Handlers.Status = Object.freeze

##  `LaboratoryStatusRequested`  ##

When a `LaboratoryStatusRequested` event is fired, we send the server a request for a status and pass the result simultaneously to our callback and to `LaboratoryStatusReceived`.

        Requested: handle Events.Status.Requested, (event) ->

            return unless isFinite(id = Number event.detail.id)
            callback = null unless typeof (callback = event.detail.callback) is "function"

            serverRequest "GET", @auth.api + "/statuses/" + id, null, @auth.accessToken, (response) ->
                Events.Status.Received response
                callback Constructors.Post response.data if callback

            return

##  `LaboratoryStatusReceived`  ##

The `LaboratoryStatusReceived` event attempts to update any timelines which contain a given status with new information.
We just call a `LaboratoryTimelineReceived` event for each affected timeline with an array containing the status.

        Received: handle Events.Status.Received, (event) ->

            timelinesToUpdate = (name for name, timeline of @timelines when event.detail.data.id in timeline.postOrder)
            Events.Timeline.Received.dispatch {data: [event.detail.data], params: {name}} for name in timelinesToUpdate

            return

##  `LaboratoryStatusReblogs`  ##

When a `LaboratoryStatusReblogs` event is fired, we simply petition the server for a list of users who reblogged the given status, and pass this to our callback.
We wrap the callback in a function which formats the user list for us.

        Reblogs: handle Events.Status.Reblogs, (event) ->

            return unless isFinite(id = Number event.detail.id) and typeof (callback = event.detail.callback) is "function"

            query = ""
            query += "?max_id=" + Number event.detail.before if isFinite event.detail.before
            query += (if query then "&" else "?") + "since_id=" + Number event.detail.after if isFinite event.detail.after

            serverRequest "GET", @auth.api + "/statuses/" + id + "/reblogged_by" + query, null, @auth.accessToken, (response) -> callback(Constructors.Profile(data) for data in response.data)

##  `LaboratoryStatusFavourites`  ##

When a `LaboratoryStatusFavourites` event is fired, we simply petition the server for a list of users who favourited the given status, and pass this to our callback.
We wrap the callback in a function which formats the list for us.

        Favourites: handle Events.Status.Favourites, (event) ->

            return unless isFinite(id = Number event.detail.id) and typeof (callback = event.detail.callback) is "function"

            query = ""
            query += "?max_id=" + Number event.detail.before if isFinite event.detail.before
            query += (if query then "&" else "?") + "since_id=" + Number event.detail.after if isFinite event.detail.after

            serverRequest "GET", @auth.api + "/statuses/" + id + "/favourited_by" + query, null, @auth.accessToken, (response) -> callback(Constructors.Profile(data) for data in response.data)

##  `LaboratoryStatusSetReblog`  ##

When a `LaboratoryStatusSetReblog` event is fired, we send the server a request to reblog/unreblog the specified status.
We issue `Events.Status.Received()` as our callback function, with the response from the server.
This will be (in the case of a reblog) a new reblog-post, or (in the case of an unreblog) the original.

        Follow: handle Events.Status.SetReblog, (event) ->

            return unless isFinite(id = Number event.detail.id)

            serverRequest "POST", @auth.api + "/statuses/" + id + (if event.detail.value then "/reblog" else "/unreblog"), null, @auth.accessToken, Events.Status.Received.dispatch

##  `LaboratoryStatusSetFavourite`  ##

When a `LaboratoryStatusSetFavourite` event is fired, we send the server a request to favourite/unfavourite the specified status.
We issue `Events.Status.Received()` as our callback function, since the result of this request should be an updated representation of the favourited status.

        SetFavourite: handle Events.Status.SetFavourite, (event) ->

            return unless isFinite(id = Number event.detail.id)

            serverRequest "POST", @auth.api + "/statuses/" + id + (if event.detail.value then "/favourite" else "/unfavourite"), null, @auth.accessToken, Events.Status.Received.dispatch

##  `LaboratoryStatusDeletion`  ##

When a `LaboratoryStatusDeletion` event is fired, we send the server a request to delete the specified status.
We also need to update any timelines which used to contain the status such that they don't any longer.

        Deletion: handle Events.Status.Deletion, (event) ->

            return unless isFinite(id = Number event.detail.id)

            serverRequest "DELETE", @auth.api + "/statuses/" + id, null, @auth.accessToken

            timelinesToUpdate = (name for name, timeline of @timelines when id in timeline.postOrder)
            Events.Timeline.Received.dispatch {data: [{id}], params: {name}} for name in timelinesToUpdate


#  TIMELINE HANDLERS  #

    Handlers.Timeline = Object.freeze

##  `LaboratoryTimelineRequested`  ##

We have two things that we need to do when timeline is requested: query the server for its information, and hold onto the callback requesting access.
We do this here.

        Requested: handle Events.Timeline.Requested, (event) ->

            callback = null unless typeof (callback = event.detail.callback) is "function"

The name of the timeline doesn't directly correspond to the API URL we use to access it, so we derive that here.

            name = String event.detail.name
            url = @auth.api + switch
                when name is "global" then "/timelines/public"
                when name is "community" then "/timelines/public?local=true"
                when name is "home" then "/timelines/home"
                when name.substr(0, 8) is "hashtag/" then "/timelines/tag/" + name.substr(8)
                when name.substr(0, 5) is "user/" then "/accounts/" + name.substr(5) + "/statuses"
                when name is "notifications" then "/notifications"
                else name

If we want to adjust the slice of time our timeline is taken from, we can do that now.

            url += (if name isnt community then "?" else "&") + "max_id=" + event.detail.before if event.detail.before?
            url += (if name isnt community and not event.detail.before? then "?" else "&") + "since_id=" + event.detail.since if event.detail.since?

The `interfaces.timelines` object will store our timeline callbacks, organized by name.
We need to create an array to store our callback in if one doesn't already exist:

            Object.defineProperty @interfaces.timelines, name, {value: [], enumerable: yes} unless @interfaces.timelines[name] instanceof Array

We can now add our callback.

            @interfaces.timelines[name].push event.detail.callback if event.detail.callback?

Next, we send the request.
Upon completion, it should trigger an `LaboratoryTimelineReceived` event so that we can handle the data.

            serverRequest "GET", url, null, @auth.accessToken, Events.Timeline.Received.dispatch, {name}

            return

###  `LaboratoryTimelineReceived`

When an timeline's data is received, we need to send an update to any callbacks which might be using it.

        Received: handle Events.Timeline.Received, (event) ->

            name = String event.detail.params.name
            return unless (data = event.detail.data) instanceof Array

If there aren't any callbacks depending on our data, then we do nothing.

            return unless @interfaces.timelines[name]?.length

If we don't have a place to stick our data yet, let's create it:

            Object.defineProperty @timelines, name, {value: Object.seal {posts: {}, postOrder: []}, enumerable: yes} unless (@timelines[name] instanceof Object) and (@timelines[name].posts instanceof Object) and (@timelines[name].postOrder instanceof Array)

We want to merge our timeline data with any existing data in our timelines and then provide our components with the result.

            posts = {}
            postOrder = []

We load the new information first because it will have the most recent data.
If an item has an id but not an account, then we take this to signify that the post has been deleted.
We also fire an `LaboratoryAccountReceived` event containing the account data we received with the post.

            receivedAccounts = []

            for item in data
                continue unless item.id
                unless item.account?
                    posts[id] = null
                    continue
                unless item.id in postOrder
                    post = if item.type is "follow" then new Constructors.Follow(item, @accounts) else new Constructors.Post item, @accounts
                    postOrder.push item.id
                    posts[item.id] = post
                unless item.account.id in receivedAccounts
                    receivedAccounts.push item.account.id
                    Events.Account.Received.dispatch {data: item.account}
                unless not item.status? or item.status.account.id in receivedAccounts
                    receivedAccounts.push item.status.account.id
                    Events.Account.Received.dispatch {data: item.status.account}
                unless not item.reblog? or item.reblog.account.id in receivedAccounts
                    receivedAccounts.push item.reblog.account.id
                    Events.Account.Received.dispatch {data: item.reblog.account}

Then we load any previously-existing posts if they haven't already been loaded.

            for id in @timelines[name].postOrder when not (id of posts)
                posts[id] = @timelines[name].posts[id]
                postOrder.push(id)

We can now sort our post order and save our data, giving our timeline callbacks the end result.

            postOrder.sort (a, b) -> b - a

            @timelines[name].postOrder = Object.freeze postOrder
            @timelines[name].posts = Object.freeze posts

            response = Object.freeze {posts, postOrder}
            callback response for callback in @interfaces.timelines[name]

            return

##  `Timeline.Removed`  ##

`Timeline.Removed` has a much simpler handler than our previous two:
We just look for the provided callback, and remove it from our timeline interface.
Then, if there are no remaining timelines for that `name` (as is probable), we go ahead and get rid of that information to conserve memory.

        Removed: handle Events.Timeline.Removed, (event) ->

Of course, if we don't have any callbacks assigned to the provided name, we can't do anything.

            return unless @interfaces.timelines[name = String event.detail.name]?.length and typeof (callback = event.detail.callback) is "function"

This iterates over our callbacks until we find the right one, and removes it from the array.

            index = 0;
            index++ until @interfaces.timelines[name][index] is callback or index >= @interfaces.timelines[name].length
            @interfaces.timelines[name].splice index, 1

If we no longer have any callbacks assigned to the timeline, we re-initialize it in our store:

            return unless @timelines[name] instanceof Object
            unless @interfaces.timelines[name].length
                @timelines[name].posts = Object.freeze {}
                @timelines[name].postOrder = Object.freeze []

…And we're done!

            return


#  INSTALLING  #

Laboratory is written in Literate CoffeeScript, designed to compile to a single minified JavaScript file.
This file is available in [`/dist/laboratory.min.js`](../dist/laboratory.min.js).
If for some reason you feel the need to compile Laboratory from source yourself, the [`Cakefile`](../Cakefile) can be used to do so.

All of Laboratory's components are available through the `window.Laboratory` object, which this file provides.
Additionally, the `window.Laboratory.ready` property can be used to check if `LaboratoryInitializationReady` has already fired, and the `window.Laboratory.user` property can be used to obtain the id of the currently-logged-in user.
Laboratory doesn't have any external dependencies, and should run in any modern (ECMAScript 5–compliant; eg IE9) browser.

##  Implementation  ##

This script loads and runs the Laboratory engine.
Consequently, it is the last thing we load.

###  First steps:

We include informative text about the `Laboratory` package on `Laboratory.ℹ` and give the version number on `Laboratory.Nº` for intersted parties.
Laboratory follows semantic versioning, which translates into `Nº` as follows: `Major * 100 + Minor + Patch / 100`.
Laboratory thus assures that minor and patch numbers will never exceed `99` (indeed this would be quite excessive!).

    Laboratory =
        ℹ: """
                ............. LABORATORY ..............

                A client-side API for Mastodon, a free,
                   open-source social network server
                          - - by Kibigo! - -

                    Licensed under the MIT License.
                       Source code available at:
                https://github.com/marrus-sh/laboratory

                            Version 0.2.0
            """
        Nº: 2.0

####  Exposing Laboratory objects.

We don't expose *all* of Laboratory to the `window`—just the useful bits for extensions.
Thus, the following parts are exposed:

- `Constructors`
- `Events`
- `Enumerals`

The following parts are *not* exposed:

- Local functions/variables
- `Handlers`

To keep things compact, we merge everything onto a single `Laboratory` object.
This of course means that none of the submodules in `Constructors`, `Events`, or `Enumerals` can share the same name.
We also merge in our `Exposed` properties at this time.

    for module in [Constructors, Events, Enumerals]
        Object.defineProperty Laboratory, name, {value: submodule, enumerable: yes} for own name, submodule of module
    Object.defineProperty Laboratory, prop, {get: (-> Exposed[prop]), enumerable: yes} for prop of Exposed
    Object.defineProperty window, "Laboratory",
        value: Object.freeze Laboratory
        enumerable: yes

####  Declaring our objects have loaded.

Now that the `Laboratory` object is available to the `window`, we can fire our `Initialization.Loaded` event.

    Events.Initialization.Loaded.dispatch()

###  The Store:

Laboratory data is all stored in a single store, and then acted upon through events and event listeners.
The store is not available outside of those events specified below.

####  Loading the store.

We can now load the store.
We'll wrap this all in a closure to make extra sure that nobody has access to it except our handlers.

    run = ->

        store = Object.freeze
            accounts: {}
            auth: Object.seal
                accessToken: null
                api: null
                clientID: null
                clientSecret: null
                me: null
                origin: null
                redirect: null
            interfaces: Object.freeze
                accounts: {}
                composer: []
                timelines: {}
            timelines: {}

Because Laboratory is still in active development, `window["🏪"]` can be used to gain convenient access to our store.
Obviously, you shouldn't expect this to last.

        window["🏪"] = store

####  Adding our listeners.

Now that our store is created, we can initialize our event handlers, binding them to its value.
It's pretty easy; we just enumerate over `Handlers`.

        for category, object of Handlers
            document.addEventListener handler.type, handler.bind store for name, handler of object

####  Starting operations.

Finally, we fire our `Initialization.Ready` event, signalling that our handlers are ready to go.
We also set `Exposed.ready` to `true` so that scripts can tell Laboratory is running after-the fact, and make `Exposed.user` just point to `auth.me` in our `store`.

        Exposed.ready = yes
        Object.defineProperty Exposed, "user",
            get: -> store.auth.me
            enumerable: yes
            configurable: no
        Events.Initialization.Ready.dispatch()

        return

####  Running asynchronously.

We don't want the store loading before `document.body` or any of our other scripts, so we'll attach a `window.onload` event handler if our window isn't currently loaded.
(If it is, then we'll just call `run` right now.)

    if document.readyState is "complete" then run() else window.addEventListener "load", run
