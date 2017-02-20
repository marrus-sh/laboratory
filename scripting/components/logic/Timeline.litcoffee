#  `论.Timeline`  #

##  Usage  ##

>   ```jsx
>       <Timeline
>           name=React.PropTypes.string.isRequired
>       />
>   ```
>   Creates a `Timeline` component, which contains a timeline of statuses. The accepted properties are:
>   -   **`name` [REQUIRED `string`] :**
>       The name of the timeline.

##  Imports  ##

We need to import `FormattedMessage` in order to properly internationalize our titles.

    {FormattedMessage} = require "react-intl";

##  The Component  ##

Our Timeline only has one property, a string specifying the `name` of the timeline.

    论.Timeline = React.createClass

        propTypes:
            name: React.PropTypes.string.isRequired

        getInitialState: ->
            posts: {}
            settings: {}

###  Getting the heading icon:

The heading icon can be derived from `name` using the following function:

        getIcon: ->
            switch @props.name
                when "home" then "home"
                when "public" then "user"
                when "twkn" then "users"
                else "bar"

###  Loading:

When our timeline first loads, we should request its data.

        componentWillMount: ->
            动.Timeline.Requested
                name: @props.name
                component: this

###  Unloading:

When our timeline unloads, we should signal that we no longer need its data.

        componentWillUnmount: ->
            动.Timeline.Removed
                name: @props.name
                component: this

###  Rendering:

        render: ->
            目 示.Column, null,
                目 示.Heading, {icon: @getIcon()},
                    目 FormattedMessage,
                        id: "timeline." + @props.name
                        defaultMessage: @props.name.charAt(0).toLocaleUpperCase() + @props.name.slice(1)
                (目 示.Status, {data} for id, data in @state.posts when data.shouldRender @state.settings)...
