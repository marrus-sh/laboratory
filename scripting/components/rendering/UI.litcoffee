#  `示.UI`  #

##  Usage  ##

>   ```jsx
>       <UI title=React.PropTypes.string>
>           {/* content */}
>       </UI>
>   ```
>   Creates a `UI` component, which contains the entire rendered frontend.

##  Imports  ##

We need to import `FormattedMessage` in order to properly internationalize our "not found" message.

    {FormattedMessage} = require "react-intl";

##  The Component  ##

Our UI doesn't have any properties except for its `title` and children.

    示.UI = React.createClass

        propTypes:
            children: React.PropTypes.node
            title: React.PropTypes.string

###  Event handling:

Here we will handle events related to the UI:

        handleEvent: (e) ->
            switch e.type

####  Drag-and-drop.

This handles our drag-and-drop events:

                when "dragenter" then 页.getElementById("laboratory-ui").setAttribute "data-laboratory-dragging", ""
                when "dragover"
                    e.preventDefault()
                    e.dataTransfer.dropEffect = "copy"
                when "dragleave" then 页.getElementById("laboratory-ui").removeAttribute "data-laboratory-dragging" unless e.relatedTarget?
                when "drop"
                    e.preventDefault()
                    页.getElementById("laboratory-ui").removeAttribute "data-laboratory-dragging"
                    动.Drop.New {file: e.dataTransfer.files.item 1} if e.dataTransfer and e.dataTransfer.files.length is 1


###  Loading:

Here we add our event listeners.

        componentWillMount: ->
            听 "dragenter", this
            听 "dragover", this
            听 "dragleave", this
            听 "drop", this

###  Unloading:

We can remove our event listeners if we're unloading our UI.

        componentWillUnmount: ->
            除 "dragenter", this
            除 "dragover", this
            除 "dragleave", this
            除 "drop", this

###  Rendering:

        render: ->
            目 'div', {id: "laboratory-ui"},
                目 示.Header, null,
                    目 示.Title, null,
                        @props.title
                    目 'span', {id: "laboratory-composelabel"},
                        目 FormattedMessage,
                            id: "composer.compose"
                            defaultMessage: "Compose"
                    目 示.Compose
                目 论.Timeline, {name: "home"}
                目 论.Notifications
                @props.children
