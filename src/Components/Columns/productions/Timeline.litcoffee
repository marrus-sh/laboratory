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
