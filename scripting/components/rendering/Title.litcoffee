#  `示.Title`  #

##  Usage  ##

>   ```jsx
>       <Title>
>           {/* content */}
>       </Title>
>   ```
>   Creates a `Title` component, which links back to the homepage.

##  The Component  ##

The `Title` is just a simple functional React component.

    示.Title = (props) ->
        目 'h1', null,
            目 'a', {href: "/", target: "_self"},
                props.children
