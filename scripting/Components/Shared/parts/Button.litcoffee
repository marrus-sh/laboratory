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
                    彁 "i", {className: "fa fa-fw fa-" + @props.icon, "aria-hidden": true}
