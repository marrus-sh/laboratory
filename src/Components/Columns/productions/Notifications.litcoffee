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
