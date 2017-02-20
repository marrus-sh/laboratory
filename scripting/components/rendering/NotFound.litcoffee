#  `示.NotFound`  #

##  Usage  ##

>   ```jsx
>       <NotFound />
>   ```
>   Creates a `Column` component, which remarks that the content could not be found.

##  Imports  ##

We need to import `FormattedMessage` in order to properly internationalize our "not found" message.

    {FormattedMessage} = require "react-intl";

##  The Component  ##

The `NotFound` is just a simple functional React component, which loads a `Column` and remarks that the page could not be found.

    示.NotFound = (props) ->
        目 示.Column, {class: "laboratory-notfound"},
            目 示.Heading, {icon: "exclamation-triangle"},
                目 FormattedMessage,
                    id: 'notfound.not_found'
                    defaultMessage: "Not found"
