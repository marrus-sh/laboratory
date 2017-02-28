#  `Laboratory.Components.Shared.parts.Icon`  #

##  Usage  ##

>   ```jsx
>       <Icon
>           name=React.PropTypes.string.isRequired
>       />
>   ```
>   Creates an `Icon` component, which provides a fontawesome icon.

##  The Component  ##

The `Icon` is just a simple functional React component.

    Laboratory.Components.Shared.parts.Icon = (props) ->
        彁 'i',
            className: "fa fa-fw fa-" + props.name
            "aria-hidden": true

    Laboratory.Components.Shared.parts.Icon.propTypes =
        name: React.PropTypes.string.isRequired
