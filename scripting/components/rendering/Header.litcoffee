#  `示.Header`  #

##  Usage  ##

>   ```jsx
>       <Header>
>           {/* content */}
>       </Header>
>   ```
>   Creates a `Header` component, which contains various user actions.

##  The Component  ##

The `Header` is just a simple functional React component.

    示.Header = (props) ->
        目 'header', {id: "laboratory-header"},
            props.children
