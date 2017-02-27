#  `Laboratory.Components.Shared.productions.Laboratory`  #

##  Usage  ##

>   ```jsx
>       <Laboratory
>           accessToken=React.PropTypes.string.isRequired
>           locale=React.PropTypes.string.isRequired
>           myAcct=React.PropTypes.object.isRequired
>           title=React.PropTypes.string
>           links=React.PropTypes.object
>           routerBase=React.PropTypes.string
>           maxChars=React.PropTypes.number
>           defaultPrivacy=React.PropTypes.string
>       />
>   ```
>   Creates a `Laboratory` component, which acts as a container for the entire frontend. The accepted properties are:
>   -   **`accessToken` [REQUIRED `string`] :**
>       The access token for the application.
>   -   **`locale` [REQUIRED `string`] :**
>       The locale in which to render the application.
>   -   **`myAcct` [REQUIRED `object`] :**
>       The account object for the currently signed-in user.
>   -   **`title` [OPTIONAL `string`] :**
>       The title of the application.
>       Defaults to `window.location.hostname`.
>   -   **`links` [OPTIONAL `object`] :**
>       An object whose enumerable own properties give links to other areas of the site.
>   -   **`routerBase` [OPTIONAL `string`] :**
>       The base URL to use with the React router. Defaults to '/web'.
>   -   **`maxChars` [OPTIONAL `string`] :**
>       The maximum number of characters to allow in a post. Defaults to 500.
>   -   **`defaultPrivacy` [OPTIONAL `string`] :**
>       The default privacy setting. Defaults to "unlisted".

##  Imports  ##

Not really an import, but here's some convenience stuff for `react-router`.

    {Router, Route, IndexRoute, IndexRedirect} = ReactRouter
    none = -> null

This gives us access to our browser history:

    createBrowserHistory = require "history/lib/createBrowserHistory"

##  The Component  ##

`Laboratory` is just a React component class.
Here we define the initial properties, as above.

    Laboratory.Components.Shared.productions.Laboratory = React.createClass

        propTypes:
            accessToken: React.PropTypes.string.isRequired
            locale: React.PropTypes.string.isRequired
            myAcct: React.PropTypes.object.isRequired
            title: React.PropTypes.string
            links: React.PropTypes.object
            routerBase: React.PropTypes.string
            maxChars: React.PropTypes.number

        getDefaultProps: ->
            title: window.location.hostname
            routerBase: "/web"
            maxChars: 500
            defaultPrivacy: "unlisted"

        getInitialState: ->
            thirdColumn: 彁 Laboratory.Components.Columns.productions.Empty
            showComposer: false

###  Third column processing:

The component displayed in the third column varies as the user navigates around the site.
The function `setThirdColumn` allows us to manage this ourselves.

        setThirdColumn: (component, props) -> @setState {thirdColumn: 彁 component, props}

        getThirdColumn: -> @state.thirdColumn

###  Loading:

`componentWillMount` tells React what to do once our engine is about to load.

        componentWillMount: ->

This starts tracking our browser history for our router:

            @browserHistory = ReactRouter.useRouterHistory(createBrowserHistory) {basename: @props.routerBase}

We should also ask for permission to display desktop notifications:

            Notification.requestPermission if Notification?.permission is 'default'

####  Pre-caluclating routes.

The React router will issue a warning in the console if you try modifying its routes after the inital render.
This is a problem because every time our state changes, `render()` will re-create our arrow functions and React will interpret this as an attempted change.
By calculating our routes ahead of time, we avoid this problem.

            @routes = 彁 Route, {path: '/', component: (props) => 彁 Laboratory.Components.UI.productions.UI, {title: @props.title, maxChars: @props.maxChars, defaultPrivacy: @props.defaultPrivacy, getThirdColumn: @getThirdColumn, myAcct: @props.myAcct, showComposer: @state.showComposer}, props.children},

                #  Go:

                彁 IndexRoute, {onEnter: => @setThirdColumn Laboratory.Components.Columns.productions.Go, {footerLinks: @props.links, myID: @props.myAcct.id}}

                #  Start:

                彁 Route, {path: 'start', onEnter: => @setThirdColumn Laboratory.Components.Modules.productions.Start}

                #  Timelines:

                彁 Route, {path: 'global', onEnter: => @setThirdColumn Laboratory.Components.Columns.productions.Timeline, {name: 'global'}}
                彁 Route, {path: 'community', onEnter: => @setThirdColumn Laboratory.Components.Columns.productions.Timeline, {name: 'community'}}
                彁 Route, {path: 'hashtag/:id', onEnter: (nextState) => @setThirdColumn Laboratory.Components.Columns.productions.Timeline, {name: 'hashtag/' + nextState.params.id}}

                #  Statuses:

                彁 Route, {path: 'compose', onEnter: (=> @setState(showComposer: true)), onLeave: (=> @setState(showComposer: false))}
                彁 Route, {path: 'post/:id', component: Laboratory.Components.Modules.productions.Post}

                #  Accounts:

                彁 Route, {path: 'user/:id', component: (props) => 彁 Laboratory.Components.Modules.productions.Account, {id: Number(props.params.id), myID: @props.myAcct.id}}
                彁 Route, {path: 'user/:id/posts', onEnter: (nextState) => @setThirdColumn Laboratory.Components.Columns.productions.Timeline, {name: 'user/' + nextState.params.id}}

                #  Not found:

                彁 Route, {path: '*', onEnter: => @setThirdColumn Laboratory.Components.Columns.productions.NotFound}

            return

###  Unloading:

`componentWillUnmount` tells react what to do if our engine gets deleted.
All we really care about is closing our stream.

        componentWillUnmount: ->
            if @subscription?
                @subscription.close()
                @subscription = undefined
            return

###  Rendering:

OKAY OKAY TIME TO RENDER.
Let's go!

        render: ->

…And here's what we render:

            return 彁 ReactIntl.IntlProvider, {locale: @props.locale, messages: Laboratory.Locales.getL10n(@props.locale)},
                彁 Router, {history: @browserHistory},
                    @routes
