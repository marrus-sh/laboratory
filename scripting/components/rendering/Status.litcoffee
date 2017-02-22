#  `示.Status`  #

##  Usage  ##

>   ```jsx
>       <Status>
>           {/*  contents  */}
>       </Status>
>   ```
>   Creates a `Status` component, which contains a post or a notification.

##  The Component  ##

The `Status` component is just a simple functional React component, which loads an `<article>` containing the status.

    示.Status = (props) ->
        目 'article', null,
            props.children
