#  `论.Notifications`  #

##  Usage  ##

>   ```jsx
>       <Notifications />
>   ```
>   Creates a `Notifications` component, which contains a column of notifications.

##  The Component  ##

Our `Notifications` component doesn't take any properties, as it is only used for displaying notifications.

    论.Notifications = React.createClass

        getInitialState: ->
            items: {}
            settings: {}

###  Loading:

When our component first loads, we should request its data.

        componentWillMount: ->
            动.Notifications.Requested
                component: this

###  Unloading:

When our component unloads, we should signal that we no longer need its data.

        componentWillUnmount: ->
            动.Notifications.Removed
                component: this

###  Rendering:

        render: ->
            目 示.Column, {id: "laboratory-notifications"},
                目 示.Heading, {icon: "star-half-o"},
                    目 ReactIntl.FormattedMessage,
                        id: "notifications.notifications"
                        defaultMessage: "Notifications"
                (目 示.Status, {data} for id, data in @state.items when data.shouldRender @state.settings)...
