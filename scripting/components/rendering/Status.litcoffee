#  `示.Status`  #

##  Usage  ##

>   ```jsx
>       <Status
>           data=React.PropTypes.object.isRequired
>       />
>   ```
>   Creates a `Status` component, which contains a status post. The accepted properties are:
>   -   **`data` [REQUIRED `string`] :**
>       The data of the status.

##  The Component  ##

Each `Status` only has one property, an object specifying the `data` of the status.

    示.Status = React.createClass

        propTypes:
            name: React.PropTypes.object.isRequired

###  Rendering:

        render: ->
            目 'article', {className: "laboratory-status"}
