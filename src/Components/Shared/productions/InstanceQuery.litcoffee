#  `Laboratory.Components.Shared.productions.InstanceQuery`  #

##  Usage  ##

>   ```jsx
>       <InstanceQuery
>           locale=React.PropTypes.string.isRequired
>       />
>   ```
>   Creates a simple text input for requesting a user's home instance.

##  The Component  ##

`InstanceQuery` is just a simple React component class.

    Laboratory.Components.Shared.productions.InstanceQuery = React.createClass

        mixins: [ReactPureRenderMixin]

        propTypes:
            locale: React.PropTypes.string.isRequired

        getInitialState: ->
            value: ""

        handleEvent: (event) ->
            if event.type is "change" and event.target is @input then @setState {value: @input.value}
            else if event.type is "keypress" and event.target is @input and (event.key is "Enter" or event.code is "Enter" or event.keyCode is 0x0D) and @input.value.length and @input.validity.valid
                Laboratory.Events.Authentication.Requested {url: "https://" + @input.value, window: window.open "about:blank", "LaboratoryOAuth"}
                @setState {value: ""}
            return

        input: null

###  Rendering:

        render: ->

…And here's what we render:

            return 彁 ReactIntl.IntlProvider, {locale: @props.locale, messages: Laboratory.Locales.getL10n(@props.locale)},
                彁 "div", {id: "laboratory-instancequery"},
                    彁 ReactIntl.FormattedMessage,
                        id: "instancequery.queryinstance"
                        defaultMessage: "What's your instance?"
                    彁 "div", {id: "laboratory-instancequeryinput"},
                        彁 "code", {className: "laboratory-username"}, "username@"
                        彁 "input",
                            type: "text"
                            pattern: "[0-9A-Za-z\-\.]+(\:[0-9]{1,4})?"
                            placeholder: "example.com"
                            value: @state.value
                            ref: (ref) => @input = ref
                            onChange: @handleEvent
                            onKeyPress: @handleEvent
