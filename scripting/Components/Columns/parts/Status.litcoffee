#  `Laboratory.Components.Columns.parts.Status`  #

##  Usage  ##

>   ```jsx
>       <Status
>           id=React.PropTypes.number.isRequired
>           url=React.PropTypes.string.isRequired
>           account=React.PropTypes.object.isRequired
>           in_reply_to_id=React.PropTypes.number
>           content=React.PropTypes.string.isRequired
>           created_at=React.PropTypes.string.isRequired
>           reblogged=React.PropTypes.bool
>           favourited=React.PropTypes.bool
>           sensitive=React.PropTypes.bool
>           spoiler_text=React.PropTypes.string
>           visibility=React.PropTypes.string
>           media_attachments=React.PropTypes.array
>           mentions=React.PropTypes.array
>       />
>   ```
>   Creates a `Status` component, which contains a post or a notification. The accepted properties are:
>   -   **`id` [REQUIRED `number`] :**
>       The id of the status.
>   -   **`url` [REQUIRED `string`] :**
>       A URL at which the status may be viewed.
>   -   **`account` [REQUIRED `object`] :**
>       The account which posted the status.
>   -   **`in_reply_to_id` [OPTIONAL `number`] :**
>       The id of the status this status is replying to.
>   -   **`content` [REQUIRED `string`] :**
>       The content of the status.
>   -   **`created_at` [REQUIRED `string`] :**
>       The time the status was created.
>   -   **`reblogged` [OPTIONAL `boolean`] :**
>       Whether or not the user has reblogged this status.
>   -   **`favourited` [OPTIONAL `boolean`] :**
>       Whether or not the user has favourited this status.
>   -   **`sensitive` [OPTIONAL `boolean`] :**
>       Whether or not this status contains sensitive media.
>   -   **`spoiler_text` [OPTIONAL `string`] :**
>       Spoiler text to display over the status.
>   -   **`visibility` [OPTIONAL `string`] :**
>       The visibility of the status.
>   -   **`media_attachments` [OPTIONAL `array`] :**
>       An array of media attachments.
>   -   **`mentions` [OPTIONAL `array`] :**
>       An array of mentions.
>   -   **`reblogged_by` [OPTIONAL `array`] :**
>       The account which reblogged this status.
>   -   **`favourited_by` [OPTIONAL `array`] :**
>       The account which favourited this status.

##  The Component  ##

The `Status` component is a fairly involved React component, which loads an `<article>` containing the status and allowing the user to interact with it.

    Laboratory.Components.Columns.parts.Status = React.createClass

        propTypes:
            id: React.PropTypes.number.isRequired
            url: React.PropTypes.string.isRequired
            account: React.PropTypes.object.isRequired
            in_reply_to_id: React.PropTypes.number
            content: React.PropTypes.string.isRequired
            created_at: React.PropTypes.string.isRequired
            reblogged: React.PropTypes.bool
            favourited: React.PropTypes.bool
            sensitive: React.PropTypes.bool
            spoiler_text: React.PropTypes.string
            visibility: React.PropTypes.string
            media_attachments: React.PropTypes.array
            mentions: React.PropTypes.array
            reblogged_by: React.PropTypes.object
            favourited_by: React.PropTypes.object

Our function `getListOfMentions()` gets the list of people mentioned in the post, although this is only shown if the post is a reply.
We follow the Chicago convention of using "et al." if there are more than three accounts.

        getListOfMentions: -> switch @props.mentions.length
            when 1 then [
                彁 ReactRouter.Link, {className: "laboratory-displayname", to: "/user/" + @props.mentions[0].id}, @props.mentions[0].display_name
            ]
            when 2 then [
                彁 ReactRouter.Link, {className: "laboratory-displayname", to: "/user/" + @props.mentions[0].id}, @props.mentions[0].display_name
                彁 ReactIntl.FormattedMessage,
                    id: "status.and"
                    message: "and"
                彁 ReactRouter.Link, {className: "laboratory-displayname", to: "/user/" + @props.mentions[1].id}, @props.mentions[1].display_name
            ]
            when 3 then [
                彁 ReactRouter.Link, {className: "laboratory-displayname", to: "/user/" + @props.mentions[0].id}, @props.mentions[0].display_name
                ","
                彁 ReactRouter.Link, {className: "laboratory-displayname", to: "/user/" + @props.mentions[1].id}, @props.mentions[1].display_name
                彁 ReactIntl.FormattedMessage,
                    id: "status.and"
                    message: "and"
                彁 ReactRouter.Link, {className: "laboratory-displayname", to: "/user/" + @props.mentions[2].id}, @props.mentions[2].display_name
            ]
            else [
                彁 ReactRouter.Link, {className: "laboratory-displayname", to: "/user/" + @props.mentions[0].id}, @props.mentions[0].display_name
                彁 ReactIntl.FormattedMessage,
                    id: "status.etal"
                    message: "et al."
            ]

        render: ->
            彁 "article", {className: "laboratory-status" + (if @props.favourited then " laboratory-status--highlighted" else "")},
                if @props.reblogged_by? or @props.favourited_by? or @props.in_reply_to_id? then 彁 "aside", null,
                    (switch
                        when @props.in_reply_to_id? and @props.reblogged_by? then [
                            彁 ReactRouter.Link, {className: "laboratory-displayname", to: "/user/" + @props.reblogged_by.id}, @props.reblogged_by.display_name
                            (if @props.mentions?.length then [
                                彁 ReactIntl.FormattedMessage,
                                    id: "status.boostedthisreplyto"
                                    message: "boosted this reply to"
                                @getListOfMentions()...
                            ]
                            else [
                                彁 ReactIntl.FormattedMessage,
                                    id: "status.boostedthisreply"
                                    message: "boosted this reply"
                            ])...
                        ]
                        when @props.reblogged_by? then [
                            彁 ReactRouter.Link, {className: "laboratory-displayname", to: "/user/" + @props.reblogged_by.id}, @props.reblogged_by.display_name
                            彁 ReactIntl.FormattedMessage,
                                id: "status.boostedthispost"
                                message: "boosted this post"
                        ]
                        when @props.favourited_by? then [
                            彁 ReactRouter.Link, {className: "laboratory-displayname", to: "/user/" + @props.favourited_by.id}, @props.favourited_by.display_name
                            彁 ReactIntl.FormattedMessage,
                                id: "status.highlightedthispost"
                                message: "highlighted this post"
                        ]
                        when @props.in_reply_to_id? then [
                            彁 ReactIntl.FormattedMessage,
                                id: "status.inreplyto"
                                message: "In reply to"
                            @getListOfMentions()...
                        ]
                    )...
                else null
                彁 "header", null,
                    彁 Laboratory.Components.Shared.parts.IDCard,
                        account: @props.account
                    彁 ReactIntl.FormattedRelative, {value: Date.parse(@props.created_at)},
                        (formattedDate) => 彁 "time", {dateTime: @props.created_at, title: @props.created_at}, formattedDate
                彁 "div",
                    className: "laboratory-statusContent"
                    dangerouslySetInnerHTML:
                        __html: @props.content
                彁 "footer", null,
                    彁 Laboratory.Components.Shared.parts.Button,
                        className: "laboratory-button--minimal"
                        containerClass: "laboratory-replybutton"
                        icon: "reply"
                        label: 彁 ReactIntl.FormattedMessage,
                            id: "status.reply"
                            defaultMessage: "Reply"
                    if @props.favourited
                        彁 Laboratory.Components.Shared.parts.Button,
                            className: "laboratory-button--minimal"
                            containerClass: "laboratory-unhighlightbutton"
                            icon: "eraser"
                            label: 彁 ReactIntl.FormattedMessage,
                                id: "status.unhighlight"
                                defaultMessage: "Unhighlight"
                    else
                        彁 Laboratory.Components.Shared.parts.Button,
                            className: "laboratory-button--minimal"
                            containerClass: "laboratory-highlightbutton"
                            icon: "pencil"
                            label: 彁 ReactIntl.FormattedMessage,
                                id: "status.highlight"
                                defaultMessage: "Highlight"
                    if @props.reblogged
                        彁 Laboratory.Components.Shared.parts.Button,
                            className: "laboratory-button--minimal"
                            containerClass: "laboratory-unboostbutton"
                            icon: "minus-square"
                            label: 彁 ReactIntl.FormattedMessage,
                                id: "status.unboost"
                                defaultMessage: "Unboost"
                    else if @props.visibility isnt "private"
                        彁 Laboratory.Components.Shared.parts.Button,
                            className: "laboratory-button--minimal"
                            containerClass: "laboratory-boostbutton"
                            icon: "plus-square"
                            label: 彁 ReactIntl.FormattedMessage,
                                id: "status.boost"
                                defaultMessage: "Boost"
                    else
                        彁 Laboratory.Components.Shared.parts.Button,
                            className: "laboratory-button--minimal"
                            containerClass: "laboratory-noboostbutton"
                            icon: "square-o"
                            disabled: true
                            label: 彁 ReactIntl.FormattedMessage,
                                id: "status.noboost"
                                defaultMessage: "Private"
