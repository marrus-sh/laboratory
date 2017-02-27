#  `Laboratory.Components.Columns.productions.Go`  #

##  Usage  ##

>   ```jsx
>       <Go
>           myID=React.PropTypes.number.isRequired
>           footerLinks=React.PropTypes.object
>       />
>   ```
>   Creates a `Column` component which contains a menu of useful tasks. The accepted properties are:
>   -   **`myID` [OPTIONAL `number`] :**
>       The ID of the currently signed-in user.
>   -   **`footerLinks` [OPTIONAL `object`] :**
>       An object whose enumerable own properties provide links to display in the footer.

##  The Component  ##

The `Go` component is just a simple functional React component, which loads a `Column` with helpful links.

    Laboratory.Components.Columns.productions.Go = (props) ->
        彁 Laboratory.Components.Columns.parts.Column, {id: "laboratory-go"},
            彁 Laboratory.Components.Columns.parts.Heading, {icon: "arrow-right"},
                彁 ReactIntl.FormattedMessage,
                    id: "go.heading"
                    defaultMessage: "let's GO!"
            彁 "nav", {className: "laboratory-columnnav"},
                彁 Laboratory.Components.Columns.parts.GoLink, {to: "/user/" + props.myID, icon: "list-alt"},
                    彁 ReactIntl.FormattedMessage,
                        id: 'go.profile'
                        defaultMessage: "Profile"
                彁 Laboratory.Components.Columns.parts.GoLink, {to: "/community", icon: "users"},
                    彁 ReactIntl.FormattedMessage,
                        id: 'go.community'
                        defaultMessage: "Community"
                彁 Laboratory.Components.Columns.parts.GoLink, {to: "/global", icon: "link"},
                    彁 ReactIntl.FormattedMessage,
                        id: 'go.global'
                        defaultMessage: "Global"
            彁 "footer", {className: "laboratory-columnfooter"},
                彁 "nav", null,
                    (彁 "a", {href: value, target: "_self"}, key for key, value of (if props.footerLinks? then props.footerLinks else {}))...

    Laboratory.Components.Columns.productions.Go.propTypes =
        footerLinks: React.PropTypes.object
        myID: React.PropTypes.number.isRequired
