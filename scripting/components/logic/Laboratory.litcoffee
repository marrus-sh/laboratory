#  `论.Laboratory`  #

##  Usage  ##

>   ```jsx
>       <Laboratory
>           accessToken=React.PropTypes.string.isRequired
>           locale=React.PropTypes.string.isRequired
>           myacct=React.PropTypes.number.isRequired
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
>   -   **`myacct` [REQUIRED `number`] :**
>       The user id for the currently signed-in user.
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

    论.Laboratory = React.createClass

        propTypes:
            accessToken: React.PropTypes.string.isRequired
            locale: React.PropTypes.string.isRequired
            myacct: React.PropTypes.number.isRequired
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
            thirdColumn: 目 示.Empty
            showComposer: false

###  Third column processing:

The component displayed in the third column varies as the user navigates around the site.
The function `setThirdColumn` allows us to manage this ourselves.

        setThirdColumn: (component, props) -> @setState {thirdColumn: 目 component, props}

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

            @routes = 目 Route, {path: '/', component: (props) => 目 示.UI, {title: @props.title, maxChars: @props.maxChars, defaultPrivacy: @props.defaultPrivacy, getThirdColumn: @getThirdColumn, showComposer: @state.showComposer}, props.children},

                #  Go:

                目 IndexRoute, {onEnter: => @setThirdColumn 示.Go, {footerLinks: @props.links, myacct: @props.myacct}}

                #  Start:

                目 Route, {path: 'start', onEnter: => @setThirdColumn 论.Start}

                #  Timelines:

                目 Route, {path: 'global', onEnter: => @setThirdColumn 论.Timeline, {name: 'global'}}
                目 Route, {path: 'community', onEnter: => @setThirdColumn 论.Timeline, {name: 'community'}}
                目 Route, {path: 'hashtag/:id', onEnter: (nextState) => @setThirdColumn 论.Timeline, {name: 'hashtag/' + nextState.params.id}}

                #  Statuses:

                目 Route, {path: 'compose', onEnter: (=> @setState(showComposer: true)), onLeave: (=> @setState(showComposer: false))}
                目 Route, {path: 'post/:id', component: 论.Post}

                #  Accounts:

                目 Route, {path: 'user/:id', component: 论.Account}
                目 Route, {path: 'user/:id/posts', onEnter: (nextState) => @setThirdColumn 论.Timeline, {name: 'user/' + nextState.params.id}}

                #  Not found:

                目 Route, {path: '*', onEnter: => @setThirdColumn 示.NotFound}

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

            return 目 ReactIntl.IntlProvider, {locale: @props.locale, messages: 研.locales.getL10n(@props.locale)},
                目 Router, {history: @browserHistory},
                    @routes
