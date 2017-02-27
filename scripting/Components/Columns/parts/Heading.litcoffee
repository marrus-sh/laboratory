#  `Laboratory.Components.Columns.parts.Heading`  #

##  Usage  ##

>   ```jsx
>       <Heading
>           icon=React.PropTypes.string
>       >
>           {/* content */}
>       </Heading>
>   ```
>   Creates a `Heading` component, which is just the heading to a `Column`. The accepted properties are:
>   -   **`icon` [REQUIRED `string`] :**
>       The icon to associate with the heading.

##  The Component  ##

The `Heading` is just a simple functional React component.

    Laboratory.Components.Columns.parts.Heading = (props) ->
        彁 'h2', {className: "laboratory-heading"},
            (if props.icon then [彁('i', {className: "fa fa-fw fa-" + props.icon, "aria-hidden": true}), props.children] else [props.children])...

    Laboratory.Components.Columns.parts.Heading.propTypes =
        icon: React.PropTypes.string
