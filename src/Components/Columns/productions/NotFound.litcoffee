#  `Laboratory.Components.Columns.productions.NotFound`  #

##  Usage  ##

>   ```jsx
>       <NotFound />
>   ```
>   Creates a `Column` component, which remarks that the content could not be found.

##  The Component  ##

The `NotFound` component is just a simple functional React component, which loads a `Column` and remarks that the page could not be found.

    Laboratory.Components.Columns.productions.NotFound = ->
        彁 Laboratory.Components.Columns.parts.Column, {id: "laboratory-notfound"},
            彁 Laboratory.Components.Columns.parts.Heading, {icon: "exclamation-triangle"},
                彁 ReactIntl.FormattedMessage,
                    id: 'notfound.not_found'
                    defaultMessage: "Not found"
            彁 ReactIntl.FormattedMessage,
                id: 'notfound.not_found'
                defaultMessage: "Not found"
