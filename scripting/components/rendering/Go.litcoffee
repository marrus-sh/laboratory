#  `示.Go`  #

##  Usage  ##

>   ```jsx
>       <Go
>           myacct=React.PropTypes.string.isRequired
>           footerLinks=React.PropTypes.object
>       />
>   ```
>   Creates a `Column` component which contains a menu of useful tasks. The accepted properties are:
>   -   **`footerLinks` [OPTIONAL `string`] :**
>       An object whose enumerable own properties provide links to display in the footer.

##  The Component  ##

The `Go` component is just a simple functional React component, which loads a `Column` with helpful links.

    示.Go = (props) ->
        目 示.Column, {id: "laboratory-go"},
            目 示.Heading, {icon: "arrow-right"},
                目 ReactIntl.FormattedMessage,
                    id: "go.heading"
                    defaultMessage: "let's GO!"
            目 "nav", {className: "laboratory-columnnav"},
                目 示.GoLink, {to: "/user/" + props.myacct, icon: "list-alt"},
                    目 ReactIntl.FormattedMessage,
                        id: 'go.profile'
                        defaultMessage: "Profile"
                目 示.GoLink, {to: "/community", icon: "users"},
                    目 ReactIntl.FormattedMessage,
                        id: 'go.community'
                        defaultMessage: "Community"
                目 示.GoLink, {to: "/global", icon: "link"},
                    目 ReactIntl.FormattedMessage,
                        id: 'go.global'
                        defaultMessage: "Global"
            目 "footer", {className: "laboratory-columnfooter"},
                目 "nav", null,
                    (目 "a", {href: value, target: "_self"}, key for key, value of (if props.footerLinks? then props.footerLinks else {}))...

    示.Go.propTypes =
        footerLinks: React.PropTypes.object
        myacct: React.PropTypes.number.isRequired
