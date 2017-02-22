#  `示.Header`  #

##  Usage  ##

>   ```jsx
>       <Header
>           title=React.PropTypes.string
>       />
>   ```
>   Creates a `Header` component, which contains various user actions. The accepted properties are:
>   -   **`title` [OPTIONAL `string`] :**
>       The title of the site

##  The Component  ##

The `Header` is just a simple functional React component.

    示.Header = (props) ->
        目 'header', {id: "laboratory-header"},
            目 示.Title, null,
                props.title
            目 "label", null,
                目 ReactIntl.FormattedMessage,
                    id: "composer.compose"
                    defaultMessage: "Compose"
                目 ReactRouter.Link, {to: "/compose"},
                    目 示.Button, null,
                        目 'i', {className: "fa fa-pencil-square-o", "aria-hidden": true}

    示.Header.propTypes =
        title: React.PropTypes.string
