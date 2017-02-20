#  `示.Heading`  #

##  Usage  ##

>   ```jsx
>       <Heading
>           icon=React.PropTypes.string.isRequired
>       >
>           {/* content */}
>       </Heading>
>   ```
>   Creates a `Heading` component, which is just the heading to a `Column`. The accepted properties are:
>   -   **`icon` [REQUIRED `string`] :**
>       The icon to associate with the heading.

##  The Component  ##

The `Heading` is just a simple functional React component.

    示.Heading = (props) ->
        目 'h2', {className: "laboratory-heading"},
            目 'i', {className: "fa fa-fw fa-" + props.icon, "aria-hidden": ""}
            props.children
