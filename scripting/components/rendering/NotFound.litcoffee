#  `示.NotFound`  #

##  Usage  ##

>   ```jsx
>       <NotFound />
>   ```
>   Creates a `Column` component, which remarks that the content could not be found.

##  The Component  ##

The `NotFound` component is just a simple functional React component, which loads a `Column` and remarks that the page could not be found.

    示.NotFound = ->
        目 示.Column, {id: "laboratory-notfound"},
            目 示.Heading, {icon: "exclamation-triangle"},
                目 ReactIntl.FormattedMessage,
                    id: 'notfound.not_found'
                    defaultMessage: "Not found"
            目 ReactIntl.FormattedMessage,
                id: 'notfound.not_found'
                defaultMessage: "Not found"
