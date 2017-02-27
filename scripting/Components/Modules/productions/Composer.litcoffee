#  `Laboratory.Components.Modules.productions.Composer`  #

##  Usage  ##

>   ```jsx
>       <Composer
>           maxChars=React.PropTypes.number.isRequired
>           myAcct=React.PropTypes.object.isRequired
>           visible=React.PropTypes.boolean
>           defaultPrivacy=React.PropTypes.string
>       />
>   ```
>   Creates a `Composer` component, which allows a user to compose a post. The accepted properties are:
>   -   **`maxChars` [REQUIRED `number`] :**
>       The maximum number of characters allowed in a post. closed.
>   -   **`myAcct` [REQUIRED `object`] :**
>       The account object for the currently signed-in user.
>   -   **`visible` [OPTIONAL `boolean`] :**
>       Whether or not to show the composer
>   -   **`defaultPrivacy` [OPTIONAL `string`] :**
>       Should be one of {`"public"`, `"private"`, `"unlisted"`}, and effectively defaults to `"unlisted"` if not provided.

##  The Component  ##

The `Composer` class creates our post composition module, which is a surprisingly complex task.

    Laboratory.Components.Modules.productions.Composer = React.createClass

        propTypes:
            maxChars: React.PropTypes.number.isRequired
            myAcct: React.PropTypes.object.isRequired
            defaultPrivacy: React.PropTypes.string
            visible: React.PropTypes.bool

###  Our state:

Here you can see our initial state variables—we have quite a lot of them, as this component manages the extensive compose form.
You will note that `text` is initialized to `\n`—in order to function properly, a line break must always be the last thing it produces.

        getInitialState: ->
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
                    彁 Laboratory.Components.Shared.parts.IDCard, {account: @props.myAcct}
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
                            placeholder: "Message…"
                            value: @state.message
                            ref: (ref) => @input.message = ref
                            onChange: @handleEvent
