#  `Laboratory.Components.Shared.parts.IDCard`  #

##  Usage  ##

>   ```jsx
>       <IDCard
>           account=React.PropTypes.object.isRequired
>           externalLinks=React.PropTypes.bool
>       />
>   ```
>   Creates a `IDCard` component, which contains identification information for a status/post. The accepted properties are:
>   -   **`account` [REQUIRED `object`] :**
>       The account to identify.
>   -   **`externalLinks` [OPTIONAL `boolean`] :**
>       Whether to use internal or external links for the account page.

##  The Component  ##

The `IDCard` is just a simple functional React component.

    Laboratory.Components.Shared.parts.IDCard = (props) ->
        彁 'div', {className: "laboratory-idcard"},
            彁 'a', {href: props.account.avatar, target: "_blank"},
                彁 'img', {className: "laboratory-avatar", src: props.account.avatar, alt: props.account.display_name}
            彁 (if props.externalLinks then ["a", {href: props.account.url, title: props.account.display_name, target: "_blank"}] else [ReactRouter.Link, {to: "user/" + props.account.id, title: props.account.display_name}])...,
                彁 'b', {className: "laboratory-displayname"}, props.account.display_name
                彁 'code', {className: "laboratory-username"}, props.account.acct

    Laboratory.Components.Shared.parts.IDCard.propTypes =
        account: React.PropTypes.object.isRequired
        externalLinks: React.PropTypes.bool
