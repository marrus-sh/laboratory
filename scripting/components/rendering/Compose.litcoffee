#  `示.Compose`  #

##  Usage  ##

>   ```jsx
>       <Compose />
>   ```
>   Creates a `Compose` component, which renders a button to bring up a compose dialog:

##  The Component  ##

`Compose` doesn't have any properties.

    示.Compose = React.createClass

###  Event handling:

Here we will trigger the compose dialog by listening for a click:

        handleEvent: (e) ->
            switch e.type
                when "click" then 动.Composer.Request()

###  Rendering:

        render: ->
            目 'button', {id: "laboratory-composebutton", "aria-labelledby": "laboratory-composelabel", onClick: @handleEvent},
                    目 'i', {className: "fa fa-pencil-square-o", "aria-hidden": ""}
