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
                        彁 'i', {className: "fa fa-fw fa-" + @props.activeIcon, "aria-hidden": true}
                    彁 "div", {className: "laboratory-toggle-track-x"},
                        彁 'i', {className: "fa fa-fw fa-" + @props.inactiveIcon, "aria-hidden": true}
                    彁 "div", {className: "laboratory-toggle-thumb"}
                    彁 "input", output_props
                彁 "span", {className: "laboratory-toggle-label laboratory-toggle-label-on"}, @props.activeText
