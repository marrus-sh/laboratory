#  `Laboratory.Components.UI.parts.Title`  #

##  Usage  ##

>   ```jsx
>       <Title>
>           {/* content */}
>       </Title>
>   ```
>   Creates a `Title` component, which links back to the homepage.

##  The Component  ##

The `Title` is just a simple functional React component.

    Laboratory.Components.UI.parts.Title = (props) ->
        彁 'h1', null,
            彁 ReactRouter.Link, {to: "/"},
                props.children
