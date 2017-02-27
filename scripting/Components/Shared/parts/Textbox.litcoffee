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

            caret: 0

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
