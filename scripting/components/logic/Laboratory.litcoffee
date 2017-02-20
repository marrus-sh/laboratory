#  `论.Laboratory`  #

##  Usage  ##

>   ```jsx
>       <Laboratory
>           accessToken=React.PropTypes.string.isRequired
>           locale=React.PropTypes.string.isRequired
>           title=React.PropTypes.string
>       />
>   ```
>   Creates a `Laboratory` component, which acts as a container for the entire frontend. The accepted properties are:
>   -   **`accessToken` [REQUIRED `string`] :**
>       The access token for the application.
>   -   **`locale` [REQUIRED `string`] :**
>       The locale in which to render the application.
>   -   **`title` [OPTIONAL `string`] :**
>       The title of the application.

##  Imports  ##

From React, we'll need a number of functions to route the right-hand column through the URL:

    {
        applyRouterMiddleware,
        useRouterHistory,
        Router,
        Route,
        IndexRedirect,
        IndexRoute
    } = require "react-router"
    {useScroll} = require "react-router-scroll"

This gives us access to our browser history:

    createBrowserHistory = require "history/lib/createBrowserHistory"

We also need internationalization for our react components:

    {IntlProvider} = require "react-intl"

##  Initial Steps  ##

###  Tracking browser history:

This starts tracking our browser history for our router:

    browserHistory = useRouterHistory(createBrowserHistory) {basename: '/web'}

##  The Component  ##

`Laboratory` is just a React component class.
Here we define the initial properties, as above.

    论.Laboratory = React.createClass

        propTypes:
            accessToken: React.PropTypes.string.isRequired
            locale: React.PropTypes.string.isRequired
            title: React.PropTypes.string

###  Loading:

`componentDidMount` tells React what to do once our engine is loaded.

        componentDidMount: ->

The only major task we have is to subscribe to our WebSocket stream.

            @subscription = 作.createStream @props.accessToken, 'user'

We should also ask for permission to display desktop notifications:

            Notification.requestPermission if Notification?.permission is 'default'

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

            return 目 IntlProvider, {locale: @props.locale, messages: 研.locales.getL10n(@props.locale)},
                目 Router, {history: browserHistory, render: applyRouterMiddleware(useScroll())},
                    目 Route, {path: '/', component: (props) => 目 示.UI, {title: @props.title}, props.children},

                        目 IndexRedirect, {to: '/start'}

                        目 Route, {path: '*', component: 示.NotFound}
    ###

                        目 Route, {path: 'getting-started', component: GettingStarted}
                        目 Route, {path: 'timelines/home', component: HomeTimeline}
                        目 Route, {path: 'timelines/public', component: PublicTimeline}
                        目 Route, {path: 'timelines/tag/:id', component: HashtagTimeline}

                        目 Route, {path: 'notifications', component: Notifications}
                        目 Route, {path: 'favourites', component: FavouritedStatuses}

                        目 Route, {path: 'statuses/new', component: Compose}
                        目 Route, {path: 'statuses/:statusId', component: Status}
                        目 Route, {path: 'statuses/:statusId/reblogs', component: Reblogs}
                        目 Route, {path: 'statuses/:statusId/favourites', component: Favourites}

                        目 Route, {path: 'accounts/:accountId', component: AccountTimeline}
                        目 Route, {path: 'accounts/:accountId/followers', component: Followers}
                        目 Route, {path: 'accounts/:accountId/following', component: Following}

                        目 Route, {path: 'follow_requests', component: FollowRequests}
                        目 Route, {path: 'blocks', component: Blocks}
                        目 Route, {path: 'report', component: Report}

    ###
