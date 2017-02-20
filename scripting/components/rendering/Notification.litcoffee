#  `示.Notification`  #

##  Usage  ##

>   ```jsx
>       <Notification
>           data=React.PropTypes.object.isRequired
>       />
>   ```
>   Creates a `Notification` component, which contains a notification. The accepted properties are:
>   -   **`data` [REQUIRED `string`] :**
>       The data of the notification.

##  The Component  ##

Each `Notification` only has one property, an object specifying the `data` of the notification.

    示.Notification = React.createClass

        propTypes:
            name: React.PropTypes.object.isRequired

###  Rendering:

        render: ->
            目 'article', {className: "laboratory-notification"}
