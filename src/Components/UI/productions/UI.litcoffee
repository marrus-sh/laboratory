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
