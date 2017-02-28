#  `Laboratory.Components.Columns.parts.Column`  #

##  Usage  ##

>   ```jsx
>       <Column
>           id=React.PropTypes.string
>       >
>           {/* content */}
>       </Column>
>   ```
>   Creates a `Column` component, which contains a timeline or similar view.

##  The Component  ##

The `Column` is just a simple functional React component.

    Laboratory.Components.Columns.parts.Column = (props) ->
        彁 'div', (if props.id? then {id: props.id, className: "laboratory-column"} else {className: "laboratory-column"}),
            props.children
