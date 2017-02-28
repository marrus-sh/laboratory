If this is an API redirect, then we hand our opener our code.

    codesearch = location.search.match(/code=([^&]*)/)
    code = codesearch[1] if codesearch?
    if code? and window.opener.Laboratory then window.opener.Laboratory.Events.Authentication.Granted {window: window, code: code}

This sets up our Laboratory object:

    Object.defineProperty window, "Laboratory",
        value: Object.freeze
            Components: Object.freeze
                Columns: Object.freeze
                    parts: {}
                    productions: {}
                Modules: Object.freeze
                    parts: {}
                    productions: {}
                Shared: Object.freeze
                    parts: {}
                    productions: {}
                UI: Object.freeze
                    parts: {}
                    productions: {}
            Events: {}
            Handlers: {}
            Locales: {}
            Functions: {}
            Symbols: {}

We'll use `彁` in place of `React.createElement` for brevity.

    Object.defineProperty window, "彁", {value: React.createElement}

Depending on how we loaded React, the PureRenderMixin might not be where we expect:

    ReactPureRenderMixin = React.addons.PureRenderMixin unless ReactPureRenderMixin?

Semi-polyfill for `Symbol()`:

    unless window.Symbol
        window.Symbol = (n) ->
            return new Symbol(n) unless this instanceof Symbol
            @description = String n
            return Object.freeze this
        Symbol.prototype =
            toString: -> @description
            valueOf: -> this
            toSource: -> "Symbol(" + @description + ")";
        Object.freeze Symbol
        Object.freeze Symbol.prototype


#  `Laboratory.Symbols.Relationships`  #

>   ```javascript
>       //  Indicates the two users are the same:
>       Relationships.SELF
>       //  Indicates a user is being followed:
>       Relationships.FOLLOWING
>       //  Indicates a user is following the current user:
>       Relationships.FOLLOWED_BY
>       //  Indicates a mutual follow:
>       Relationships.MUTUALS
>       //  Indicates a follow request has been sent:
>       Relationships.REQUESTED
>       //  Indicates a follow request has been sent to a user following the current user:
>       Relationships.REQUESTED_MUTUALS
>       //  Indicates not following:
>       Relationships.NOT_FOLLOWING
>       //  Indicates a block:
>       Relationships.BLOCKING
>   ```

This file provides symbols for a number of relationships between users.

    Object.defineProperty Laboratory.Symbols, "Relationships",
        value: Object.freeze
            SELF: Symbol "LaboratoryRelationshipSelf"
            FOLLOWING: Symbol "LaboratoryRelationshipFollowing"
            FOLLOWED_BY: Symbol "LaboratoryRelationshipFollowedBy"
            MUTUALS: Symbol "LaboratoryRelationshipMutuals"
            REQUESTED: Symbol "LaboratoryRelationshipRequested"
            REQUESTED_MUTUALS: Symbol "LaboratoryRelationshipRequestedMutuals"
            NOT_FOLLOWING: Symbol "LaboratoryRelationshipNotFollowing"
            BLOCKING: Symbol "LaboratoryRelationshipBlocking"
        enumerable: true


#  `Laboratory.Components.Columns.parts.Column`  #

##  Usage  ##

>   ```jsx
>       <Column
>           id=React.PropTypes.string
>       >
>           {/* content */}
>       </Column>
>   ```
>   Creates a `Column` component, which contains a timeline or similar view.

##  The Component  ##

The `Column` is just a simple functional React component.

    Laboratory.Components.Columns.parts.Column = (props) ->
        彁 'div', (if props.id? then {id: props.id, className: "laboratory-column"} else {className: "laboratory-column"}),
            props.children


#  `Laboratory.Components.Columns.parts.GoLink`  #

##  Usage  ##

>   ```jsx
>       <GoLink
>           to=React.PropTypes.string.required
>           icon=React.PropTypes.string.required
>       />
>           {/* content */}
>       </GoLink>
>   ```
>   Creates a `Column` component which contains a menu of useful tasks. The accepted properties are:
>   -   **`to` [REQUIRED `string`] :**
>       Where the link is going to.
>   -   **`icon` [REQUIRED `string`] :**
>       The icon associated with the link.

##  The Component  ##

The `GoLink` component is a simple functional React component which just packages a `Link` with an icon.

    Laboratory.Components.Columns.parts.GoLink = (props) ->
        彁 ReactRouter.Link, {to: props.to, "aria-hidden": true},
            彁 Laboratory.Components.Shared.parts.Icon, {name: props.icon}
            props.children

    Laboratory.Components.Columns.parts.GoLink.propTypes =
        to: React.PropTypes.string.isRequired
        icon: React.PropTypes.string.isRequired


#  `Laboratory.Components.Columns.parts.Heading`  #

##  Usage  ##

>   ```jsx
>       <Heading
>           icon=React.PropTypes.string
>       >
>           {/* content */}
>       </Heading>
>   ```
>   Creates a `Heading` component, which is just the heading to a `Column`. The accepted properties are:
>   -   **`icon` [REQUIRED `string`] :**
>       The icon to associate with the heading.

##  The Component  ##

The `Heading` is just a simple functional React component.

    Laboratory.Components.Columns.parts.Heading = (props) ->
        彁 'h2', {className: "laboratory-heading"},
            if props.icon
                彁 Laboratory.Components.Shared.parts.Icon, {name: props.icon}
            else null
            props.children

    Laboratory.Components.Columns.parts.Heading.propTypes =
        icon: React.PropTypes.string


#  `Laboratory.Components.Columns.parts.Status`  #

##  Usage  ##

>   ```jsx
>       <Status
>           id=React.PropTypes.number.isRequired
>           url=React.PropTypes.string
>           account=React.PropTypes.object.isRequired
>           in_reply_to_id=React.PropTypes.number
>           content=React.PropTypes.string
>           created_at=React.PropTypes.string
>           reblogged=React.PropTypes.bool
>           favourited=React.PropTypes.bool
>           sensitive=React.PropTypes.bool
>           spoiler_text=React.PropTypes.string
>           visibility=React.PropTypes.string
>           media_attachments=React.PropTypes.array
>           mentions=React.PropTypes.array
>           followed=React.PropTypes.bool
>       />
>   ```
>   Creates a `Status` component, which contains a post or a notification. The accepted properties are:
>   -   **`id` [REQUIRED `number`] :**
>       The id of the status.
>   -   **`url` [OPTIONAL `string`] :**
>       A URL at which the status may be viewed.
>   -   **`account` [REQUIRED `object`] :**
>       The account which posted the status.
>   -   **`in_reply_to_id` [OPTIONAL `number`] :**
>       The id of the status this status is replying to.
>   -   **`content` [REQUIRED `string`] :**
>       The content of the status.
>   -   **`created_at` [REQUIRED `string`] :**
>       The time the status was created.
>   -   **`reblogged` [OPTIONAL `boolean`] :**
>       Whether or not the user has reblogged this status.
>   -   **`favourited` [OPTIONAL `boolean`] :**
>       Whether or not the user has favourited this status.
>   -   **`sensitive` [OPTIONAL `boolean`] :**
>       Whether or not this status contains sensitive media.
>   -   **`spoiler_text` [OPTIONAL `string`] :**
>       Spoiler text to display over the status.
>   -   **`visibility` [OPTIONAL `string`] :**
>       The visibility of the status.
>   -   **`media_attachments` [OPTIONAL `array`] :**
>       An array of media attachments.
>   -   **`mentions` [OPTIONAL `array`] :**
>       An array of mentions.
>   -   **`reblogged_by` [OPTIONAL `array`] :**
>       The account which reblogged this status.
>   -   **`favourited_by` [OPTIONAL `array`] :**
>       The account which favourited this status.
>   -   **`followed` [OPTIONAL `boolean`] :**
>       Indicates the status is a follow notification.

##  The Component  ##

The `Status` component is a fairly involved React component, which loads an `<article>` containing the status and allowing the user to interact with it.

    Laboratory.Components.Columns.parts.Status = React.createClass

        mixins: [ReactPureRenderMixin]

        propTypes:
            id: React.PropTypes.number.isRequired
            url: React.PropTypes.string.isRequired
            account: React.PropTypes.object.isRequired
            in_reply_to_id: React.PropTypes.number
            content: React.PropTypes.string.isRequired
            created_at: React.PropTypes.string.isRequired
            reblogged: React.PropTypes.bool
            favourited: React.PropTypes.bool
            sensitive: React.PropTypes.bool
            spoiler_text: React.PropTypes.string
            visibility: React.PropTypes.string
            media_attachments: React.PropTypes.array
            mentions: React.PropTypes.array
            reblogged_by: React.PropTypes.object
            favourited_by: React.PropTypes.object
            followed: React.PropTypes.bool

Our function `getListOfMentions()` gets the list of people mentioned in the post, although this is only shown if the post is a reply.
We follow the Chicago convention of using "et al." if there are more than three accounts.

        getListOfMentions: -> switch @props.mentions.length
            when 0 then []
            when 1 then [
                彁 ReactRouter.Link, {to: "/user/" + @props.mentions[0].id},
                    彁 "code", {className: "laboratory-username"}, @props.mentions[0].username
            ]
            when 2 then [
                彁 ReactRouter.Link, {to: "/user/" + @props.mentions[0].id},
                    彁 "code", {className: "laboratory-username"}, @props.mentions[0].username
                彁 ReactIntl.FormattedMessage,
                    id: "status.and"
                    message: " and "
                彁 ReactRouter.Link, {to: "/user/" + @props.mentions[1].id},
                    彁 "code", {className: "laboratory-username"}, @props.mentions[1].username
            ]
            when 3 then [
                彁 ReactRouter.Link, {to: "/user/" + @props.mentions[0].id},
                    彁 "code", {className: "laboratory-username"}, @props.mentions[0].username
                ", "
                彁 ReactRouter.Link, {to: "/user/" + @props.mentions[1].id},
                    彁 "code", {className: "laboratory-username"}, @props.mentions[1].username
                ", "
                彁 ReactIntl.FormattedMessage,
                    id: "status.and"
                    message: " and "
                彁 ReactRouter.Link, {to: "/user/" + @props.mentions[2].id},
                    彁 "code", {className: "laboratory-username"}, @props.mentions[2].username
            ]
            else [
                彁 ReactRouter.Link, {to: "/user/" + @props.mentions[0].id},
                    彁 "code", {className: "laboratory-username"}, @props.mentions[0].username
                彁 ReactIntl.FormattedMessage,
                    id: "status.etal"
                    message: " et al."
            ]

        render: ->
            if @props.followed
                彁 "article", {className: "laboratory-status"},
                    彁 Laboratory.Components.Shared.parts.IDCard,
                        account: @props.account
                    彁 ReactIntl.FormattedMessage,
                        id: "status.followedyou"
                        message: " followed you!"
            else
                彁 "article", {className: "laboratory-status" + (if @props.favourited then " laboratory-status--highlighted" else "")},
                    if @props.reblogged_by? or @props.favourited_by? or @props.in_reply_to_id? then 彁 "aside", null,
                        (switch
                            when @props.in_reply_to_id? and @props.reblogged_by? then [
                                彁 ReactRouter.Link, {to: "/user/" + @props.reblogged_by.id},
                                    彁 "code", {className: "laboratory-username"}, @props.reblogged_by.username
                                (if @props.mentions?.length then [
                                    彁 ReactIntl.FormattedMessage,
                                        id: "status.boostedthisreplyto"
                                        message: " boosted this reply to "
                                    @getListOfMentions()...
                                ]
                                else [
                                    彁 ReactIntl.FormattedMessage,
                                        id: "status.boostedthisreply"
                                        message: " boosted this reply"
                                ])...
                            ]
                            when @props.in_reply_to_id? and @props.favourited_by? then [
                                彁 ReactRouter.Link, {to: "/user/" + @props.favourited_by.id},
                                    彁 "code", {className: "laboratory-username"}, @props.favourited_by.username
                                (if @props.mentions?.length then [
                                    彁 ReactIntl.FormattedMessage,
                                        id: "status.highlightedthisreplyto"
                                        message: " highlighted this reply to "
                                    @getListOfMentions()...
                                ]
                                else [
                                    彁 ReactIntl.FormattedMessage,
                                        id: "status.highlightedthisreply"
                                        message: " highlighted this reply"
                                ])...
                            ]
                            when @props.reblogged_by? then [
                                彁 ReactRouter.Link, {to: "/user/" + @props.reblogged_by.id},
                                    彁 "code", {className: "laboratory-username"}, @props.reblogged_by.username
                                彁 ReactIntl.FormattedMessage,
                                    id: "status.boostedthispost"
                                    message: " boosted this post"
                            ]
                            when @props.favourited_by? then [
                                彁 ReactRouter.Link, {to: "/user/" + @props.favourited_by.id},
                                    彁 "code", {className: "laboratory-username"}, @props.favourited_by.username
                                彁 ReactIntl.FormattedMessage,
                                    id: "status.highlightedthispost"
                                    message: " highlighted this post"
                            ]
                            when @props.in_reply_to_id?
                                if @props.mentions?.length then [
                                    彁 ReactIntl.FormattedMessage,
                                        id: "status.inreplyto"
                                        message: "In reply to "
                                    @getListOfMentions()...
                                ]
                                else [
                                    彁 ReactIntl.FormattedMessage,
                                        id: "status.inreplytoself"
                                        message: "In reply to themselves"
                                ]
                        )...
                    else null
                    彁 "header", null,
                        彁 Laboratory.Components.Shared.parts.IDCard,
                            account: @props.account
                        彁 ReactIntl.FormattedRelative, {value: Date.parse(@props.created_at)},
                            (formattedDate) => 彁 "time", {dateTime: @props.created_at, title: @props.created_at}, formattedDate
                    彁 "div",
                        className: "laboratory-statusContent"
                        dangerouslySetInnerHTML:
                            __html: @props.content
                    彁 "footer", null,
                        彁 Laboratory.Components.Shared.parts.Button,
                            className: "laboratory-button--minimal"
                            containerClass: "laboratory-replybutton"
                            icon: "reply"
                            label: 彁 ReactIntl.FormattedMessage,
                                id: "status.reply"
                                defaultMessage: "Reply"
                        if @props.favourited
                            彁 Laboratory.Components.Shared.parts.Button,
                                className: "laboratory-button--minimal"
                                containerClass: "laboratory-unhighlightbutton"
                                icon: "eraser"
                                label: 彁 ReactIntl.FormattedMessage,
                                    id: "status.unhighlight"
                                    defaultMessage: "Unhighlight"
                        else
                            彁 Laboratory.Components.Shared.parts.Button,
                                className: "laboratory-button--minimal"
                                containerClass: "laboratory-highlightbutton"
                                icon: "pencil"
                                label: 彁 ReactIntl.FormattedMessage,
                                    id: "status.highlight"
                                    defaultMessage: "Highlight"
                        if @props.reblogged
                            彁 Laboratory.Components.Shared.parts.Button,
                                className: "laboratory-button--minimal"
                                containerClass: "laboratory-unboostbutton"
                                icon: "minus-square"
                                label: 彁 ReactIntl.FormattedMessage,
                                    id: "status.unboost"
                                    defaultMessage: "Unboost"
                        else if @props.visibility isnt "private"
                            彁 Laboratory.Components.Shared.parts.Button,
                                className: "laboratory-button--minimal"
                                containerClass: "laboratory-boostbutton"
                                icon: "plus-square"
                                label: 彁 ReactIntl.FormattedMessage,
                                    id: "status.boost"
                                    defaultMessage: "Boost"
                        else
                            彁 Laboratory.Components.Shared.parts.Button,
                                className: "laboratory-button--minimal"
                                containerClass: "laboratory-noboostbutton"
                                icon: "square-o"
                                disabled: true
                                label: 彁 ReactIntl.FormattedMessage,
                                    id: "status.noboost"
                                    defaultMessage: "Private"


#  `Laboratory.Components.Columns.productions.Empty`  #

##  Usage  ##

>   ```jsx
>       <Empty />
>   ```
>   Creates an empty `Column`.

##  The Component  ##

The `Empty` component is just a simple functional React component, which loads an empty `Column`.

    Laboratory.Components.Columns.productions.Empty = -> 彁 Laboratory.Components.Columns.parts.Column, {id: "laboratory-empty"}, 彁 Laboratory.Components.Columns.parts.Heading


#  `Laboratory.Components.Columns.productions.Go`  #

##  Usage  ##

>   ```jsx
>       <Go
>           myID=React.PropTypes.number.isRequired
>           footerLinks=React.PropTypes.object
>       />
>   ```
>   Creates a `Column` component which contains a menu of useful tasks. The accepted properties are:
>   -   **`myID` [OPTIONAL `number`] :**
>       The ID of the currently signed-in user.
>   -   **`footerLinks` [OPTIONAL `object`] :**
>       An object whose enumerable own properties provide links to display in the footer.

##  The Component  ##

The `Go` component is just a simple functional React component, which loads a `Column` with helpful links.

    Laboratory.Components.Columns.productions.Go = (props) ->
        彁 Laboratory.Components.Columns.parts.Column, {id: "laboratory-go"},
            彁 Laboratory.Components.Columns.parts.Heading, {icon: "arrow-right"},
                彁 ReactIntl.FormattedMessage,
                    id: "go.heading"
                    defaultMessage: "let's GO!"
            彁 "nav", {className: "laboratory-columnnav"},
                彁 Laboratory.Components.Columns.parts.GoLink, {to: "/user/" + props.myID, icon: "list-alt"},
                    彁 ReactIntl.FormattedMessage,
                        id: 'go.profile'
                        defaultMessage: "Profile"
                彁 Laboratory.Components.Columns.parts.GoLink, {to: "/community", icon: "users"},
                    彁 ReactIntl.FormattedMessage,
                        id: 'go.community'
                        defaultMessage: "Community"
                彁 Laboratory.Components.Columns.parts.GoLink, {to: "/global", icon: "link"},
                    彁 ReactIntl.FormattedMessage,
                        id: 'go.global'
                        defaultMessage: "Global"
            彁 "footer", {className: "laboratory-columnfooter"},
                彁 "nav", null,
                    (彁 "a", {href: value, target: "_self"}, key for key, value of (if props.footerLinks? then props.footerLinks else {}))...

    Laboratory.Components.Columns.productions.Go.propTypes =
        footerLinks: React.PropTypes.object
        myID: React.PropTypes.number.isRequired


#  `Laboratory.Components.Columns.productions.NotFound`  #

##  Usage  ##

>   ```jsx
>       <NotFound />
>   ```
>   Creates a `Column` component, which remarks that the content could not be found.

##  The Component  ##

The `NotFound` component is just a simple functional React component, which loads a `Column` and remarks that the page could not be found.

    Laboratory.Components.Columns.productions.NotFound = ->
        彁 Laboratory.Components.Columns.parts.Column, {id: "laboratory-notfound"},
            彁 Laboratory.Components.Columns.parts.Heading, {icon: "exclamation-triangle"},
                彁 ReactIntl.FormattedMessage,
                    id: 'notfound.not_found'
                    defaultMessage: "Not found"
            彁 ReactIntl.FormattedMessage,
                id: 'notfound.not_found'
                defaultMessage: "Not found"


#  `Laboratory.Components.Columns.productions.Notifications`  #

##  Usage  ##

>   ```jsx
>       <Notifications />
>   ```
>   Creates a `Notifications` component, which contains a column of notifications.

##  The Component  ##

Our `Notifications` component doesn't take any properties, as it is only used for displaying notifications.

    Laboratory.Components.Columns.productions.Notifications = React.createClass

        mixins: [ReactPureRenderMixin]

        getInitialState: ->
            items: {}
            itemOrder: []
            settings: {}

###  Loading:

When our component first loads, we should request its data.

        componentWillMount: ->
            Laboratory.Events.Notifications.Requested
                component: this

###  Unloading:

When our component unloads, we should signal that we no longer need its data.

        componentWillUnmount: ->
            Laboratory.Events.Notifications.Removed
                component: this

###  Rendering:

        render: ->
            彁 Laboratory.Components.Columns.parts.Column, {id: "laboratory-notifications"},
                彁 Laboratory.Components.Columns.parts.Heading, {icon: "star-half-o"},
                    彁 ReactIntl.FormattedMessage,
                        id: "notifications.notifications"
                        defaultMessage: "Notifications"
                彁 "div", {className: "laboratory-posts"},
                    (彁 Laboratory.Components.Columns.parts.Status, @state.items[id] for id in @state.itemOrder)...


#  `Laboratory.Components.Columns.productions.Timeline`  #

##  Usage  ##

>   ```jsx
>       <Timeline
>           name=React.PropTypes.string.isRequired
>       />
>   ```
>   Creates a `Timeline` component, which contains a timeline of statuses. The accepted properties are:
>   -   **`name` [REQUIRED `string`] :**
>       The name of the timeline.

##  The Component  ##

Our Timeline only has one property, a string specifying the `name` of the timeline.

    Laboratory.Components.Columns.productions.Timeline = React.createClass

        mixins: [ReactPureRenderMixin]

        propTypes:
            name: React.PropTypes.string.isRequired

        getInitialState: ->
            posts: {}
            postOrder: []
            settings: {}

###  Getting the heading icon:

The heading icon can be derived from `name` using the following function:

        getIcon: -> switch
            when @props.name is "home" then "home"
            when @props.name is "community" then "users"
            when @props.name is "global" then "link"
            when @props.name.substr(0, 8) is "hashtag/" then "hashtag"
            when @props.name.substr(0, 5) is "user/" then "at"
            else "question-circle"

###  Property change:

If our `name` property changes then we need to request the new data.
Essentially we remove our old request and send a new one.

        componentWillReceiveProps: (nextProps) ->
            return unless @props.name isnt nextProps.name
            Laboratory.Events.Timeline.Removed
                name: @props.name
                component: this
            Laboratory.Events.Timeline.Requested
                name: nextProps.name
                component: this

###  Loading:

When our timeline first loads, we should request its data.

        componentWillMount: ->
            Laboratory.Events.Timeline.Requested
                name: @props.name
                component: this

###  Unloading:

When our timeline unloads, we should signal that we no longer need its data.

        componentWillUnmount: ->
            Laboratory.Events.Timeline.Removed
                name: @props.name
                component: this

###  Rendering:

        render: ->
            彁 Laboratory.Components.Columns.parts.Column, null,
                彁 Laboratory.Components.Columns.parts.Heading, {icon: @getIcon()},
                    彁 ReactIntl.FormattedMessage,
                        id: "timeline." + @props.name
                        defaultMessage: @props.name.charAt(0).toLocaleUpperCase() + @props.name.slice(1)
                彁 "div", {className: "laboratory-posts"},
                    (彁 Laboratory.Components.Columns.parts.Status, @state.posts[id] for id in @state.postOrder)...


#  `Laboratory.Components.Modules.parts.Module`  #

##  Usage  ##

>   ```jsx
>       <Module
>           attributes=React.PropTypes.object
>           close=React.PropTypes.bool
>           closeTo=React.PropTypes.object
>       >
>           {/*  contents  */}
>       </Module>
>   ```
>   Creates a module overlay, rendering its contents inside. The accepted properties are:
>   -   **`attributes` [Optional `object`] :**
>       Attributes to set on the `<main>` object.
>   -   **`close` [OPTIONAL `boolean`] :**
>       Whether or not the module should be closed.
>   -   **`closeTo` [OPTIONAL `string`] :**
>       The URL to redirect the user to upon closing.

##  The Component  ##

The `Module` component is just a fairly simple React component, which loads a module as the `<main>` element on the page with a curtain behind.

    Laboratory.Components.Modules.parts.Module = React.createClass

        mixins: [ReactPureRenderMixin]

        propTypes:
            attributes: React.PropTypes.object
            close: React.PropTypes.bool
            closeTo: React.PropTypes.string

        getInitialState: ->
            shouldClose: @props.close

###  Pulling from the context:

We grab the router from the React context in order to handle page navigation.

        contextTypes:
            router: React.PropTypes.object.isRequired

###  Updating with new props:

When our component receives new props, we run our `close()` function if the `close` property is set.

        componentWillReceiveProps: (nextProps) ->
            return unless nextProps.close and not @state.shouldClose
            @close()

###  Closing:

The `close()` function sets our `shouldClose` state property and then does a redirect away from the current page.
If there is somewhere to `closeTo`, then it redirects the user there; if not, it attemps to navigate back and if that fails instead redirects home.
We do this on a `.5s` timeout to give our closing animation time to run.

        close: ->
            @setState {shouldClose: true}
            window.setTimeout (=> if @props.closeTo or @context.router.length <= 1 then @context.router.push(@props.closeTo or "/") else @context.router.goBack()), 500

###  Rendering:

The `render()` function displays our module: just a `<div>` curtain behind our `<main>` element, with children stuck inside.

        render: ->
            彁 "div", (if @state.shouldClose then {id: "laboratory-module", "data-laboratory-dismiss": ""} else {id: "laboratory-module"}),
                彁 "div", {id: "laboratory-curtain", onClick: @close}
                彁 "main", (if @props.attributes? then @props.attributes else null),
                @props.children


#  `Laboratory.Components.Modules.productions.Account`  #

##  Usage  ##

>   ```jsx
>       <Account
>           id=React.PropTypes.number.isRequired
>           myID=React.PropTypes.number.isRequired
>       />
>   ```
>   Creates a `Composer` component, which allows a user to compose a post. The accepted properties are:
>   -   **`id` [REQUIRED `number`] :**
>       The user ID for the account to display.
>   -   **`myID` [REQUIRED `number`] :**
>       The user ID for the currently logged-in user.

##  The Component  ##

Our Account only has one property, a number specifying the `id` of the timeline.

    Laboratory.Components.Modules.productions.Account = React.createClass

        mixins: [ReactPureRenderMixin]

        propTypes:
            id: React.PropTypes.number.isRequired
            myID: React.PropTypes.number.isRequired

        getInitialState: ->
            account: null
            relationship: if @props.id is @props.myID then Laboratory.Symbols.Relationships.SELF else null

###  Property change:

If our `id` property changes then we need to request the new data.
Essentially we remove our old request and send a new one.

        componentWillReceiveProps: (nextProps) ->
            return unless @props.id isnt nextProps.id
            Laboratory.Events.Account.Removed
                id: @props.id
                component: this
            Laboratory.Events.Account.Requested
                id: nextProps.id
                component: this

###  Loading:

When our account first loads, we should request its data.

        componentWillMount: ->
            Laboratory.Events.Account.Requested
                id: @props.id
                component: this

###  Unloading:

When our account unloads, we should signal that we no longer need its data.

        componentWillUnmount: ->
            Laboratory.Events.Account.Removed
                id: @props.id
                component: this

###  Rendering:

Our account state is managed by our handlers.
We can check to see if they have succeeded in retreiving our data by comparing the `id` of our properties to the `account.id` of our state.
If these aren't the same, then our request hasn't yet gone through.
However, we will only prevent rendering if our state `account` is `null`—that is, if no request has gone through.
Otherwise, we will let the old data stay until our new information is loaded.

        render: ->
            return null unless @state.account? and @state.relationship?
            彁 Laboratory.Components.Modules.parts.Module, {attributes: {id: "laboratory-account"}},
                彁 "header", {style: {backgroundImage: "url(#{@state.account.header})"}},
                    彁 "a", {src: @state.account.header, target: "_blank"}
                彁 Laboratory.Components.Shared.parts.IDCard, {account: @state.account, externalLinks: true}
                switch @state.relationship
                    when Laboratory.Symbols.Relationships.FOLLOWING, Laboratory.Symbols.Relationships.MUTUALS
                        彁 Laboratory.Components.Shared.parts.Button,
                            label: 彁 ReactIntl.FormattedMessage,
                                id: "account.unfollow"
                                defaultMessage: "Unfollow"
                            icon: "user-times"
                    when Laboratory.Symbols.Relationships.NOT_FOLLOWING, Laboratory.Symbols.Relationships.FOLLOWED_BY
                        if @state.account.locked
                            彁 Laboratory.Components.Shared.parts.Button,
                                label: 彁 ReactIntl.FormattedMessage,
                                    id: "account.requestfollow"
                                    defaultMessage: "Request Follow"
                                icon: "user-secret"
                        else
                            彁 Laboratory.Components.Shared.parts.Button,
                                label: 彁 ReactIntl.FormattedMessage,
                                    id: "account.follow"
                                    defaultMessage: "Follow"
                                icon: "user-plus"
                    when Laboratory.Symbols.Relationships.BLOCKING
                        彁 Laboratory.Components.Shared.parts.Button,
                            label: 彁 ReactIntl.FormattedMessage,
                                id: "account.blocked"
                                defaultMessage: "Blocked"
                            icon: "ban"
                            disabled: true
                    when Laboratory.Symbols.Relationships.REQUESTED, Laboratory.Symbols.Relationships.REQUESTED_MUTUALS
                        彁 Laboratory.Components.Shared.parts.Button,
                            label: 彁 ReactIntl.FormattedMessage,
                                id: "account.requestsent"
                                defaultMessage: "Request Sent"
                            icon: "share-square"
                            disabled: true
                    else null
                彁 "p",
                    dangerouslySetInnerHTML:
                        __html: @state.account.note
                彁 "footer", null,
                    彁 "table", null,
                        彁 "tbody", null,
                            彁 "tr", null,
                                彁 "td", null,
                                    彁 "b", null, @state.account.statuses_count
                                    彁 ReactIntl.FormattedMessage,
                                        id: "account.statuses"
                                        defaultMessage: "Posts"
                                彁 "td", null,
                                    彁 "b", null, @state.account.following_count
                                    彁 ReactIntl.FormattedMessage,
                                        id: "account.following"
                                        defaultMessage: "Follows"
                                彁 "td", null,
                                    彁 "b", null, @state.account.followers_count
                                    彁 ReactIntl.FormattedMessage,
                                        id: "account.followers"
                                        defaultMessage: "Followers"


#  `Laboratory.Components.Modules.productions.Composer`  #

##  Usage  ##

>   ```jsx
>       <Composer
>           maxChars=React.PropTypes.number.isRequired
>           myID=React.PropTypes.number.isRequired
>           visible=React.PropTypes.boolean
>           defaultPrivacy=React.PropTypes.string
>       />
>   ```
>   Creates a `Composer` component, which allows a user to compose a post. The accepted properties are:
>   -   **`maxChars` [REQUIRED `number`] :**
>       The maximum number of characters allowed in a post. closed.
>   -   **`myID` [REQUIRED `number`] :**
>       The account object for the currently signed-in user.
>   -   **`visible` [OPTIONAL `boolean`] :**
>       Whether or not to show the composer
>   -   **`defaultPrivacy` [OPTIONAL `string`] :**
>       Should be one of {`"public"`, `"private"`, `"unlisted"`}, and effectively defaults to `"unlisted"` if not provided.

##  The Component  ##

The `Composer` class creates our post composition module, which is a surprisingly complex task.

    Laboratory.Components.Modules.productions.Composer = React.createClass

        mixins: [ReactPureRenderMixin]

        propTypes:
            maxChars: React.PropTypes.number.isRequired
            myID: React.PropTypes.number.isRequired
            defaultPrivacy: React.PropTypes.string
            visible: React.PropTypes.bool

###  Our state:

Here you can see our initial state variables—we have quite a lot of them, as this component manages the extensive compose form.
You will note that `text` is initialized to `\n`—in order to function properly, a line break must always be the last thing it produces.

        getInitialState: ->
            account: null
            relationship: Laboratory.Symbols.Relationships.SELF
            text: "\n"
            message: ""
            charsLeft: @props.maxChars
            makePublic: @props.defaultPrivacy isnt "private"
            makeListed: @props.defaultPrivacy is "public"
            makeNSFW: false
            forceNSFW: true
            useMessage: false
            shouldClose: false

###  Pulling from the context:

We will also need `intl` from the React context in order to access the composer placeholder text.

        contextTypes:
            intl: React.PropTypes.object.isRequired

###  Loading:

When our compose module first loads, we should request the account data for the currently signed-in user.

        componentWillMount: ->
            Laboratory.Events.Account.Requested
                id: @props.myID
                component: this

###  Unloading:

When our compose module unloads, we should signal that we no longer need its data.

        componentWillUnmount: ->
            Laboratory.Events.Account.Removed
                id: @props.myID
                component: this

###  Our inputs:

We store our inputs in a instance variable, and you'll see in `render()` that we're using the `ref` attribute to get their values.

        input:
            textbox: null
            message: null
            makePublic: null
            makeListed: null
            makeNSFW: null
            useMessage: null
            post: null

###  Resets `shouldClose`:

The `shouldClose` state variable is used to register the fact that a post has been sent, and the composer module should now close.
However, we don't want this variable to *keep* signalling this fact if we then open the composer a second time.
If our `visible` property switches from `false` to `true` then we reset `shouldClose` before proceeding.

        componentWillReceiveProps: (nextProps) ->
            @setState {shouldClose: false} if not @props.visible and nextProps.visible

###  Finding out how many characters are left:

This code quickly replaces all surrogate pairs with a single underscore to achieve an accurate character count.

        getCharsLeft: -> @charsLeft = @props.maxChars - (@input.textbox.value + @input.message.value).replace(/[\uD800-\uDBFF][\uDC00-\uDFFF]/g, "_").length + 1

###  Formatting our text:

This code is used to generate the HTML content of our textbox.
We do this by creating text nodes inside a `<div>` in order to keep our text properly encapsulated and safe.
We then return the `innerHTML` of the result.

We use `<br>`s to represent line-breaks because these have the best browser support.
Again, in order for everything to function smoothly we need to ensure that the last node in this result is a `<br>` element.

        format: (text) ->
            result = document.createElement("div")
            lines = text.split("\n")
            for i in [0..lines.length-1]
                result.appendChild(document.createTextNode(lines[i])) if lines[i]
                result.appendChild(document.createElement("br")) if i isnt lines.length - 1 or lines[i]
            return result.innerHTML

###  Event handling:

This handles the events from all of our inputs *except* our textbox, essentially just setting the corresponding state value.
We also do checks regarding public/private and listed/unlisted to make sure you don't set a forbidden combination.

        handleEvent: (event) ->
            switch event.type
                when "change"
                    switch event.target
                        when @input.message then @setState
                            message: @input.message.value
                            charsLeft: @getCharsLeft()
                        when @input.makePublic then @setState
                            makePublic: @input.makePublic.checked
                            makeListed: @input.makeListed.checked and @input.makePublic.checked
                            forceListed: not @input.makePublic.checked
                        when @input.makeListed then @setState
                            makePublic: @input.makePublic.checked or @input.makeListed.checked
                            makeListed: @input.makeListed.checked
                        when @input.makeNSFW then @setState {makeNSFW: event.target.checked}
                        when @input.useMessage then @setState {useMessage: event.target.checked}

When a user clicks the "Post" button, we fire off a `Composer.Post` event with our data, wipe (almost) everything, and tell the composer to close.
Public/private and listed/unlisted settings are maintained for the next post.

                when "click"
                    if event.target is @input.post and @getCharsLeft() >= 0
                        Laboratory.Events.Composer.Post
                            text: @text
                            message: if @state.useMessage then @state.message else null
                            makePublic: @state.makePublic
                            makeListed: @state.makeListed
                            makeNSFW: @state.makeNSFW
                        @setState
                            text: ""
                            message: ""
                            charsLeft: @props.maxChars
                            useMessage: false
                            makeNSFW: false
                            forceNSFW: true
                            shouldClose: true

###  Rendering:

Our `render()` function is huge, but most of it is just buttons and their corresponding icons and labels.
Some things to note:

1.  With our inputs aside from our text box, we use `getRef` and not `ref` because it gives us the underlying `<input>`/`<button>` element.

2.  The `"aria-label"` attribute is used to hold our placeholder text.
    This isn't *always* okay, but since our placeholder also describes the textbox, in our case it is.

3.  The `onChange` attribute on our textbox doesn't link to an event listener since in this instance `onChange` doesn't actually produce an event.
    It's just a callback that gets passed the value of the textbox whenever it updates.

4.  If our `visible` property is false then we don't render anything.
    The advantage to this approach over simply not mounting the component is that lit lets us keep our state persistent—in case someone wants to go back and look at a user's account before finishing their thought, for example.

With those things in mind, here's the function:

        render: ->
            return null unless @props.visible
            彁 Laboratory.Components.Modules.parts.Module, {attributes: {id: "laboratory-composer"}, close: @state.shouldClose},
                彁 "header", null,
                    if @state.account then 彁 Laboratory.Components.Shared.parts.IDCard, {account: @state.account} else null
                彁 Laboratory.Components.Shared.parts.Textbox,
                    id: "laboratory-composertextbox"
                    "aria-label": @context.intl.messages["composer.placeholder"]
                    onChange: ((text) => @setState {text, charsLeft: @getCharsLeft()})
                    value: @format(@state.text)
                    ref: ((ref) => @input.textbox = ref)
                彁 "footer", null,
                    彁 "span", {id: "laboratory-count"}, if isNaN(@state.charsLeft) then "" else @state.charsLeft
                    彁 Laboratory.Components.Shared.parts.Button,
                        onClick: @handleEvent
                        getRef: ((ref) => @input.post = ref)
                        disabled: @state.charsLeft < 0
                        icon: "paper-plane-o"
                        label: 彁 ReactIntl.FormattedMessage,
                            id: "composer.post"
                            defaultMessage: "Post"
                彁 "aside", {id: "laboratory-composeroptions"},
                    彁 "div", {id: "laboratory-postoptions"},
                        彁 Laboratory.Components.Shared.parts.Toggle,
                            getRef: (ref) => @input.makePublic = ref
                            checked: @state.makePublic
                            onChange: @handleEvent
                            inactiveText: 彁 ReactIntl.FormattedMessage,
                                id: "composer.private"
                                defaultMessage: "Private"
                            inactiveIcon: "microphone-slash"
                            activeIcon: "rss"
                            activeText: 彁 ReactIntl.FormattedMessage,
                                id: "composer.public"
                                defaultMessage: "Public"
                        彁 Laboratory.Components.Shared.parts.Toggle,
                            getRef: (ref) => @input.makeListed = ref
                            checked: @state.makeListed
                            onChange: @handleEvent
                            inactiveText: 彁 ReactIntl.FormattedMessage,
                                id: "composer.unlisted"
                                defaultMessage: "Unlisted"
                            inactiveIcon: "envelope-o"
                            activeIcon: "newspaper-o"
                            activeText: 彁 ReactIntl.FormattedMessage,
                                id: "composer.listed"
                                defaultMessage: "Listed"
                        彁 Laboratory.Components.Shared.parts.Toggle,
                            getRef: (ref) => @input.makeNSFW = ref
                            checked: @state.makeNSFW
                            onChange: @handleEvent
                            disabled: @state.forceNSFW
                            inactiveText: 彁 ReactIntl.FormattedMessage,
                                id: "composer.safe"
                                defaultMessage: "Safe"
                            inactiveIcon: "picture-o"
                            activeIcon: "exclamation"
                            activeText: 彁 ReactIntl.FormattedMessage,
                                id: "composer.sensitive"
                                defaultMessage: "Sensitive"
                    彁 "div", {id: "laboratory-hideoptions"},
                        彁 Laboratory.Components.Shared.parts.Toggle,
                            getRef: (ref) => @input.useMessage = ref
                            checked: @state.useMessage
                            onChange: @handleEvent
                            inactiveText: ""
                            inactiveIcon: "ellipsis-h"
                            activeIcon: "question-circle-o"
                            activeText: 彁 ReactIntl.FormattedMessage,
                                id: "composer.hidewithmessage"
                                defaultMessage: "Hide behind message"
                        彁 "input",
                            type: "text"
                            placeholder: "…… ……"
                            value: @state.message
                            ref: (ref) => @input.message = ref
                            onChange: @handleEvent






#  `Laboratory.Components.Shared.parts.Button`  #

##  Usage  ##

>   ```jsx
>       <Button
>           icon=React.PropTypes.string.isRequired
>           label=React.PropTypes.element||React.PropTypes.string
>           getRef=React.PropTypes.func
>           containerClass=React.PropTypes.string
>       />
>   ```
>   Creates a `Button` component, which renders a labelled button. Some of the accepted properties are:
>   -   **`icon` [REQUIRED `string`] :**
>       The button's icon.
>   -   **`label` [OPTIONAL `element` or `string`] :**
>       The button's label, rendered beside it.
>   -   **`getRef` [OPTIONAL `function`] :**
>       A callback which receives a reference to the button's `<button>` element.
>   -   **`containerClass` [OPTIONAL `string`] :**
>       A class name to apply to the button container.

##  The Component  ##

The `Button` component is just a simple React component which displays a button inside a label.
It passes its properties to the `<button>` element it creates.

    Laboratory.Components.Shared.parts.Button = React.createClass

        mixins: [ReactPureRenderMixin]

        propTypes:
            icon: React.PropTypes.string.isRequired
            label: React.PropTypes.oneOfType [
                React.PropTypes.element
                React.PropTypes.string
            ]
            getRef: React.PropTypes.func
            containerClass: React.PropTypes.string

        getDefaultProps: ->
            label: ""

        componentDidMount: -> @props.getRef(@button) if @props.getRef

        render: ->
            output_props =
                className: "laboratory-button"
                ref: (ref) => @button = ref
            for own key, val of @props
                if key is "className" then output_props[key] += " " + val
                else if ["getRef", "ref", "label", "icon", "containerClass"].indexOf(key) is -1 then output_props[key] = val
            彁 "label", {className: "laboratory-buttoncontainer" + (if @props.containerClass then " " + @props.containerClass else "") + (if @props.disabled then " laboratory-buttoncontainer--disabled" else "")},
                @props.label
                彁 "button", output_props,
                    彁 Laboratory.Components.Shared.parts.Icon, {name: @props.icon}


#  `Laboratory.Components.Shared.parts.Icon`  #

##  Usage  ##

>   ```jsx
>       <Icon
>           name=React.PropTypes.string.isRequired
>       />
>   ```
>   Creates an `Icon` component, which provides a fontawesome icon.

##  The Component  ##

The `Icon` is just a simple functional React component.

    Laboratory.Components.Shared.parts.Icon = (props) ->
        彁 'i',
            className: "fa fa-fw fa-" + props.name
            "aria-hidden": true

    Laboratory.Components.Shared.parts.Icon.propTypes =
        name: React.PropTypes.string.isRequired


#  `Laboratory.Components.Shared.parts.IDCard`  #

##  Usage  ##

>   ```jsx
>       <IDCard
>           account=React.PropTypes.object.isRequired
>           externalLinks=React.PropTypes.bool
>       />
>   ```
>   Creates a `IDCard` component, which contains identification information for a status/post. The accepted properties are:
>   -   **`account` [REQUIRED `object`] :**
>       The account to identify.
>   -   **`externalLinks` [OPTIONAL `boolean`] :**
>       Whether to use internal or external links for the account page.

##  The Component  ##

The `IDCard` is just a simple functional React component.

    Laboratory.Components.Shared.parts.IDCard = (props) ->
        彁 'div', {className: "laboratory-idcard"},
            彁 'a', {href: props.account.avatar, target: "_blank"},
                彁 'img', {className: "laboratory-avatar", src: props.account.avatar, alt: props.account.display_name}
            彁 (if props.externalLinks then ["a", {href: props.account.url, title: props.account.display_name, target: "_blank"}] else [ReactRouter.Link, {to: "user/" + props.account.id, title: props.account.display_name}])...,
                彁 'b', {className: "laboratory-displayname"}, props.account.display_name
                彁 'code', {className: "laboratory-username"}, props.account.acct

    Laboratory.Components.Shared.parts.IDCard.propTypes =
        account: React.PropTypes.object.isRequired
        externalLinks: React.PropTypes.bool


#  `Laboratory.Components.Shared.parts.Textbox`  #

##  Usage  ##

>   ```jsx
>       <Textbox
>           getRef=React.PropTypes.func
>           onChange=React.PropTypes.func
>           placeholder=React.PropTypes.string
>           value=React.PropTypes.string
>           formatting=React.PropTypes.func
>       />
>   ```
>   Creates a `Textbox` component, which renders a toggle. Some of the accepted properties are:
>   -   **`getRef` [OPTIONAL `function`] :**
>       A callback which receives a reference to the textbox's `<root>` element.
>   -   **`onInput` [OPTIONAL `function`] :**
>       A function to call when the element receives an input.
>   -   **`aria-label` [OPTIONAL `string`] :**
>       The label for the textbox.
>   -   **`value` [OPTIONAL `string`] :**
>       The plain-text value of the textbox.
>   -   **`formatting` [OPTIONAL `func`] :**
>       Code to handle the formatting of the value before it is rendered.

##  The Component  ##

The `Textbox` component provides a semi-rich-text editor.
We store the plain-text `value` of the textbox in an instance variable and then pass it up to its parent component through `onChange`.
Similarly, the `value` property passed down contains HTML-formatted content with which to update our box.

    Laboratory.Components.Shared.parts.Textbox = React.createClass

        propTypes:
            getRef: React.PropTypes.func
            onChange: React.PropTypes.func
            className: React.PropTypes.string
            id: React.PropTypes.string
            'aria-label': React.PropTypes.string
            value: React.PropTypes.string

        getDefaultProps: ->
            value: "<br>"

        componentDidMount: ->
            @props.getRef(@input) if @props.getRef?
            @value = @getContents()

        value: "\n"

###  Event handling:

For the most part, we just call `getContents()` to update our `value` whenever something happens to our textbox.
However, if the user types "enter" then we need to ensure that the result is just a simple `<br>` line feed and not some weird `<div>`-induced magic that browsers like Chrome like to pull.

        handleEvent: (event) ->
            return unless (event.type is "input" or event.type is "blur" or event.type is "keypress") and event.target is @input
            if event.type is "keypress"
                if event.key is "Enter" or event.code is "Enter" or event.keyCode is 0x0D
                    event.preventDefault()
                    sel = window.getSelection()
                    rng = sel.getRangeAt 0
                    rng.deleteContents()
                    rng.insertNode(br = document.createElement "br")
                    rng.setEndAfter br
                    rng.collapse false
                    sel.removeAllRanges()
                    sel.addRange rng
                else return
            @value = @getContents()
            @props.onChange(@value) if @props.onChange

###  Retrieving textbox contents:

This is a little more complicated than it should be since we have to account for `<br>`s.
We walk the tree of our textbox and collect the content of every text node, but also insert a `"\n"` for each `<br>` we find.
So, this is a `<br>`-aware `Element.textContent`.

        getContents: ->
            wkr = document.createTreeWalker @input
            nde = null
            out = ""
            while wkr.nextNode()?
                nde = wkr.currentNode
                if nde.nodeType is Node.TEXT_NODE then out += nde.textContent
                else if nde.nodeType is Node.ELEMENT_NODE and nde.tagName.toUpperCase() is "BR" then out += "\n"
            out += "\n" if out.length and out.slice(-1) isnt "\n"
            return out

###  Updating the DOM only when necessary:

React will try to update the DOM every time there's a property change but we actually only need to do that if the formatted HTML we produce isn't the same as the HTML we already have.
Checking for this means that we don't have to do our complicated TreeWalkers to update the caret position nearly so often.

        shouldComponentUpdate: (nextProps, nextState) -> @props.value isnt @input.innerHTML

###  Getting the caret position:

This script gets our current caret position, so we can put it back after we insert our formatted text.

        updateCaretPos: ->

            caret = 0

We store the current selection with `sel` and the current range of the selection with `rng`.

            sel = window.getSelection()
            rng = sel.getRangeAt 0

`pre` is a range consisting of everything leading up to the end of `rng`.
First we select our entire text area, and then we set the endpoint of the range to be the endpoint of our current selection.

            pre = rng.cloneRange()
            pre.selectNodeContents @input
            pre.setEnd rng.endContainer, rng.endOffset

This next line tells us how many line breaks were in the selected range.
This is a somewhat expensive operation as it involves cloning DOM nodes, but there isn't any faster way.

            brs = pre.cloneContents().querySelectorAll("br").length

We can now find the length of the selection by adding the text content to the number of line breaks.

            @caret = pre.toString().length + brs
            pre.detach()
            return

###  Mangaing caret position before and after updating:

We use `componentWillUpdate` to grab the caret position right before updating, and `componentDidUpdate` to set it right after.

        componentWillUpdate: -> @updateCaretPos()

We're going to use a `TreeWalker` to walk the contents of our textbox until we find the correct position to stick our caret.

        componentDidUpdate: ->
            sel = window.getSelection()
            rng = document.createRange()
            wkr = document.createTreeWalker @input
            idx = 0
            nde = null
            success = false

If our caret is as long as our `value`, we can cut straight to the chase and stick our caret at the end.

            success = true if @caret >= @value.length - 1

This loop breaks when either we run out of nodes, or we find the text node that our caret belongs in.
It will also break if we wind up in-between two `<br>`s, as that is a possibility.

            loop
                break unless wkr.nextNode()?
                nde = wkr.currentNode
                if nde.nodeType is Node.TEXT_NODE
                    if idx <= @caret <= idx + nde.textContent.length
                        success = true
                        break
                    else idx += nde.textContent.length
                else if nde.nodeType is Node.ELEMENT_NODE and nde.tagName.toUpperCase() is "BR"
                    if idx++ is @caret
                        success = true
                        break
                else continue

If we were successfull, we set the end of our range to the point we found.
If we weren't, we select the textbox's entire contents, save the final `<br>`, if present.
Either way, we collapse the range to its endpoint and move the caret there.

            if success and nde
                if nde.nodeType is Node.TEXT_NODE then rng.setEnd nde, @caret - idx else rng.selectNodeContents nde
            else if @input.lastChild?.nodeName.toUpperCase is "BR" then rng.setEnd @input, @input.childNodes.length - 1
            else rng.selectNodeContents @input
            rng.collapse false
            sel.removeAllRanges()
            sel.addRange rng

###  Rendering

For all its complexity, `Textbox` is just a single `<div>`.
We set it's contents through `dangerouslySetInnerHTML`, which would normally be slower than just sticking them in directly (through `node.appendChild`) except that we're already dealing with `innerHTML`s when we call `shouldComponentUpdate()`, above.

        render: ->
            output_props =
                className: "laboratory-textbox" + (if @props.value.toLowerCase() is "<br>" or @props.value is "\n" or @props.value is "" then " laboratory-textbox--empty" else "") + (if @props.className? then " " + @props.className else "")
                contentEditable: true
                onKeyPress: @handleEvent
                onInput: @handleEvent
                onBlur: @handleEvent
                ref: (ref) => @input = ref
                dangerouslySetInnerHTML:
                    __html: @props.value
            output_props[key] = value for own key, value of @props when ["className", "contentEditable", "value", "getRef", "onChange", "onInput", "onBlur", "dangerouslySetInnerHTML", "ref"].indexOf(key) is -1
            彁 "div", output_props


#  `Laboratory.Components.Shared.parts.Toggle`  #

##  Usage  ##

>   ```jsx
>       <Toggle
>           getRef=React.PropTypes.func
>           activeText=React.PropTypes.element||React.PropTypes.string
>           inactiveText=React.PropTypes.element||React.PropTypes.string
>           activeIcon=React.PropTypes.string
>           inactiveIcon=React.PropTypes.string
>       >
>           {/*  content  */}
>       </Toggle>
>   ```
>   Creates a `Toggle` component, which renders a toggle. Some of the accepted properties are:
>   -   **`getRef` [OPTIONAL `function`] :**
>       A callback which receives a reference to the toggle's `<input>` element.
>   -   **`activeText` [OPTIONAL `element` or `string`] :**
>       The text label for the active toggle state.
>   -   **`inactiveText` [OPTIONAL `element` or `string`] :**
>       The text label for the inactive toggle state.
>   -   **`activeIcon` [OPTIONAL `element` or `string`] :**
>       The icon for the active toggle state.
>   -   **`inactiveIcon` [OPTIONAL `element` or `string`] :**
>       The icon for the inactive toggle state.

##  The Component  ##

The `Toggle` component is a minimal re-implimentation of [`react-toggle`](https://github.com/aaronshaf/react-toggle) with additional features regarding text labels.

    Laboratory.Components.Shared.parts.Toggle = React.createClass

        mixins: [ReactPureRenderMixin]

        propTypes:
            checked: React.PropTypes.bool
            disabled: React.PropTypes.bool
            onChange: React.PropTypes.func
            className: React.PropTypes.string
            name: React.PropTypes.string
            value: React.PropTypes.string
            id: React.PropTypes.string
            'aria-labelledby': React.PropTypes.string
            'aria-label': React.PropTypes.string
            getRef: React.PropTypes.func
            activeText: React.PropTypes.oneOfType [
                React.PropTypes.element
                React.PropTypes.string
            ]
            inactiveText: React.PropTypes.oneOfType [
                React.PropTypes.element
                React.PropTypes.string
            ]
            activeicon: React.PropTypes.string
            inactiveicon: React.PropTypes.string

        getDefaultProps: ->
            activeText: 彁 ReactIntl.FormattedMessage,
                id: "toggle.on"
                defaultMessage: "On"
            inactiveText: 彁 ReactIntl.FormattedMessage,
                id: "toggle.off"
                defaultMessage: "Off"
            activeIcon: "check-circle-o"
            inactiveIcon: "times"

        getInitialState: ->
            checked: !!@props.checked
            disabled: !!@props.disabled
            hasFocus: false

        componentWillReceiveProps: (nextProps) ->
            @setState {checked: !!nextProps.checked} if nextProps.checked?
            @setState {disabled: !!nextProps.disabled} if nextProps.disabled?
            return

        componentDidMount: -> @props.getRef(@input) if @props.getRef?

        handleEvent: (event) ->
            switch event.type
                when "click"
                    unless event.target is @input
                        event.preventDefault()
                        @input.focus()
                        @input.click()
                    @setState {checked: @input.checked}
                when "onFocus"
                    @setState {hasFocus: true}
                    @props.onFocus event if @props.onFocus
                when "onBlur"
                    @setState {hasFocus: false}
                    @props.onBlur event if @props.onBlur

        render: ->
            output_props = {className: "laboratory-toggle-screenreader-only", type: "checkbox", onFocus: @handleEvent, onBlur: @handleEvent, ref: (ref) => @input = ref}
            output_props[key] = value for own key, value of @props when ["className", "activeText", "activeIcon", "inactiveText", "inactiveIcon", "getRef", "ref", "type", "onFocus", "onBlur"].indexOf(key) is -1
            彁 "label", {className: "laboratory-toggle" + (if @state.checked then " laboratory-toggle--checked" else "") + (if @state.disabled then " laboratory-toggle--disabled" else "") + (if @state.hasFocus then " laboratory-toggle--focus" else "") + (if @props.className then " " + @props.className else ""), onClick: @handleEvent},
                彁 "span", {className: "laboratory-toggle-label laboratory-toggle-label-off"}, @props.inactiveText
                彁 "div", {className: "laboratory-toggle-track"},
                    彁 "div", {className: "laboratory-toggle-track-check"},
                        彁 Laboratory.Components.Shared.parts.Icon, {name: @props.activeIcon}
                    彁 "div", {className: "laboratory-toggle-track-x"},
                        彁 Laboratory.Components.Shared.parts.Icon, {name: @props.inactiveIcon}
                    彁 "div", {className: "laboratory-toggle-thumb"}
                    彁 "input", output_props
                彁 "span", {className: "laboratory-toggle-label laboratory-toggle-label-on"}, @props.activeText


#  `Laboratory.Components.Shared.productions.InstanceQuery`  #

##  Usage  ##

>   ```jsx
>       <InstanceQuery
>           locale=React.PropTypes.string.isRequired
>       />
>   ```
>   Creates a simple text input for requesting a user's home instance.

##  The Component  ##

`InstanceQuery` is just a simple React component class.

    Laboratory.Components.Shared.productions.InstanceQuery = React.createClass

        mixins: [ReactPureRenderMixin]

        propTypes:
            locale: React.PropTypes.string.isRequired

        getInitialState: ->
            value: ""

        handleEvent: (event) ->
            if event.type is "change" and event.target is @input then @setState {value: @input.value}
            else if event.type is "keypress" and event.target is @input and (event.key is "Enter" or event.code is "Enter" or event.keyCode is 0x0D) and @input.value.length and @input.validity.valid
                Laboratory.Events.Authentication.Requested {url: "https://" + @input.value, window: window.open "about:blank", "LaboratoryOAuth"}
                @setState {value: ""}
            return

        input: null

###  Rendering:

        render: ->

…And here's what we render:

            return 彁 ReactIntl.IntlProvider, {locale: @props.locale, messages: Laboratory.Locales.getL10n(@props.locale)},
                彁 "div", {id: "laboratory-instancequery"},
                    彁 ReactIntl.FormattedMessage,
                        id: "instancequery.queryinstance"
                        defaultMessage: "What's your instance?"
                    彁 "div", {id: "laboratory-instancequeryinput"},
                        彁 "code", {className: "laboratory-username"}, "username@"
                        彁 "input",
                            type: "text"
                            pattern: "[0-9A-Za-z\-\.]+(\:[0-9]{1,4})?"
                            placeholder: "example.com"
                            value: @state.value
                            ref: (ref) => @input = ref
                            onChange: @handleEvent
                            onKeyPress: @handleEvent


#  `Laboratory.Components.Shared.productions.Laboratory`  #

##  Usage  ##

>   ```jsx
>       <Laboratory
>           locale=React.PropTypes.string.isRequired
>           myID=React.PropTypes.number.isRequired
>           useBrowserHistory=React.PropTypes.bool
>           title=React.PropTypes.string
>           links=React.PropTypes.object
>           routerBase=React.PropTypes.string
>           maxChars=React.PropTypes.number
>           defaultPrivacy=React.PropTypes.string
>       />
>   ```
>   Creates a `Laboratory` component, which acts as a container for the entire frontend. The accepted properties are:
>   -   **`locale` [REQUIRED `string`] :**
>       The locale in which to render the application.
>   -   **`myID` [REQUIRED `number`] :**
>       The account ID for the currently signed-in user.
>   -   **`useBrowserHistory` [OPTIONAL `boolean`] :**
>       Whether to use browser history or hashes for the React Router.
>   -   **`title` [OPTIONAL `string`] :**
>       The title of the application.
>       Defaults to `window.location.hostname`.
>   -   **`links` [OPTIONAL `object`] :**
>       An object whose enumerable own properties give links to other areas of the site.
>   -   **`routerBase` [OPTIONAL `string`] :**
>       The base URL to use with the React router. Defaults to '/web'.
>   -   **`maxChars` [OPTIONAL `string`] :**
>       The maximum number of characters to allow in a post. Defaults to 500.
>   -   **`defaultPrivacy` [OPTIONAL `string`] :**
>       The default privacy setting. Defaults to "unlisted".

##  Imports  ##

Not really an import, but here's some convenience stuff for `react-router`.

    {Router, Route, IndexRoute, IndexRedirect} = ReactRouter

##  The Component  ##

`Laboratory` is just a React component class.
Here we define the initial properties, as above.

    Laboratory.Components.Shared.productions.Laboratory = React.createClass

        mixins: [ReactPureRenderMixin]

        propTypes:
            locale: React.PropTypes.string.isRequired
            myID: React.PropTypes.number.isRequired
            title: React.PropTypes.string
            links: React.PropTypes.object
            routerBase: React.PropTypes.string
            maxChars: React.PropTypes.number
            useBrowserHistory: React.PropTypes.bool

        getDefaultProps: ->
            title: window.location.hostname
            routerBase: "/web"
            maxChars: 500
            defaultPrivacy: "unlisted"
            useBrowserHistory: true

        getInitialState: ->
            thirdColumn: 彁 Laboratory.Components.Columns.productions.Empty
            showComposer: false

###  Third column processing:

The component displayed in the third column varies as the user navigates around the site.
The function `setThirdColumn` allows us to manage this ourselves.

        setThirdColumn: (component, props) -> @setState {thirdColumn: 彁 component, props}

        getThirdColumn: -> @state.thirdColumn

###  Loading:

`componentWillMount` tells React what to do once our engine is about to load.

        componentWillMount: ->

This starts tracking our browser history for our router:

            @history = (if @props.useBrowserHistory then ReactRouter.useRouterHistory(History.createHistory) else ReactRouter.useRouterHistory(History.createHashHistory))({basename: @props.routerBase})

####  Pre-caluclating routes.

The React router will issue a warning in the console if you try modifying its routes after the inital render.
This is a problem because every time our state changes, `render()` will re-create our arrow functions and React will interpret this as an attempted change.
By calculating our routes ahead of time, we avoid this problem.

            @routes = 彁 Route, {path: '/', component: (props) => 彁 Laboratory.Components.UI.productions.UI, {title: @props.title, maxChars: @props.maxChars, defaultPrivacy: @props.defaultPrivacy, thirdColumn: @getThirdColumn(), myID: @props.myID, showComposer: @state.showComposer}, props.children},

                #  Go:

                彁 IndexRoute, {onEnter: => @setThirdColumn Laboratory.Components.Columns.productions.Go, {footerLinks: @props.links, myID: @props.myID}}

                #  Start:

                彁 Route, {path: 'start', onEnter: => @setThirdColumn Laboratory.Components.Modules.productions.Start}

                #  Timelines:

                彁 Route, {path: 'global', onEnter: => @setThirdColumn Laboratory.Components.Columns.productions.Timeline, {name: 'global'}}
                彁 Route, {path: 'community', onEnter: => @setThirdColumn Laboratory.Components.Columns.productions.Timeline, {name: 'community'}}
                彁 Route, {path: 'hashtag/:id', onEnter: (nextState) => @setThirdColumn Laboratory.Components.Columns.productions.Timeline, {name: 'hashtag/' + nextState.params.id}}

                #  Statuses:

                彁 Route, {path: 'compose', onEnter: (=> @setState(showComposer: true)), onLeave: (=> @setState(showComposer: false))}
                彁 Route, {path: 'post/:id', component: Laboratory.Components.Modules.productions.Post}

                #  Accounts:

                彁 Route, {path: 'user/:id', component: (props) => 彁 Laboratory.Components.Modules.productions.Account, {id: Number(props.params.id), myID: @props.myID}}
                彁 Route, {path: 'user/:id/posts', onEnter: (nextState) => @setThirdColumn Laboratory.Components.Columns.productions.Timeline, {name: 'user/' + nextState.params.id}}

                #  Not found:

                彁 Route, {path: '*', onEnter: => @setThirdColumn Laboratory.Components.Columns.productions.NotFound}

            return

###  Unloading:

`componentWillUnmount` tells react what to do if our engine gets deleted.
All we really care about is closing our stream.

        componentWillUnmount: ->
            if @subscription?
                @subscription.close()
                @subscription = undefined
            return

###  Rendering:

OKAY OKAY TIME TO RENDER.
Let's go!

        render: ->

…And here's what we render:

            return 彁 ReactIntl.IntlProvider, {locale: @props.locale, messages: Laboratory.Locales.getL10n(@props.locale)},
                彁 Router, {history: @history},
                    @routes


#  `Laboratory.Components.UI.parts.Header`  #

##  Usage  ##

>   ```jsx
>       <Header
>           title=React.PropTypes.string
>       />
>   ```
>   Creates a `Header` component, which contains various user actions. The accepted properties are:
>   -   **`title` [OPTIONAL `string`] :**
>       The title of the site

##  The Component  ##

The `Header` is just a simple functional React component.

    Laboratory.Components.UI.parts.Header = (props) ->
        彁 'header', {id: "laboratory-header"},
            彁 Laboratory.Components.UI.parts.Title, null,
                props.title
            彁 ReactRouter.Link, {to: "/compose"},
                彁 Laboratory.Components.Shared.parts.Button,
                    icon: "pencil-square-o"
                    label: 彁 ReactIntl.FormattedMessage,
                        id: "composer.compose"
                        defaultMessage: "Compose"

    Laboratory.Components.UI.parts.Header.propTypes =
        title: React.PropTypes.string


#  `Laboratory.Components.UI.parts.Title`  #

##  Usage  ##

>   ```jsx
>       <Title>
>           {/* content */}
>       </Title>
>   ```
>   Creates a `Title` component, which links back to the homepage.

##  The Component  ##

The `Title` is just a simple functional React component.

    Laboratory.Components.UI.parts.Title = (props) ->
        彁 'h1', null,
            彁 ReactRouter.Link, {to: "/"},
                props.children


#  `Laboratory.Components.UI.productions.UI`  #

##  Usage  ##

>   ```jsx
>       <UI
>           title=React.PropTypes.string
>           maxchars=React.PropTypes.number.isRequired
>           myID=React.PropTypes.number.isRequired
>           defaultPrivacy=React.PropTypes.string
>           thirdColumn=React.PropTypes.element.isRequired
>           showComposer=React.PropTypes.bool
>       >
>           {/* content */}
>       </UI>
>   ```
>   Creates a `UI` component, which contains the entire rendered frontend. The accepted properties are:
>   -   **`title` [OPTIONAL `string`] :**
>       The title of the site.
>   -   **`maxChars` [REQUIRED `number`] :**
>       The maximum number of characters to allow in a post.
>   -   **`myID` [REQUIRED `number`] :**
>       The account ID for the currently signed-in user.
>   -   **`defaultPrivacy` [OPTIONAL `string`] :**
>       The default privacy setting.
>   -   **`thirdColumn` [REQUIRED `element`] :**
>       The component to display in the third column.
>   -   **`showComposer` [OPTIONAL `boolean`] :**
>       Whether or not to show the composer.

##  The Component  ##

Our UI doesn't have any properties except for its `title` and children.

    Laboratory.Components.UI.productions.UI = React.createClass

        mixins: [ReactPureRenderMixin]

        propTypes:
            title: React.PropTypes.string
            maxChars: React.PropTypes.number.isRequired
            myID: React.PropTypes.number.isRequired
            thirdColumn: React.PropTypes.element.isRequired
            showComposer: React.PropTypes.bool

###  Event handling:

Here we will handle events related to the UI:

        handleEvent: (e) ->
            switch e.type

####  Drag-and-drop.

This handles our drag-and-drop events:

                when "dragenter" then document.getElementById("laboratory-ui").setAttribute "data-laboratory-dragging", ""
                when "dragover"
                    e.preventDefault()
                    e.dataTransfer.dropEffect = "copy"
                when "dragleave" then document.getElementById("laboratory-ui").removeAttribute "data-laboratory-dragging" unless e.relatedTarget?
                when "drop"
                    e.preventDefault()
                    document.getElementById("laboratory-ui").removeAttribute "data-laboratory-dragging"
                    Laboratory.Events.Composer.Upload {file: e.dataTransfer.files.item 1} if e.dataTransfer and e.dataTransfer.files.length is 1


###  Loading:

Here we add our event listeners.

        componentWillMount: ->
            document.addEventListener "dragenter", this
            document.addEventListener "dragover", this
            document.addEventListener "dragleave", this
            document.addEventListener "drop", this

###  Unloading:

We can remove our event listeners if we're unloading our UI.

        componentWillUnmount: ->
            document.removeEventListener "dragenter", this
            document.removeEventListener "dragover", this
            document.removeEventListener "dragleave", this
            document.removeEventListener "drop", this

###  Rendering:

        render: ->
            彁 'div', {id: "laboratory-ui"},
                彁 Laboratory.Components.UI.parts.Header, {title: @props.title}
                彁 Laboratory.Components.Columns.productions.Timeline, {name: "home"}
                彁 Laboratory.Components.Columns.productions.Notifications
                @props.thirdColumn
                @props.children
                彁 Laboratory.Components.Modules.productions.Composer,
                    defaultPrivacy: @props.defaultPrivacy
                    myID: @props.myID
                    maxChars: @props.maxChars
                    visible: @props.showComposer


#  `Laboratory.Events.newBuilder`  #

The `newBuilder()` function is used to generate event constructors on-the-fly.

##  The Function  ##

Laboratory events are just `CustomEvent` instances built using special functions ("builders") created with `newBuilder()`.
All these functions do is create a new `CustomEvent` with the given properties.
`newBuilder()` takes two arguments: `type` gives the name of the event, and `data` is an object listing the valid properties for the event alongside their default values.
We use `Object.defineProperty` because this shouldn't be enumerable.

    Object.defineProperty Laboratory.Events, "newBuilder",
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

            current = (props) ->
                detail = {}
                for name, initial of data
                    Object.defineProperty detail, name,
                        value: if props? and props[name]? and name isnt '_builder' then props[name] else initial
                        enumerable: name isnt '_builder'
                document.dispatchEvent new CustomEvent type, {detail: detail}
                return

            current.type = type
            Object.freeze current

            Object.defineProperty data, "_builder",
                value: current
                enumerable: true

            return current


#  `Laboratory.Events.Account`  #

##  Usage  ##

>   ```javascript
>       //  Fires when an account view is requested:
>       Account.Requested({id: …, component: …})
>       //  Fires when an account's information is received:
>       Account.Received({data: …})
>       //  Fires when an account's relationship is received:
>       Account.RelationshipsReceived({data: …})
>       //  Fires when an account view is removed:
>       Account.Removed({id: …, component: …})
>   ```
>   - **`id` :** The id of the account.
>   - **`component` :** A timeline component.
>   - **`data` :** The JSON account/relationship data.

##  Object Initialization  ##

    Laboratory.Events.Account = {}

##  Events  ##

###  `Account.Requested`:

The `Account.Requested` event has two properties: the `id` of the requested account and the `component` that it will be rendered in.

    Laboratory.Events.Account.Requested = Laboratory.Events.newBuilder 'LaboratoryAccountRequested',
        id: null,
        component: null

###  `Account.Received`:

The `Account.Received` event has one property: the `data` of the response.

    Laboratory.Events.Account.Received = Laboratory.Events.newBuilder 'LaboratoryAccountReceived',
        data: null

###  `Account.RelationshipsReceived`:

The `Account.RelationshipsReceived` event has one property: the `data` of the response.

    Laboratory.Events.Account.RelationshipsReceived = Laboratory.Events.newBuilder 'LaboratoryAccountRelationshipsReceived',
        data: null

###  `Account.Removed`:

The `Account.Removed` event has two properties: the `id` of the account and the `component` that was removed.

    Laboratory.Events.Account.Removed = Laboratory.Events.newBuilder 'LaboratoryAccountRemoved',
        id: null,
        component: null

##  Object Freezing  ##

    Object.freeze Laboratory.Events.Account


#  `Laboratory.Events.Authentication`  #

##  Usage  ##

>   ```javascript
>       //  Fires when client authentication is first requested:
>       Authentication.ClientRequested({url: …})
>       //  Fires when client authentication is received:
>       Authentication.ClientReceived({data: …, params: …})
>       //  Fires when authentication is first requested:
>       Authentication.Requested({url: …, window: …, clientID: …, clientSecret: …})
>       //  Fires when a user grants an authorization request:
>       Authentication.Granted({window: …, code: …})
>       //  Fires when an authentication request goes through:
>       Authentication.Received({data: …})
>       //  Fires when an authentication request goes through:
>       Authentication.Verified({data: …})
>   ```
>   - **`url` :** The url of the server to authenticate with.
>   - **`clientID` :** The url of the server to authenticate with.
>   - **`clientSecret` :** The url of the server to authenticate with.
>   - **`window` :** The window which was granted the authentication.
>   - **`code` :** An authorization code.
>   - **`data` :** The data from the request.
>   - **`params` :** Params passed along with the request.

##  Object Initialization  ##

    Laboratory.Events.Authentication = {}

##  Events  ##

###  `Authentication.ClientRequested`:

The `Authentication.ClientRequested` event has one property: the `url` of the server to authenticate with.

    Laboratory.Events.Authentication.ClientRequested = Laboratory.Events.newBuilder 'LaboratoryAuthenticationClientRequested',
        url: "/"

###  `Authentication.ClientReceived`:

The `Authentication.ClientReceived` event has two properties: the `data` returned by the server, and the `params` which were passed with the request.

    Laboratory.Events.Authentication.ClientReceived = Laboratory.Events.newBuilder 'LaboratoryAuthenticationClientReceived',
        data: null
        params: null

###  `Authentication.Requested`:

The `Authentication.Requested` event has one property: the `url` of the server to authenticate with.

    Laboratory.Events.Authentication.Requested = Laboratory.Events.newBuilder 'LaboratoryAuthenticationRequested',
        url: "/"
        window: null
        clientID: null
        clientSecret: null

###  `Authentication.Granted`:

The `Authentication.Granted` event has three properties: the `data` returned by the server, the `code` to use for authentication, and the `method` for getting our access token.

    Laboratory.Events.Authentication.Granted = Laboratory.Events.newBuilder 'LaboratoryAuthenticationGranted',
        window: null
        code: null

###  `Authentication.Received`:

The `Authentication.Received` event has two properties: the `data` returned by the server, and the `params` which were passed with the request.

    Laboratory.Events.Authentication.Received = Laboratory.Events.newBuilder 'LaboratoryAuthenticationReceived',
        data: null

###  `Authentication.Verified`:

The `Authentication.Verified` event has one property: the `data` of the server's response.

    Laboratory.Events.Authentication.Verified = Laboratory.Events.newBuilder 'LaboratoryAuthenticationVerified',
        data: null

##  Object Freezing  ##

    Object.freeze Laboratory.Events.Authentication


#  `Laboratory.Events.Composer`  #

##  Usage  ##

>   ```javascript
>       //  Fires when the composer window should be displayed.
>       Composer.Request()
>       //  Fires when a media attachment is added.
>       Composer.Upload({file: …})
>       //  Fires when a status should be sent.
>       Composer.Post({text: …, message: …, makePublic: …, makeListed: …, makeNSFW: …})
>   ```

##  Object Initialization  ##

    Laboratory.Events.Composer = {}

##  Events  ##

###  `Composer.Request`:

The `Composer.Request` event doesn't have any properties.

    Laboratory.Events.Composer.Request = Laboratory.Events.newBuilder "LaboratoryComposerRequest"

###  `Composer.Upload`:

The `Composer.Upload` event has one property: the `file` to upload.

    Laboratory.Events.Composer.Upload = Laboratory.Events.newBuilder 'LaboratoryComposerUpload',
        file: null

###  `Composer.Post`:

The `Composer.Post` event has several properties: the `text` of the status to post; its associated `message`, if any; and whether to `makePublic`, `makeListed`, or `makeNSFW`.

    Laboratory.Events.Composer.Post = Laboratory.Events.newBuilder "LaboratoryComposerPost",
        text: ""
        message: null
        makePublic: false
        makeListed: false
        makeNSFW: true

##  Object Freezing  ##

    Object.freeze Laboratory.Events.Composer


#  `Laboratory.Events.Notifications`  #

##  Usage  ##

>   ```javascript
>       //  Fires when a new timeline is requested:
>       Notifications.Requested({component: …, before: …, since: …})
>       //  Fires when a timeline is received:
>       Notifications.Received({data: …, prev: …, next: …})
>       //  Fires when a feed of notifications is removed:
>       Notifications.Removed({component: …})
>       //  Fires when a new Notifications is created:
>       Notifications.ItemLoaded({payload: …})
>   ```
>   - **`payload` :** The content of the Notifications.
>   - **`component` :** A Notifications feed.
>   - **`before` :** Only show posts younger than this ID.
>   - **`since` :** Only show posts older than this ID.
>   - **`data` :** The JSON timeline data.
>   - **`prev` :** The url for the previous page of the request.
>   - **`next` :** The url for the next page of the request.

##  Object Initialization  ##

    Laboratory.Events.Notifications = {}

##  Events  ##

###  `Notifications.Requested`:

The `Notifications.Requested` event has one property: the `component` that it will be rendered in.

    Laboratory.Events.Notifications.Requested = Laboratory.Events.newBuilder 'LaboratoryNotificationsRequested',
        component: null

###  `Notifications.Received`:

The `Notifications.Received` event has one property: the `component` that it will be rendered in.

    Laboratory.Events.Notifications.Received = Laboratory.Events.newBuilder 'LaboratoryNotificationsReceived',
        data: null
        prev: null
        next: null

###  `Notifications.Removed`:

The `Notifications.Removed` event has one property: the `component` that was removed.

    Laboratory.Events.Notifications.Removed = Laboratory.Events.newBuilder 'LaboratoryNotificationsRemoved',
        component: null

###  `Notifications.ItemLoaded`:

The `Notifications.ItemLoaded` event has one property: the `payload` it was issued with.

    Laboratory.Events.Notifications.ItemLoaded = Laboratory.Events.newBuilder 'LaboratoryNotificationsItemLoaded',
        payload: null

##  Object Freezing  ##

    Object.freeze Laboratory.Events.Notifications


#  `Laboratory.Events.Stream`  #

##  Usage  ##

>   ```javascript
>       //  Fires when a WebSocket stream is opened:
>       Stream.Open({stream: …})
>       //  Fires when a WebSocket stream is closed:
>       Stream.Close({stream: …, code: …})
>       //  Fires when a WebSocket stream receives a message:
>       Stream.Message({stream: …, data: …})
>       //  Fires when a WebSocket stream receives an error:
>       Stream.Error({stream: …})
>   ```
>   - **`stream` :** A string identifying the stream which triggered the event.
>   - **`code` :** A numberic code issued when the stream was closed.
>   - **`data` :** The data contained in the message.

##  Object Initialization  ##

    Laboratory.Events.Stream = {}

##  Events  ##

###  `Stream.Open`:

The `Stream.Open` event has a single property: the `stream` it was fired from.

    Laboratory.Events.Stream.Open = Laboratory.Events.newBuilder 'LaboratoryStreamOpen',
        stream: null

###  `Stream.Close`:

The `Stream.Close` event has two properties: the `stream` it was fired from, and the `code` issued when closing.

    Laboratory.Events.Stream.Close = Laboratory.Events.newBuilder 'LaboratoryStreamClose',
        stream: null
        code: 1000

###  `Stream.Message`:

The `Stream.Message` event has two properties: the `stream` it was fired from, and the message's `data`.

    Laboratory.Events.Stream.Message = Laboratory.Events.newBuilder 'LaboratoryStreamMessage',
        stream: null
        data: null

###  `Stream.Error`:

The `Stream.Error` event has a single property: the `stream` it was fired from.

    Laboratory.Events.Stream.Error = Laboratory.Events.newBuilder 'LaboratoryStreamError',
        stream: null

##  Object Freezing  ##

    Object.freeze Laboratory.Events.Stream


#  `Laboratory.Events.Timeline`  #

##  Usage  ##

>   ```javascript
>       //  Fires when a new timeline is requested:
>       Timeline.Requested({name: …, component: …, before: …, since: …})
>       //  Fires when a timeline is received:
>       Timeline.Received({data: …, prev: …, next: …, params: …})
>       //  Fires when a timeline is removed:
>       Timeline.Removed({name: …, component: …})
>       //  Fires when a status is added to the stream:
>       Timeline.StatusLoaded({stream: …, payload: …})
>       //  Fires when a status is deleted from the stream:
>       Timeline.StatusDeleted({stream: …, payload: …})
>   ```
>   - **`stream` :** A string identifying the stream which triggered the event.
>   - **`payload` :** The payload associated with the event.
>   - **`name` :** The name of the timeline.
>   - **`component` :** A timeline component.
>   - **`before` :** Only show posts younger than this ID.
>   - **`since` :** Only show posts older than this ID.
>   - **`data` :** The JSON timeline data.
>   - **`prev` :** The url for the previous page of the request.
>   - **`next` :** The url for the next page of the request.
>   - **`params` :** Parameters passed through the request.

##  Object Initialization  ##

    Laboratory.Events.Timeline = {}

##  Events  ##

###  `Timeline.Requested`:

The `Timeline.Requested` event has two properties: the `name` of the requested timeline and the `component` that it will be rendered in.

    Laboratory.Events.Timeline.Requested = Laboratory.Events.newBuilder 'LaboratoryTimelineRequested',
        name: null
        component: null
        before: null
        since: null

###  `Timeline.Received`:

The `Timeline.Received` event has one property: the `data` of the response.

    Laboratory.Events.Timeline.Received = Laboratory.Events.newBuilder 'LaboratoryTimelineReceived',
        data: null
        prev: null
        next: null
        params: null

###  `Timeline.Removed`:

The `Timeline.Removed` event has two properties: the `name` of the timeline and the `component` that was removed.

    Laboratory.Events.Timeline.Removed = Laboratory.Events.newBuilder 'LaboratoryTimelineRemoved',
        name: null
        component: null

###  `Timeline.StatusLoaded`:

The `Timeline.StatusLoaded` event has two properties: the `stream` it was fired from, and the `payload` it was issued with.

    Laboratory.Events.Timeline.StatusLoaded = Laboratory.Events.newBuilder 'LaboratoryTimelineStatusLoaded',
        stream: null
        payload: null

###  `Timeline.StatusDeleted`:

The `Timeline.StatusDeleted` event has two properties: the `stream` it was fired from, and the `payload` it was issued with.

    Laboratory.Events.Timeline.StatusDeleted = Laboratory.Events.newBuilder 'LaboratoryTimelineStatusDeleted',
        stream: null
        payload: null

##  Object Freezing  ##

    Object.freeze Laboratory.Events.Timeline


#  `Laboratory.Functions.createStream`

This module is used to open a WebSocket stream with the Ardipithecus/Mastodon API.

##  Getting the URL  ##

The function `createWebSocketURL(url)` uses an `<a>` element to generate a URL object from a given url, while changing the protocol to `ws` or `wss` depending on the original URL's security levels.
It returns the full `ws(s)://` url.

    createWebSocketURL = (url) ->
        a = document.createElement('a')
        a.href     = url
        a.href     = a.href
        a.protocol = if a.protocol is 'https' or a.protocol is 'wss' then 'wss' else 'ws'
        return a.href

##  Creating the Stream ##

The `createStream()` function takes an `accessToken` and a `stream` and uses these to generate a new `WebSocket`, which it returns.

Note `STREAMING_API_BASE_URL` is set on the `Window` object during configuration (see `/app/views/home/index.html.haml` in the Mastodon source).

    Laboratory.Functions.createStream = (accessToken, stream) ->
        ws = new WebSocket createWebSocketURL "#{STREAMING_API_BASE_URL}/api/v1/streaming/#{stream}?access_token=#{accessToken}"
        ws.addEventListener(
            "open",
            (e) -> Laboratory.Events.Stream.Open
                stream: stream
        )
        ws.addEventListener(
            "close",
            (e) -> Laboratory.Events.Stream.Close
                stream: stream
                code: e.code
        )
        ws.addEventListener(
            "message",
            (e) -> Laboratory.Events.Stream.Message
                stream: stream
                data: JSON.parse e.data
        )
        ws.addEventListener(
            "error",
            (e) -> Laboratory.Events.Stream.Error
                stream: stream
        )
        return ws


#  `Laboratory.Functions.requestFromAPI`

This module is used to request information from the Mastodon API.
It sends a request to `location` using the provided `accessToken`, and when it finishes it calls the function provided by `onComplete` with an object containing the request's response as its `data`.

    Laboratory.Functions.requestFromAPI = (location, accessToken, onComplete, params) ->

##  Creating the Request  ##

This is fairly simple; we just create an XMLHttpRequest.
You can see we set the `Authorization` header using our access token.

        request = new XMLHttpRequest()
        request.open "GET", location
        request.setRequestHeader "Authorization", "Bearer " + accessToken if accessToken

###  The callback:

This is the function that is called once the request finishes loading.
We define it inside our `requestFromAPI()` function so that it has access to our `request` and `onComplete` variables.
We also pass through any provided `params`.

        callback = ->
            prevMatches = request.getResponseHeader("Link")?.match /<\s*([^,]*)\s*>\s*;[^,]*[;\s]rel="?prev(?:ious)?"?/
            nextMatches = request.getResponseHeader("Link")?.match /<\s*([^,]*)\s*>\s*;[^,]*[;\s]rel="?next"?/
            onComplete
                params: params
                prev: if prevMatches? then prevMatches[1] else null
                next: if nextMatches? then nextMatches[1] else null
                data: JSON.parse request.responseText
            request.removeEventListener "load", callback, false

We can now add our event listener and send the request.

        request.addEventListener "load", callback, false
        request.send()

        return


#  `Laboratory.Functions.sendToAPI`

This module is used to send information to the Mastodon API.
It sends its `contents` to `location` using the provided `accessToken`, and when it finishes it calls the function provided by `onComplete` with an object containing the request's response as its `data`.

    Laboratory.Functions.sendToAPI = (contents, location, accessToken, onComplete, params) ->

##  Creating the Request  ##

This is fairly simple; we just create an XMLHttpRequest.
You can see we set the `Authorization` header using our access token.

        request = new XMLHttpRequest()
        request.open "POST", location
        request.setRequestHeader "Content-type", "application/x-www-form-urlencoded"
        request.setRequestHeader "Authorization", "Bearer " + accessToken if accessToken

###  The callback:

This is the function that is called once the request finishes loading.
We define it inside our `requestFromAPI()` function so that it has access to our `request` and `onComplete` variables.
We also pass through any provided `params`.

        callback = ->
            return unless request.readyState is XMLHttpRequest.DONE and request.status is 200
            onComplete
                params: params
                data: JSON.parse request.responseText
            request.removeEventListener "readystatechange", callback, false

We can now add our event listener and send the request.

        request.addEventListener "readystatechange", callback, false
        request.send(contents)

        return


#  `Laboratory.Functions.sendToAPI`

This module is used to send information to the Mastodon API.
It sends its `contents` to `location` using the provided `accessToken`, and when it finishes it calls the function provided by `onComplete` with an object containing the request's response as its `data`.

    Laboratory.Functions.sendToAPI = (contents, location, accessToken, onComplete, params) ->

##  Creating the Request  ##

This is fairly simple; we just create an XMLHttpRequest.
You can see we set the `Authorization` header using our access token.

        request = new XMLHttpRequest()
        request.open "POST", location
        request.setRequestHeader "Content-type", "application/x-www-form-urlencoded"
        request.setRequestHeader "Authorization", "Bearer " + accessToken if accessToken

###  The callback:

This is the function that is called once the request finishes loading.
We define it inside our `requestFromAPI()` function so that it has access to our `request` and `onComplete` variables.
We also pass through any provided `params`.

        callback = ->
            return unless request.readyState is XMLHttpRequest.DONE and request.status is 200
            onComplete
                params: params
                data: JSON.parse request.responseText
            request.removeEventListener "readystatechange", callback, false

We can now add our event listener and send the request.

        request.addEventListener "readystatechange", callback, false
        request.send(contents)

        return


#  `Laboratory.Handlers.Account`  #

##  Coverage  ##

**The following events from `Account` have handlers:**

- `Account.Requested`
- `Account.Received`
- `Account.Removed`

##  Object Initialization  ##

    Laboratory.Handlers.Account = {}

##  Handlers  ##

###  `Account.Requested`

We have two things that we need to do when an account is requested: query the server for its information, and hold onto the component requesting access.
We hold those here.

    Laboratory.Handlers.Account.Requested = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Account.Requested.type

We'll let `attributes` store the various attributes expected from the JSON response, so we can easily iterate over them.

        attributes = [
            "id"
            "username"
            "acct"
            "display_name"
            "note"
            "url"
            "avatar"
            "header"
            "locked"
            "followers_count"
            "following_count"
            "statuses_count"
        ]

The `interfaces.accounts` object will store our account components, organized by the account ids.
We need to create an array to store our component in if one doesn't already exist:

        Object.defineProperty @interfaces.accounts, event.detail.id, {value: [], enumerable: true} unless @interfaces.accounts[event.detail.id] instanceof Array

We can now add our component.

        @interfaces.accounts[event.detail.id].push event.detail.component if event.detail.component?

If we already have information on this account loaded into our store, we can pre-fill the component with that information.
We pass our information as a frozen shallow clone of `accounts[id]` in our store.

        if @accounts[event.detail.id]
            stateData = {}
            stateData[attribute] = @accounts[event.detail.id][attribute] for attribute in attributes
            event.detail.component.setState {account: Object.freeze stateData}

Next, we send the request.
Upon completion, it should trigger an `Account.Received` event so that we can handle the data.

        Laboratory.Functions.requestFromAPI @auth.api + "/accounts/" + event.detail.id, @auth.accessToken, Laboratory.Events.Account.Received

We also send a request asking for the user's relationship to the account, so that we know whether we should display "Follow", "Unfollow", or "Block".

        Laboratory.Functions.requestFromAPI @auth.api + "/accounts/relationships?id=" + event.detail.id, @auth.accessToken, Laboratory.Events.Account.RelationshipsReceived

        return

    Laboratory.Handlers.Account.Requested.type = Laboratory.Events.Account.Requested.type
    Object.freeze Laboratory.Handlers.Account.Requested

###  `Account.Received`

When an account's data is received, we need to update its information both inside our store, and in any components which might also be using it.

    Laboratory.Handlers.Account.Received = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Account.Received.type

We'll let `attributes` store the various attributes expected from the JSON response, so we can easily iterate over them.

        attributes = [
            "id"
            "username"
            "acct"
            "display_name"
            "note"
            "url"
            "avatar"
            "header"
            "locked"
            "followers_count"
            "following_count"
            "statuses_count"
        ]

The account `data` lives in `event.detail.data`, and the copy that we'll pass to our components we'll store in `stateData`.
There are two possible cases:
We already have the account loaded, or we don't.
If the account is already loaded, then we need to update its data; if it isn't, then we need to create it.

        data = event.detail.data
        return unless data instanceof Object
        stateData = {}

When updating previous data, we should keep track if any of it has changed.
If not, then we don't need to update our related components.
As we're checking this, let's start copying information into `stateData` just in case.

        if @accounts[data.id]
            hasChanged = false
            for attribute in attributes
                stateData[attribute] = data[attribute]
                if @accounts[data.id][attribute] isnt data[attribute]
                    @accounts[data.id][attribute] = data[attribute]
                    hasChanged = true

Of course, if we're creating the data fresh, it obviously has changed.
We use `Object.defineProperty` and `Object.seal` to keep our data safe.

        else
            Object.defineProperty @accounts, data.id,
                value: Object.seal do (data, stateData, attributes) ->
                    newData = {}
                    stateData[attribute] = newData[attribute] = data[attribute] for attribute in attributes
                    return newData
                enumerable: true
            hasChanged = true

If our values changed, we should iterate over our components and feed them the new account data.

        if hasChanged and (@interfaces.accounts[data.id] instanceof Array)
            component.setState {account: Object.freeze stateData} for component in @interfaces.accounts[data.id]

        return

    Laboratory.Handlers.Account.Received.type = Laboratory.Events.Account.Received.type
    Object.freeze Laboratory.Handlers.Account.Received

##  `Account.RelationshipsReceived`  ##

When an account's relationships are received, we need to update our related components to reflect this.
We don't keep track of relationships in our store since it is rare we need to access more than one of them at a given time.

    Laboratory.Handlers.Account.RelationshipsReceived = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Account.RelationshipsReceived.type

        return unless event.detail.data instanceof Array

        for relationship in event.detail.data
            continue unless @interfaces.accounts[relationship.id] instanceof Array
            for account in @interfaces.accounts[relationship.id]
                account.setState
                    relationship: switch
                        when relationship.id is @auth.me then Laboratory.Symbols.Relationships.SELF
                        when relationship.blocking then Laboratory.Symbols.Relationships.BLOCKING
                        when relationship.following and relationship.followed_by then Laboratory.Symbols.Relationships.MUTUALS
                        when relationship.following then Laboratory.Symbols.Relationships.FOLLOWING
                        when relationship.followed_by then Laboratory.Symbols.Relationships.FOLLOWED_BY
                        when relationship.requested and relationship.followed_by then Laboratory.Symbols.Relationships.REQUESTED_MUTUALS
                        when relationship.requested then Laboratory.Symbols.Relationships.REQUESTED
                        else Laboratory.Symbols.Relationships.NOT_FOLLOWING

        return

    Laboratory.Handlers.Account.RelationshipsReceived.type = Laboratory.Events.Account.RelationshipsReceived.type
    Object.freeze Laboratory.Handlers.Account.RelationshipsReceived

##  `Account.Removed`  ##

`Account.Removed` has a much simpler handler than our previous two:
We just look for the provided component, and remove it from our account interface.

    Laboratory.Handlers.Account.Removed = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Account.Removed.type

Of course, if we don't have any components assigned to the provided id, we can't do anything.

        return unless @interfaces.accounts[event.detail.id] instanceof Array

This iterates over our components until we find the right one, and removes it from the array.

        index = 0;
        index++ until @interfaces.accounts[event.detail.id][index] = event.detail.component or index >= @interfaces.accounts[event.detail.id].length
        @interfaces.accounts[event.detail.id].splice index, 1

…And we're done!

        return

    Laboratory.Handlers.Account.Removed.type = Laboratory.Events.Account.Removed.type
    Object.freeze Laboratory.Handlers.Account.Removed

##  Object Freezing  ##

    Object.freeze Laboratory.Handlers.Account


#  `Laboratory.Handlers.Authentication`  #

##  Coverage  ##

**The following events from `Authentication` have handlers:**

- `Authentication.ClientRequested`
- `Authentication.ClientReceived`
- `Authentication.Requested`
- `Authentication.Granted`
- `Authentication.Received`
- `Authentication.Verified`

##  Object Initialization  ##

    Laboratory.Handlers.Authentication = {}

##  Handlers  ##

###  `Authentication.ClientRequested`:

The `Authentication.ClientRequested` handler requests a new client id and secret from the API, and fires `Authentication.ClientReceived` when it is granted.

    Laboratory.Handlers.Authentication.ClientRequested = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Authentication.ClientRequested.type

First, we normalize our URL.
We also get our redirect URI at this point.

        a = document.createElement("a")
        a.href = event.detail.url
        url = a.origin
        a.href = @config.baseName + "/"
        authURL = a.href

Now we can send our request.

        Laboratory.Functions.sendToAPI(
            "client_name=Laboratory+Frontend&redirect_uris=" + encodeURIComponent(authURL) + "&scopes=read+write+follow"
            url + "/api/v1/apps"
            null
            Laboratory.Events.Authentication.ClientReceived
            {url, authURL}
        )

        return

    Laboratory.Handlers.Authentication.ClientRequested.type = Laboratory.Events.Authentication.ClientRequested.type
    Object.freeze Laboratory.Handlers.Authentication.ClientRequested

###  `Authentication.ClientReceived`:

The `Authentication.ClientReceived` handler stores a received client id and secret from the API in `localStorage`.
It then calls `Authentication.Requested` to attempt to authenticate the user.

    Laboratory.Handlers.Authentication.ClientReceived = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Authentication.ClientReceived.type

        localStorage.setItem event.detail.params.url, event.detail.params.authURL + " " + event.detail.data.client_id + " " + event.detail.data.client_secret

        Laboratory.Events.Authentication.Requested
            url: event.detail.params.url
            clientID: event.detail.data.client_id
            clientSecret: event.detail.data.client_secret

        return

    Laboratory.Handlers.Authentication.ClientReceived.type = Laboratory.Events.Authentication.ClientReceived.type
    Object.freeze Laboratory.Handlers.Authentication.ClientReceived

###  `Authentication.Requested`:

The `Authentication.Requested` handler requests authorization from the user through the API, and fires `Authentication.Granted` when it is granted.

    Laboratory.Handlers.Authentication.Requested = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Authentication.Requested.type

First, we normalize our URL.
We also get our redirect URI at this point.

        a = document.createElement "a"
        a.href = event.detail.url
        url = a.origin
        a.href = @config.baseName + "/"
        authURL = a.href


If we don't have a client ID or secret we need to get one.

        if event.detail.clientID? and event.detail.clientSecret? then [redirect, clientID, clientSecret] = [authURL, event.detail.clientID, event.detail.clientSecret]
        else if localStorage.getItem(url) then [redirect, clientID, clientSecret] = localStorage.getItem(url).split " ", 3

        unless redirect is authURL and clientID? and clientSecret?
            Laboratory.Events.Authentication.ClientRequested {url}
            return

Otherwise, we can load our authentication data into our state for later use.

        @auth.origin = url
        @auth.api = @auth.origin + "/api/v1"
        @auth.clientID = clientID
        @auth.clientSecret = clientSecret
        @auth.redirect = authURL

We now open a popup for authorization.
It will call `Authentication.Granted` with the granted code if it succeeds.

        window.open url + "/oauth/authorize?client_id=" + clientID + "&response_type=code&redirect_uri=" + encodeURIComponent(authURL), "LaboratoryOAuth"

        return

    Laboratory.Handlers.Authentication.Requested.type = Laboratory.Events.Authentication.Requested.type
    Object.freeze Laboratory.Handlers.Authentication.Requested

###  `Authentication.Granted`:

The `Authentication.Granted` handler is called when the user grants access to the Laboratory app from a popup.

    Laboratory.Handlers.Authentication.Granted = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Authentication.Granted.type

If our authentication data hasn't been loaded into the state, then this event must have been called erroneously.

        return unless @auth.origin? and @auth.clientID and @auth.clientSecret and @auth.redirect

We can now close our popup.

        event.detail.window.close() if event.detail.window?

Finally, we can request our authorization token from the server using the code we were just given.

        Laboratory.Functions.sendToAPI(
            "client_id=" + @auth.clientID + "&client_secret=" + @auth.clientSecret + "&redirect_uri=" + encodeURIComponent(@auth.redirect) + "&grant_type=authorization_code&code=" + event.detail.code
            @auth.origin + "/oauth/token"
            null
            Laboratory.Events.Authentication.Received
        )

        return

    Laboratory.Handlers.Authentication.Granted.type = Laboratory.Events.Authentication.Granted.type
    Object.freeze Laboratory.Handlers.Authentication.Granted

###  `Authentication.Received`:

The `Authentication.Received` handler is called when the user grants access to the Laboratory app from a popup.

    Laboratory.Handlers.Authentication.Received = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Authentication.Received.type

If our authentication failed, then we *sigh* have to start all over again from scratch.

        unless event.detail.data.access_token
            localStorage.setItem @auth.origin, ""
            Laboratory.Events.Authentication.Requested
                url: @auth.origin
                clientID: @auth.clientID
                clientSecret: @auth.clientSecret
            return

We can now load our tokens:

        @auth.accessToken = event.detail.data.access_token
        localStorage.setItem @auth.origin, @auth.redirect + " " + @auth.clientID + " " + @auth.clientSecret

*Finally*, we try to grab the account of the newly-signed-in user, using `Authentication.Verified` as our callback.

        Laboratory.Functions.requestFromAPI(
            @auth.api + "/accounts/verify_credentials"
            @auth.accessToken
            Laboratory.Events.Authentication.Verified
        )

        return

    Laboratory.Handlers.Authentication.Received.type = Laboratory.Events.Authentication.Received.type
    Object.freeze Laboratory.Handlers.Authentication.Received

###  `Authentication.Verified`:

The `Authentication.Verified` handler is called when the credentials of a user have been verified.
Its `data` contains the account information for the just-signed-in user.
Once this data has been received, we can fire up our UI.

    Laboratory.Handlers.Authentication.Verified = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Authentication.Verified.type

        @auth.me = event.detail.data.id

        Laboratory.Events.Account.Received {data: event.detail.data}

Now that our account has been received, we can render our React components.
We don't give our React components direct access to our store so there's quite a few properties we need to set instead.

        frontend = 彁 Laboratory.Components.Shared.productions.Laboratory,
            locale: @config.locale
            myID: @auth.me
            useBrowserHistory: @config.useBrowserHistory
            title: @site.title || @auth.origin
            links: @site.links
            routerBase: @config.baseName
            maxChars: @site.maxChars
            defaultPrivacy: "unlisted"

        ReactDOM.unmountComponentAtNode @config.root
        ReactDOM.render frontend, @config.root

        return

    Laboratory.Handlers.Authentication.Verified.type = Laboratory.Events.Authentication.Verified.type
    Object.freeze Laboratory.Handlers.Authentication.Verified

##  Object Freezing  ##

    Object.freeze Laboratory.Handlers.Authentication




#  `Laboratory.Handlers.Notifications`  #

##  Coverage  ##

**The following events from `Notifications` have handlers:**

- `Notifications.Requested`
- `Notifications.Received`
- `Notifications.Removed`

**The following events from `Notifications` do *not* have handlers:**

- `Notifications.ItemLoaded`

##  Object Initialization  ##

    Laboratory.Handlers.Notifications = {}

##  Handlers  ##

###  `Notifications.Requested`

We have two things that we need to do when notifications are requested: query the server for their information, and hold onto the component requesting access.
We hold those here.

    Laboratory.Handlers.Notifications.Requested = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Notifications.Requested.type

        url = @auth.api + "/notifications"

If we want to adjust the slice of time our notifications are taken from, we can do that now.

        url += "?max_id=" + event.detail.before if event.detail.before?
        url += (if event.detail.before? then "&" else "?") + "since_id=" + event.detail.since if event.detail.since?

The `interfaces.notifications` object will store our notifications components.

        @interfaces.notifications.push event.detail.component if event.detail.component?

Next, we send the request.
Upon completion, it should trigger an `Notifications.Received` event so that we can handle the data.

        Laboratory.Functions.requestFromAPI url, @auth.accessToken, Laboratory.Events.Notifications.Received

        return

    Laboratory.Handlers.Notifications.Requested.type = Laboratory.Events.Notifications.Requested.type
    Object.freeze Laboratory.Handlers.Notifications.Requested

###  `Notifications.Received`

When notification data is received, we need to update its information in any components which might be using it.

    Laboratory.Handlers.Notifications.Received = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Notifications.Received.type

If there aren't any notifications components to update, then we do nothing.

        return unless @interfaces.notifications.length

We'll let `attributes` store the various attributes expected from the JSON response, so we can easily iterate over them.

        attributes = [
            "id"
            "url"
            "in_reply_to_id"
            "content"
            "created_at"
            "reblogged"
            "favourited"
            "sensitive"
            "spoiler_text"
            "visibility"
        ]

The notification `data` lives in `event.detail.data`.
We want to merge this with any existing data in our notifications and then provide our components with the result.

        items = {}
        itemOrder = []

We load the new information first because it will have the most Laboratory.Handlers.Notifications data.
You'll note we copy the notification information into a new object, which attempts to fetch the notification's parent account on request.
We also fire an `Account.Received` event containing the account data we received with the post.
(This event *should* be handled by the time the post is displayed.)

        receivedAccounts = []

        for item in event.detail.data
            items[item.id] = do (item, receivedAccounts) =>
                computedItem = {}
                if item.type isnt "follow"
                    computedItem[attribute] = item.status[attribute] for attribute in attributes
                    computedItem.media_attachments = Object.freeze (Object.freeze {url: attachment.url, preview_url: attachment.preview_url, type: attachment.type} for attachment in item.status.media_attachments)
                    computedItem.mentions = Object.freeze (Object.freeze {url: mention.url, acct: mention.acct, id: mention.id, username: mention.username} for mention in item.status.mentions)
                    if item.type isnt "mention" then Object.defineProperty computedItem,
                        switch item.type
                            when "reblog" then "reblogged_by"
                            when "favourite" then "favourited_by"
                        {
                            get: => return @accounts[item.account.id]
                            enumerable: true
                        }
                    Object.defineProperty computedItem, "account",
                        get: => return @accounts[item.status.account.id]
                        enumerable: true
                    if receivedAccounts.indexOf(item.status.account.id) is -1
                        Laboratory.Events.Account.Received {data: item.status.account}
                        receivedAccounts.push item.status.account.id
                else
                    computedItem.followed = true
                    Object.defineProperty computedItem, "account",
                        get: => return @accounts[item.account.id]
                        enumerable: true
                computedItem.id = item.id
                if receivedAccounts.indexOf(item.account.id) is -1
                    Laboratory.Events.Account.Received {data: item.account}
                    receivedAccounts.push item.account.id

                return Object.freeze computedItem

            itemOrder.push(item.id)

Then we load any previously-existing notifications if they haven't already been loaded.

        for id in @notifications.itemOrder when not items[id]?
            items[id] = @notifications.items[id]
            itemOrder.push(id)

We can now sort our notification order and save our data, giving our loaded notifications components the end result.

        itemOrder.sort (a, b) -> b - a

        @notifications.itemOrder = Object.freeze itemOrder
        @notifications.items = Object.freeze items

        notifications.setState {items, itemOrder} for notifications in @interfaces.notifications

        return

    Laboratory.Handlers.Notifications.Received.type = Laboratory.Events.Notifications.Received.type
    Object.freeze Laboratory.Handlers.Notifications.Received

##  `Notifications.Removed`  ##

`Notifications.Removed` has a much simpler handler than our previous two:
We just look for the provided component, and remove it from our notification interface.
Then, if there are no remaining components in our interface, we go ahead and get rid of our information to conserve memory.

    Laboratory.Handlers.Notifications.Removed = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Notifications.Removed.type

Of course, if we don't have any components assigned to the provided name, we can't do anything.

        return unless @interfaces.notifications?.length

This iterates over our components until we find the right one, and removes it from the array.

        index = 0;
        index++ until @interfaces.notifications[index] = event.detail.component or index >= @interfaces.notifications.length
        @interfaces.notifications.splice index, 1

If we no longer have any components assigned to our notifications, we re-initialize it in our store:

        unless @interfaces.notifications.length
            @notifications.items = Object.freeze {}
            @notifications.itemOrder = Object.freeze []

…And we're done!

        return

    Laboratory.Handlers.Notifications.Removed.type = Laboratory.Events.Notifications.Removed.type
    Object.freeze Laboratory.Handlers.Notifications.Removed

##  Object Freezing  ##

    Object.freeze Laboratory.Handlers.Notifications


#  `Laboratory.Handlers.Stream`  #

##  Coverage  ##

**The following events from `Stream` have handlers:**

- `Stream.Message`

**The following events from `Stream` do *not* have handlers:**

- `Stream.Open`
- `Stream.Close`
- `Stream.Error`

##  Object Initialization  ##

    Laboratory.Handlers.Stream = {}

##  Handlers  ##

###  `Stream.Message`

The Mastodon API sends a number of different messages, distinguished by the `type` property on the message data.
These are:

-   **`"update"` :**
    A new post has been made.

-   **`"delete"` :**
    An old post has been deleted.

-   **`"notification"` :**
    A notification has been triggered.

We'll simply forward the message onto the appropriate handler by creating a new event for each of these situations.

    Laboratory.Handlers.Stream.Message = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Stream.Message.type

        switch event.detail.data.type

The `Timeline.StatusLoaded` event will handle any new posts which have been made.

            when "update" then Laboratory.Events.Timeline.StatusLoaded
                fromStream: event.detail.stream
                payload: JSON.parse event.detail.data.payload

The `Timeline.StatusDeleted` event will handle any old posts which have been deleted.

            when "delete" then Laboratory.Events.Timeline.StatusDeleted
                fromStream: event.detail.stream
                payload: JSON.parse event.detail.data.payload

The `Notifications.ItemLoaded` event will handle any new notifications which have appeared.
We don't need to specify the stream here because notifications are only sent to `"user"`.

            when "notification" then Laboratory.Events.Notifications.ItemLoaded
                payload: JSON.parse event.detail.data.payload

    Laboratory.Handlers.Stream.Message.type = Laboratory.Events.Stream.Message.type
    Object.freeze Laboratory.Handlers.Stream.Message

##  Object Freezing  ##

    Object.freeze Laboratory.Handlers.Stream


#  `Laboratory.Handlers.Timeline`  #

##  Coverage  ##

**The following events from `Timeline` have handlers:**

- `Timeline.Requested`
- `Timeline.Received`
- `Timeline.Removed`

**The following events from `Timeline` do *not* have handlers:**

- `Timeline.StatusLoaded`
- `Timeline.StatusDeleted`

##  Object Initialization  ##

    Laboratory.Handlers.Timeline = {}

##  Handlers  ##

###  `Timeline.Requested`

We have two things that we need to do when timeline is requested: query the server for its information, and hold onto the component requesting access.
We hold those here.

    Laboratory.Handlers.Timeline.Requested = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Timeline.Requested.type

The name of the timeline doesn't directly correspond to the API URL we use to access it, so we derive that here.

        name = event.detail.name
        url = @auth.api + switch
            when name is "global" then "/timelines/public"
            when name is "community" then "/timelines/public?local=true"
            when name is "home" then "/timelines/home"
            when name.substr(0, 8) is "hashtag/" then "/timelines/tag/" + name.substr(8)
            when name.substr(0, 5) is "user/" then "/accounts/" + name.substr(5) + "/statuses"
            else name

If we want to adjust the slice of time our timeline is taken from, we can do that now.

        url += (if name isnt community then "?" else "&") + "max_id=" + event.detail.before if event.detail.before?
        url += (if name isnt community and not event.detail.before? then "?" else "&") + "since_id=" + event.detail.since if event.detail.since?

The `interfaces.timelines` object will store our timeline components, organized by the timeline urls.
We need to create an array to store our component in if one doesn't already exist:

        Object.defineProperty @interfaces.timelines, name, {value: [], enumerable: true} unless @interfaces.timelines[name] instanceof Array

We can now add our component.

        @interfaces.timelines[name].push event.detail.component if event.detail.component?

Next, we send the request.
Upon completion, it should trigger an `Timeline.Received` event so that we can handle the data.

        Laboratory.Functions.requestFromAPI url, @auth.accessToken, Laboratory.Events.Timeline.Received, {name}

        return

    Laboratory.Handlers.Timeline.Requested.type = Laboratory.Events.Timeline.Requested.type
    Object.freeze Laboratory.Handlers.Timeline.Requested

###  `Timeline.Received`

When an timeline's data is received, we need to update its information in any components which might be using it.

    Laboratory.Handlers.Timeline.Received = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Timeline.Received.type

        name = event.detail.params.name

If there aren't any timelines to update, then we do nothing.

        return unless @interfaces.timelines[name]?.length

We'll let `attributes` store the various attributes expected from the JSON response, so we can easily iterate over them.

        attributes = [
            "id"
            "url"
            "in_reply_to_id"
            "content"
            "created_at"
            "reblogged"
            "favourited"
            "sensitive"
            "spoiler_text"
            "visibility"
        ]

If we don't have a place to stick our data yet, let's create it:

        Object.defineProperty @timelines, name, {value: Object.seal {posts: {}, postOrder: []}, enumerable: true} unless (@timelines[name] instanceof Object) and (@timelines[name].posts instanceof Object) and (@timelines[name].postOrder instanceof Array)

The timeline `data` lives in `event.detail.data`.
We want to merge this with any existing data in our timelines and then provide our components with the result.

        posts = {}
        postOrder = []

We load the new information first because it will have the most Laboratory.Handlers.Timeline data.
You'll note we copy the post information into a new object, which attempts to fetch post's parent account on request.
We also fire an `Account.Received` event containing the account data we received with the post.
(This event *should* be handled by the time the post is displayed.)

        receivedAccounts = []

        for post in event.detail.data
            posts[post.id] = do (post, receivedAccounts) =>
                computedPost = {}
                sourcePost = if post.reblog? then post.reblog else post
                computedPost[attribute] = sourcePost[attribute] for attribute in attributes
                computedPost.media_attachments = Object.freeze (Object.freeze {url: attachment.url, preview_url: attachment.preview_url, type: attachment.type} for attachment in sourcePost.media_attachments)
                computedPost.mentions = Object.freeze (Object.freeze {url: mention.url, acct: mention.acct, id: mention.id, username: mention.username} for mention in sourcePost.mentions)
                Object.defineProperty computedPost, "account",
                    get: => return @accounts[sourcePost.account.id]
                    enumerable: true
                if receivedAccounts.indexOf(sourcePost.account.id) is -1
                    Laboratory.Events.Account.Received {data: sourcePost.account}
                    receivedAccounts.push sourcePost.account.id
                if post.reblog?
                    computedPost.id = post.id
                    Object.defineProperty computedPost, "reblogged_by",
                        get: => return @accounts[post.account.id]
                        enumerable: true
                    if receivedAccounts.indexOf(post.account.id) is -1
                        Laboratory.Events.Account.Received {data: post.account}
                        receivedAccounts.push post.account.id
                return Object.freeze computedPost

            postOrder.push(post.id)

Then we load any previously-existing posts if they haven't already been loaded.

        for id in @timelines[name].postOrder when not posts[id]?
            posts[id] = @timelines[name].posts[id]
            postOrder.push(id)

We can now sort our post order and save our data, giving our loaded timeline components the end result.

        postOrder.sort (a, b) -> b - a

        @timelines[name].postOrder = Object.freeze postOrder
        @timelines[name].posts = Object.freeze posts

        timeline.setState {posts, postOrder} for timeline in @interfaces.timelines[name]

        return

    Laboratory.Handlers.Timeline.Received.type = Laboratory.Events.Timeline.Received.type
    Object.freeze Laboratory.Handlers.Timeline.Received

##  `Timeline.Removed`  ##

`Timeline.Removed` has a much simpler handler than our previous two:
We just look for the provided component, and remove it from our timeline interface.
Then, if there are no remaining timelines for that `name` (as is probable), we go ahead and get rid of our information to conserve memory.

    Laboratory.Handlers.Timeline.Removed = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Timeline.Removed.type

Of course, if we don't have any components assigned to the provided name, we can't do anything.

        return unless @interfaces.timelines[event.detail.name]?.length

This iterates over our components until we find the right one, and removes it from the array.

        index = 0;
        index++ until @interfaces.timelines[event.detail.name][index] = event.detail.component or index >= @interfaces.timelines[event.detail.name].length
        @interfaces.timelines[event.detail.name].splice index, 1

If we no longer have any components assigned to the timeline, we re-initialize it in our store:

        return unless @timelines[event.detail.name] instanceof Object
        unless @interfaces.timelines[event.detail.name].length
            @timelines[event.detail.name].posts = Object.freeze {}
            @timelines[event.detail.name].postOrder = Object.freeze []

…And we're done!

        return

    Laboratory.Handlers.Timeline.Removed.type = Laboratory.Events.Timeline.Removed.type
    Object.freeze Laboratory.Handlers.Timeline.Removed

##  Object Freezing  ##

    Object.freeze Laboratory.Handlers.Timeline


    Laboratory.Locales.de = Object.freeze

        "timeline.home": "Home"
        "notifications.notifications": "Mitteilungen"
        "composer.compose": "Schreiben"
        "notfound.not_found": "Nicht gefunden"
        # "go.heading":
        # "go.community":
        # "go.global":

        #  Unused codes from Mastodon:

        "column_back_button.label": "Zurück"
        "lightbox.close": "Schließen"
        "loading_indicator.label": "Lade..."
        "status.mention": "Erwähnen"
        "status.delete": "Löschen"
        "status.reply": "Antworten"
        "status.reblog": "Teilen"
        "status.favourite": "Favorisieren"
        "status.reblogged_by": "{name} teilte"
        "status.sensitive_warning": "Sensible Inhalte"
        "status.sensitive_toggle": "Klicken um zu zeigen"
        "status.open": "Öffnen"
        "video_player.toggle_sound": "Ton umschalten"
        "account.mention": "Erwähnen"
        "account.edit_profile": "Profil bearbeiten"
        "account.unblock": "Entblocken"
        "account.unfollow": "Entfolgen"
        "account.block": "Blocken"
        "account.follow": "Folgen"
        "account.posts": "Beiträge"
        "account.follows": "Folgt"
        "account.followers": "Folger"
        "account.follows_you": "Folgt dir"
        "account.requested": "Warte auf Erlaubnis"
        "getting_started.heading": "Erste Schritte"
        "getting_started.about_addressing": "Du kannst Leuten folgen falls du ihren Nutzernamen und ihre Domain kennst in dem du eine e-mail-artige Addresse in das Suchfeld oben an der Seite eingibst."
        "getting_started.about_shortcuts": "Falls der Zielnutzer an derselben Domain ist wie du funktioniert der Nutzername auch alleine. Das gilt auch für Erwähnungen in Beiträgen."
        "getting_started.about_developer": "Der Entwickler des Projekts kann unter Gargron@mastodon.social gefunden werden"
        "getting_started.open_source_notice": "Mastodon ist quelloffene Software. Du kannst auf {github} dazu beitragen oder Probleme melden."
        "column.home": "Home"
        "column.mentions": "Erwähnungen"
        "column.public": "Gesamtes Bekanntes Netz"
        "column.notifications": "Mitteilungen"
        "column.follow_requests": "Folgeanfragen"
        "tabs_bar.compose": "Schreiben"
        "tabs_bar.home": "Home"
        "tabs_bar.mentions": "Erwähnungen"
        "tabs_bar.public": "Gesamtes Netz"
        "tabs_bar.notifications": "Mitteilungen"
        "compose_form.placeholder": "Worüber möchstest du schreiben?"
        "compose_form.publish": "Veröffentlichen"
        "compose_form.sensitive": "Medien als sensitiv markieren"
        "compose_form.unlisted": "Öffentlich nicht auflisten"
        "compose_form.private": "Als privat markieren"
        "navigation_bar.edit_profile": "Profil bearbeiten"
        "navigation_bar.preferences": "Einstellungen"
        "navigation_bar.public_timeline": "Öffentlich"
        "navigation_bar.logout": "Abmelden"
        "navigation_bar.follow_requests": "Folgeanfragen"
        "reply_indicator.cancel": "Abbrechen"
        "search.placeholder": "Suche"
        "search.account": "Konto"
        "search.hashtag": "Hashtag"
        "upload_button.label": "Media-Datei anfügen"
        "upload_form.undo": "Entfernen"
        "notification.follow": "{name} folgt dir"
        "notification.favourite": "{name} favorisierte deinen Status"
        "notification.reblog": "{name} teilte deinen Status"
        "notification.mention": "{name} erwähnte dich"
        "notifications.column_settings.alert": "Desktop-Benachrichtigunen"
        "notifications.column_settings.show": "In der Spalte anzeigen"
        "notifications.column_settings.follow": "Neue Folger:"
        "notifications.column_settings.favourite": "Favorisierungen:"
        "notifications.column_settings.mention": "Erwähnungen:"
        "notifications.column_settings.reblog": "Geteilte Beiträge:"
        "follow_request.authorize": "Erlauben"
        "follow_request.reject": "Ablehnen"
        "home.column_settings.basic": "Einfach"
        "home.column_settings.advanced": "Fortgeschritten"
        "home.column_settings.show_reblogs": "Geteilte Beiträge anzeigen"
        "home.column_settings.show_replies": "Antworten anzeigen"
        "home.column_settings.filter_regex": "Filter durch reguläre Ausdrücke"
        "missing_indicator.label": "Nicht gefunden"


    Laboratory.Locales.en = Object.freeze

        "timeline.home": "Home"
        "notifications.notifications": "Notifications"

        "composer.compose": "Compose"
        "composer.post": "Post"
        "composer.private": "Private"
        "composer.public": "Public"
        "composer.unlisted": "Unlisted"
        "composer.listed": "Listed"
        "composer.safe": "Safe"
        "composer.sensitive": "Sensitive"
        "composer.hidewithmessage": "Hide behind message"
        "composer.placeholder": "What's going on?"

        "account.follow": "Follow"
        "account.unfollow": "Unfollow"
        "account.blocking": "Blocking"
        "account.requestfollow": "Request Follow"
        "account.requestsent": "Request Sent"
        "account.statuses": "Posts"
        "account.following": "Follows"
        "account.followers": "Followers"

        "status.and": " and "
        "status.etal": " et al."
        "status.followedyou": " followed you!"
        "status.boostedthisreplyto": " boosted this reply to "
        "status.boostedthisreply": " boosted this reply"
        "status.boostedthispost": " boosted this post"
        "status.highlightedthisreplyto": " highlighted this reply to "
        "status.highlightedthisreply": " highlighted this reply"
        "status.highlightedthispost": " highlighted this post"
        "status.inreplyto": "In reply to "
        "status.inreplytoself": "In reply to themselves"

        "go.heading": "let's GO!"
        "go.community": "Community"
        "go.global": "Global"

        "toggle.off": "Off"
        "toggle.on": "On"

        "notfound.not_found": "Not found"

        #  Unused codes from Mastodon:

        "column_back_button.label": "Back"
        "lightbox.close": "Close"
        "loading_indicator.label": "Loading..."
        "status.mention": "Mention"
        "status.delete": "Delete"
        "status.reply": "Reply"
        "status.reblog": "Boost"
        "status.favourite": "Favourite"
        "status.reblogged_by": "{name} boosted"
        "status.sensitive_warning": "Sensitive content"
        "status.sensitive_toggle": "Click to view"
        "video_player.toggle_sound": "Toggle sound"
        "account.mention": "Mention"
        "account.edit_profile": "Edit profile"
        "account.unblock": "Unblock"
        "account.unfollow": "Unfollow"
        "account.block": "Block"
        "account.follow": "Follow"
        "account.posts": "Posts"
        "account.follows": "Follows"
        "account.followers": "Followers"
        "account.follows_you": "Follows you"
        "account.requested": "Awaiting approval"
        "getting_started.heading": "Getting started"
        "getting_started.about_addressing": "You can follow people if you know their username and the domain they are on by entering an e-mail-esque address into the search form."
        "getting_started.about_shortcuts": "If the target user is on the same domain as you just the username will work. The same rule applies to mentioning people in statuses."
        "getting_started.about_developer": "The developer of this project can be followed as Gargron@mastodon.social"
        "getting_started.open_source_notice": "Mastodon is open source software. You can contribute or report issues on github at {github}."
        "column.home": "Home"
        "column.mentions": "Mentions"
        "column.public": "Public"
        "column.notifications": "Notifications"
        "tabs_bar.compose": "Compose"
        "tabs_bar.home": "Home"
        "tabs_bar.mentions": "Mentions"
        "tabs_bar.public": "Public"
        "tabs_bar.notifications": "Notifications"
        "compose_form.placeholder": "What is on your mind?"
        "compose_form.publish": "Toot"
        "compose_form.sensitive": "Mark media as sensitive"
        "compose_form.spoiler": "Hide text behind warning"
        "compose_form.private": "Mark as private"
        "compose_form.privacy_disclaimer": "Your private status will be delivered to mentioned users on {domains}. Do you trust {domainsCount plural one {that server} other {those servers}} to not leak your status?"
        "compose_form.unlisted": "Do not display in public timeline"
        "navigation_bar.edit_profile": "Edit profile"
        "navigation_bar.preferences": "Preferences"
        "navigation_bar.public_timeline": "Public timeline"
        "navigation_bar.logout": "Logout"
        "reply_indicator.cancel": "Cancel"
        "search.placeholder": "Search"
        "search.account": "Account"
        "search.hashtag": "Hashtag"
        "upload_button.label": "Add media"
        "upload_form.undo": "Undo"
        "notification.follow": "{name} followed you"
        "notification.favourite": "{name} favourited your status"
        "notification.reblog": "{name} boosted your status"
        "notification.mention": "{name} mentioned you"
        "notifications.column_settings.alert": "Desktop notifications"
        "notifications.column_settings.show": "Show in column"
        "notifications.column_settings.follow": "New followers:"
        "notifications.column_settings.favourite": "Favourites:"
        "notifications.column_settings.mention": "Mentions:"
        "notifications.column_settings.reblog": "Boosts:"
        "missing_indicator.label": "Not found"


    Laboratory.Locales.es = Object.freeze

        "timeline.home": "Inicio"
        "notifications.notifications": "Notificaciones"
        "composer.compose": "Redactar"
        "notfound.not_found": "No encontrada"
        # "go.heading":
        # "go.community":
        # "go.global":

        #  Unused codes from Mastodon:

        "column_back_button.label": "Atrás"
        "lightbox.close": "Cerrar"
        "loading_indicator.label": "Cargando..."
        "status.mention": "Mencionar"
        "status.delete": "Borrar"
        "status.reply": "Responder"
        "status.reblog": "Republicar"
        "status.favourite": "Favorito"
        "status.reblogged_by": "{name} republicado"
        "video_player.toggle_sound": "Act/Desac. sonido"
        "account.mention": "Mención"
        "account.edit_profile": "Editar perfil"
        "account.unblock": "Desbloquear"
        "account.unfollow": "Dejar de seguir"
        "account.block": "Bloquear"
        "account.follow": "Seguir"
        "account.block": "Bloquear"
        "account.posts": "Publicaciones"
        "account.follows": "Seguir"
        "account.followers": "Seguidores"
        "account.follows_you": "Te sigue"
        "getting_started.heading": "Primeros pasos"
        "getting_started.about_addressing": "Puedes seguir a gente si conoces su nombre de usuario y el dominio en el que están registrados introduciendo algo similar a una dirección de correo electrónico en el formulario en la parte superior de la barra lateral."
        "getting_started.about_shortcuts": "Si el usuario que buscas está en el mismo dominio que tú simplemente funcionará introduciendo el nombre de usuario. La misma regla se aplica para mencionar a usuarios."
        "getting_started.about_developer": "Puedes seguir al desarrollador de este proyecto en Gargron@mastodon.social"
        "column.home": "Inicio"
        "column.mentions": "Menciones"
        "column.public": "Historia pública"
        "column.notifications": "Notificaciones"
        "tabs_bar.compose": "Redactar"
        "tabs_bar.home": "Inicio"
        "tabs_bar.mentions": "Menciones"
        "tabs_bar.public": "Público"
        "tabs_bar.notifications": "Notificaciones"
        "compose_form.placeholder": "¿En qué estás pensando?"
        "compose_form.publish": "Publicar"
        "compose_form.sensitive": "Marcar el contenido como sensible"
        "compose_form.unlisted": "Privado"
        "navigation_bar.edit_profile": "Editar perfil"
        "navigation_bar.preferences": "Preferencias"
        "navigation_bar.public_timeline": "Público"
        "navigation_bar.logout": "Cerrar sesión"
        "reply_indicator.cancel": "Cancelar"
        "search.placeholder": "Buscar"
        "search.account": "Cuenta"
        "search.hashtag": "Etiqueta"
        "upload_button.label": "Añadir medio"
        "upload_form.undo": "Deshacer"
        "notification.follow": "{name} le esta ahora siguiendo"
        "notification.favourite": "{name} marcó como favorito su estado"
        "notification.reblog": "{name} volvió a publicar su estado"
        "notification.mention": "Fue mencionado por {name}"


    Laboratory.Locales.fr = Object.freeze

        "timeline.home": "Accueil"
        "notifications.notifications": "Notifications"
        "composer.compose": "Composer"
        "notfound.not_found": "Pas trouvé"
        # "go.heading":
        # "go.community":
        # "go.global":

        #  Unused codes from Mastodon:

        "column_back_button.label": "Retour"
        "lightbox.close": "Fermer"
        "loading_indicator.label": "Chargement…"
        "status.mention": "Mentionner"
        "status.delete": "Effacer"
        "status.reply": "Répondre"
        "status.reblog": "Partager"
        "status.favourite": "Ajouter aux favoris"
        "status.reblogged_by": "{name} a partagé :"
        "status.sensitive_warning": "Contenu délicat"
        "status.sensitive_toggle": "Cliquer pour dévoiler"
        "video_player.toggle_sound": "Mettre/Couper le son"
        "account.mention": "Mentionner"
        "account.edit_profile": "Modifier le profil"
        "account.unblock": "Débloquer"
        "account.unfollow": "Ne plus suivre"
        "account.block": "Bloquer"
        "account.follow": "Suivre"
        "account.posts": "Statuts"
        "account.follows": "Abonnements"
        "account.followers": "Abonnés"
        "account.follows_you": "Vous suit"
        "getting_started.heading": "Pour commencer"
        "getting_started.about_addressing": "Vous pouvez vous suivre les statuts de quelqu’un en entrant dans le champs de recherche leur identifiant et le domaine de leur instance séparés par un @ à la manière d’une adresse courriel."
        "getting_started.about_shortcuts": "Si cette personne utilise la même instance que vous l’identifiant suffit. C’est le même principe pour mentionner quelqu’un dans vos statuts."
        "getting_started.about_developer": "Pour suivre le développeur de ce projet c’est Gargron@mastodon.social"
        "column.home": "Accueil"
        "column.mentions": "Mentions"
        "column.public": "Fil public"
        "column.notifications": "Notifications"
        "tabs_bar.compose": "Composer"
        "tabs_bar.home": "Accueil"
        "tabs_bar.mentions": "Mentions"
        "tabs_bar.public": "Public"
        "tabs_bar.notifications": "Notifications"
        "compose_form.placeholder": "Qu’avez-vous en tête ?"
        "compose_form.publish": "Pouet"
        "compose_form.sensitive": "Marquer le contenu comme délicat"
        "compose_form.unlisted": "Ne pas apparaître dans le fil public"
        "navigation_bar.edit_profile": "Modifier le profil"
        "navigation_bar.preferences": "Préférences"
        "navigation_bar.public_timeline": "Public"
        "navigation_bar.logout": "Déconnexion"
        "reply_indicator.cancel": "Annuler"
        "search.placeholder": "Chercher"
        "search.account": "Compte"
        "search.hashtag": "Mot-clé"
        "upload_button.label": "Joindre un média"
        "upload_form.undo": "Annuler"
        "notification.follow": "{name} vous suit."
        "notification.favourite": "{name} a ajouté à ses favoris :"
        "notification.reblog": "{name} a partagé votre statut :"
        "notification.mention": "{name} vous a mentionné⋅e :"


    Laboratory.Locales.hu = Object.freeze

        "timeline.home": "Kezdőlap"
        "notifications.notifications": "Értesítések"
        "composer.compose": "Összeállítás"
        "notfound.not_found": "Nem található"
        # "go.heading":
        # "go.community":
        # "go.global":

        #  Unused codes from Mastodon:

        "column_back_button.label": "Vissza"
        "lightbox.close": "Bezárás"
        "loading_indicator.label": "Betöltés..."
        "status.mention": "Említés"
        "status.delete": "Törlés"
        "status.reply": "Válasz"
        "status.reblog": "Reblog"
        "status.favourite": "Kedvenc"
        "status.reblogged_by": "{name} reblogolta"
        "status.sensitive_warning": "Érzékeny tartalom"
        "status.sensitive_toggle": "Katt a megtekintéshez"
        "video_player.toggle_sound": "Hang kapcsolása"
        "account.mention": "Említés"
        "account.edit_profile": "Profil szerkesztése"
        "account.unblock": "Blokkolás levétele"
        "account.unfollow": "Követés abbahagyása"
        "account.block": "Blokkolás"
        "account.follow": "Követés"
        "account.posts": "Posts"
        "account.follows": "Követők"
        "account.followers": "Követők"
        "account.follows_you": "Követnek téged"
        "getting_started.heading": "Első lépések"
        "getting_started.about_addressing": "Követhetsz embereket felhasználónevük és a doménjük ismeretében amennyiben megadod ezt az e-mail-szerű címet az oldalsáv tetején lévő rubrikában."
        "getting_started.about_shortcuts": "Ha a célzott személy azonos doménen tartózkodik a felhasználónév elegendő. Ugyanez érvényes mikor személyeket említesz az állapotokban."
        "getting_started.about_developer": "A projekt fejlesztője követhető mint Gargron@mastodon.social"
        "column.home": "Kezdőlap"
        "column.mentions": "Említések"
        "column.public": "Nyilvános"
        "column.notifications": "Értesítések"
        "tabs_bar.compose": "Összeállítás"
        "tabs_bar.home": "Kezdőlap"
        "tabs_bar.mentions": "Említések"
        "tabs_bar.public": "Nyilvános"
        "tabs_bar.notifications": "Notifications"
        "compose_form.placeholder": "Mire gondolsz?"
        "compose_form.publish": "Tülk!"
        "compose_form.sensitive": "Tartalom érzékenynek jelölése"
        "compose_form.unlisted": "Listázatlan mód"
        "navigation_bar.edit_profile": "Profil szerkesztése"
        "navigation_bar.preferences": "Beállítások"
        "navigation_bar.public_timeline": "Nyilvános időfolyam"
        "navigation_bar.logout": "Kijelentkezés"
        "reply_indicator.cancel": "Mégsem"
        "search.placeholder": "Keresés"
        "search.account": "Fiók"
        "search.hashtag": "Hashtag"
        "upload_button.label": "Média hozzáadása"
        "upload_form.undo": "Mégsem"
        "notification.follow": "{name} követ téged"
        "notification.favourite": "{name} kedvencnek jelölte az állapotod"
        "notification.reblog": "{name} reblogolta az állapotod"
        "notification.mention": "{name} megemlített"


    Laboratory.Locales.pt = Object.freeze

        "timeline.home": "Home"
        "notifications.notifications": "Notificações"
        "composer.compose": "Compôr"
        "notfound.not_found": "Não encontrada"
        # "go.heading":
        # "go.community":
        # "go.global":

        #  Unused codes from Mastodon:

        "column_back_button.label": "Voltar"
        "lightbox.close": "Fechar"
        "loading_indicator.label": "Carregando..."
        "status.mention": "Menção"
        "status.delete": "Deletar"
        "status.reply": "Responder"
        "status.reblog": "Reblogar"
        "status.favourite": "Favoritar"
        "status.reblogged_by": "{name} reblogou"
        "video_player.toggle_sound": "Alterar som"
        "account.mention": "Menção"
        "account.edit_profile": "Editar perfil"
        "account.unblock": "Desbloquear"
        "account.unfollow": "Unfollow"
        "account.block": "Bloquear"
        "account.follow": "Seguir"
        "account.block": "Bloquear"
        "account.posts": "Posts"
        "account.follows": "Segue"
        "account.followers": "Seguidores"
        "account.follows_you": "Segue você"
        "getting_started.heading": "Primeiros passos"
        "getting_started.about_addressing": "Podes seguir pessoas se sabes o nome de usuário deles e o domínio em que estão entrando um endereço similar a e-mail no campo no topo da barra lateral."
        "getting_started.about_shortcuts": "Se o usuário alvo está no mesmo domínio só o nome funcionará. A mesma regra se aplica a mencionar pessoas nas postagens."
        "getting_started.about_developer": "O desenvolvedor desse projeto pode ser seguido em Gargron@mastodon.social"
        "column.home": "Home"
        "column.mentions": "Menções"
        "column.public": "Público"
        "tabs_bar.compose": "Compôr"
        "tabs_bar.home": "Home"
        "tabs_bar.mentions": "Menções"
        "tabs_bar.public": "Público"
        "tabs_bar.notifications": "Notificações"
        "compose_form.placeholder": "Que estás pensando?"
        "compose_form.publish": "Publicar"
        "compose_form.sensitive": "Marcar conteúdo como sensível"
        "compose_form.unlisted": "Modo não-listado"
        "navigation_bar.edit_profile": "Editar perfil"
        "navigation_bar.preferences": "Preferências"
        "navigation_bar.public_timeline": "Timeline Pública"
        "navigation_bar.logout": "Logout"
        "reply_indicator.cancel": "Cancelar"
        "search.placeholder": "Busca"
        "search.account": "Conta"
        "search.hashtag": "Hashtag"
        "upload_button.label": "Adicionar media"
        "upload_form.undo": "Desfazer"
        "notification.follow": "{name} seguiu você"
        "notification.favourite": "{name} favoritou  seu post"
        "notification.reblog": "{name} reblogou o seu post"
        "notification.mention": "{name} mecionou você"


    Laboratory.Locales.uk = Object.freeze

        "timeline.home": "Головна"
        "notifications.notifications": "Сповіщення"
        "composer.compose": "Написати"
        "notfound.not_found": "Не знайдено"
        # "go.heading":
        # "go.community":
        # "go.global":

        #  Unused codes from Mastodon:

        "column_back_button.label": "Назад"
        "lightbox.close": "Закрити"
        "loading_indicator.label": "Завантаження..."
        "status.mention": "Згадати"
        "status.delete": "Видалити"
        "status.reply": "Відповісти"
        "status.reblog": "Передмухнути"
        "status.favourite": "Подобається"
        "status.reblogged_by": "{name} передмухнув(-ла)"
        "status.sensitive_warning": "Непристойний зміст"
        "status.sensitive_toggle": "Натисніть щоб подивитися"
        "video_player.toggle_sound": "Увімкнути/вимкнути звук"
        "account.mention": "Згадати"
        "account.edit_profile": "Налаштування профілю"
        "account.unblock": "Розблокувати"
        "account.unfollow": "Відписатися"
        "account.block": "Заблокувати"
        "account.follow": "Підписатися"
        "account.posts": "Пости"
        "account.follows": "Підписки"
        "account.followers": "Підписники"
        "account.follows_you": "Підписаний"
        "getting_started.heading": "Ласкаво просимо"
        "getting_started.about_addressing": "Ви можете підписуватись на людей якщо ви знаєте їх ім'я користувача чи домен шляхом введення email-подібної адреси у верхньому рядку бокової панелі."
        "getting_started.about_shortcuts": "Якщо користувач якого ви шукаєте знаходиться на тому ж домені що й ви можна просто ввести ім'я користувача. Це правило стосується й згадування людей у статусах."
        "getting_started.about_developer": "Розробник проекту знаходиться за адресою Gargron@mastodon.social"
        "column.home": "Головна"
        "column.mentions": "Згадування"
        "column.public": "Стіна"
        "column.notifications": "Сповіщення"
        "tabs_bar.compose": "Написати"
        "tabs_bar.home": "Головна"
        "tabs_bar.mentions": "Згадування"
        "tabs_bar.public": "Стіна"
        "tabs_bar.notifications": "Сповіщення"
        "compose_form.placeholder": "Що у Вас на думці?"
        "compose_form.publish": "Дмухнути"
        "compose_form.sensitive": "Непристойний зміст"
        "compose_form.unlisted": "Таємний режим"
        "navigation_bar.edit_profile": "Редагувати профіль"
        "navigation_bar.preferences": "Налаштування"
        "navigation_bar.public_timeline": "Публічна стіна"
        "navigation_bar.logout": "Вийти"
        "reply_indicator.cancel": "Відмінити"
        "search.placeholder": "Пошук"
        "search.account": "Аккаунт"
        "search.hashtag": "Хештеґ"
        "upload_button.label": "Додати медіа"
        "upload_form.undo": "Відмінити"
        "notification.follow": "{name} підписався(-лась) на Вас"
        "notification.favourite": "{name} сподобався ваш допис"
        "notification.reblog": "{name} передмухнув(-ла) Ваш статус"
        "notification.mention": "{name} згадав(-ла) Вас"


Use Object.defineProperty because this shouldn't be enumerable:

    Object.defineProperty Laboratory.Locales, "getL10n",
        value: (locale) -> Laboratory.Locales[locale]


#  `run`  #

This script loads and runs the frontend.
Consequently, it should probably be the last thing you load.

##  First Steps  ##

###  Freezing the Laboratory object:

We don't want nefarious entities meddling in our affairs, so let's freeze `Laboratory` and keep ourselves safe.

    Object.freeze Laboratory[module] for module of Laboratory
    for module of Laboratory.Components
        Object.freeze Laboratory.Components[module].parts
        Object.freeze Laboratory.Components[module].productions

###  Handling locale data:

This adds locale data so that our router can handle it:

    ReactIntl.addLocaleData [ReactIntlLocaleData.en..., ReactIntlLocaleData.de..., ReactIntlLocaleData.es..., ReactIntlLocaleData.fr..., ReactIntlLocaleData.pt..., ReactIntlLocaleData.hu..., ReactIntlLocaleData.uk...]

##  The Store  ##

Laboratory data is all stored in a single store, and then acted upon through events and event listeners.
The store is not available outside of those events specified through `initialize`

###  Loading the store:

We can now load the store.
We'll wrap this all in a closure to make extra sure that nobody has access to it except our handlers.

    run = ->

We initialize our store based on information provided in the `data-laboratory-config` attribute of our document's root element.
This data should be a JSON object.
For vanilla Mastodon installs, this information will be stored in the `window.INITIAL_STATE` object instead.

        config = JSON.parse(document.documentElement.getAttribute "data-laboratory-config")
        if not config
            if INITIAL_STATE? then config =
                baseName: INITIAL_STATE.meta.router_basename
                locale: INITIAL_STATE.meta.locale
            else config = {}

One item of note in our store is the entry `config.root`, which contains the React root.
The React root is determined according to the following rules:

1.  If the `config` object loaded above has a `root` property, the object whose id matches the string value of this property will be used.

2.  If there exists an element with id `"frontend"`, this will be used.
    This should be the case on Ardipithecus.

3.  If no such element exists, but there is at least one element of class name `"app-body"`, the first such element will be used.
    This should be the case on Mastodon.

4.  Otherwise, `document.body` is used as the React root.

As you can see, we also initialize a number of other data structures at this time.

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
            config: Object.freeze
                baseName: do (config) ->
                    a = document.createElement "a"
                    a.href = config.baseName || "."
                    return a.pathname
                locale: config.locale
                useBrowserHistory: config.useBrowserHistory or not config.useBrowserHistory?
                root: switch
                    when config.root and (elt = document.getElementById String config.root) then elt
                    when (elt = document.getElementById "frontend") then elt
                    when (elt = document.getElementsByClassName("app-body").item 0) then elt
                    else document.body
            interfaces: Object.freeze
                accounts: {}
                notifications: []
                timelines: {}
            notifications: Object.freeze
                itemOrder: Object.freeze []
                items: Object.freeze {}
            site: Object.seal
                title: undefined
                links: undefined
                maxChars: undefined
            timelines: {}

        window.store = store

###  Adding our listeners:

Now that our store is created, we can initialize our event handlers, binding them to its value.
It's pretty easy; we just enumerate over `Laboratory.Handlers`.

        for category, object of Laboratory.Handlers
            document.addEventListener handler.type, handler.bind store for name, handler of object

###  Rendering the sign-in form:

Finally, we render our initial sign-in form to allow the user to sign into the instance of their choice.

        ReactDOM.render 彁(Laboratory.Components.Shared.productions.InstanceQuery, {locale: store.config.locale}), store.config.root

        return

###  Running asynchronously:

We don't want the store loading before `document.body` or any of our other scripts, so we'll attach a `window.onload` event handler.

    window.addEventListener "load", run
