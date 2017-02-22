#  `示.Button`  #

##  Usage  ##

>   ```jsx
>       <Button
>           getRef=React.propTypes.func
>       >
>           {/*  content  */}
>       </Button>
>   ```
>   Creates a `Button` component, which renders a button. Some of the accepted properties are:
>   -   **`getRef` [OPTIONAL `function`] :**
>       A callback which receives a reference to the button's `<button>` element.

##  The Component  ##

The `Button` component is just a simple React component which displays a button.
It passes its properties to the `<span>` element it creates.

    示.Button = React.createClass

        propTypes:
            getRef: React.PropTypes.func

        componentDidMount: -> @props.getRef(@button) if @props.getRef

        render: ->
            output_props =
                className: "laboratory-button"
                ref: (ref) => @button = ref
            for own key, val of @props
                if key is "className" then output_props[key] += val
                else if ["getRef", "ref"].indexOf(key) is -1 then output_props[key] = val
            目 "button", output_props,
                @props.children
