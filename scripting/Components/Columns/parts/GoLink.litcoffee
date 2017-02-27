#  `Laboratory.Components.Columns.parts.GoLink`  #

##  Usage  ##

>   ```jsx
>       <GoLink
>           to=React.PropTypes.string.required
>           icon=React.PropTypes.string.required
>       />
>           {/* content */}
>       </GoLink>
>   ```
>   Creates a `Column` component which contains a menu of useful tasks. The accepted properties are:
>   -   **`to` [REQUIRED `string`] :**
>       Where the link is going to.
>   -   **`icon` [REQUIRED `string`] :**
>       The icon associated with the link.

##  The Component  ##

The `GoLink` component is a simple functional React component which just packages a `Link` with an icon.

    Laboratory.Components.Columns.parts.GoLink = (props) ->
        彁 ReactRouter.Link, {to: props.to, "aria-hidden": true},
            彁 "i", {className: "fa fa-fw fa-" + props.icon}
                props.children

    Laboratory.Components.Columns.parts.GoLink.propTypes =
        to: React.PropTypes.string.isRequired
        icon: React.PropTypes.string.isRequired
