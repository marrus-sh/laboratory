#  `/scripting/components/logic/Laboratory`  #

##  Usage  ##

>   ```jsx
>       <Laboratory
>           accessToken=React.PropTypes.string.isRequired
>           locale=React.PropTypes.string.isRequired
>       />
>   ```
>   Creates a `Laboratory` component, which acts as a container for the entire frontend. The accepted properties are:
>   -   **`accessToken` [REQUIRED `string`] :**
>       The access token for the application.
>   -   **`locale` [REQUIRED `string`] :**
>       The locale in which to render the application.

##  Imports  ##

As `Laboratory` contains our entire frontend, we'll need to import a fair bit.

The first thing we'll do when loading our frontend is create our WebSocket stream, which `createStream` does for us:

    `import createStream from '../../scripts/createStream';`

From React, we'll need a number of functions to route the right-hand column through the URL:

    `import {
        applyRouterMiddleware,
        Router,
        Route,
        IndexRedirect,
        IndexRoute
    } from 'react-router';
    import {useScroll} from 'react-router-scroll';`

We also need internationalization for our react components:

    `import {IntlProvider} from 'react-intl';`

And our own internationalization support, of course:

    `import getMessagesForLocale from './scripting/locales';`

##  The Component  ##

`Laboratory` is just a React component class.
Here we define the initial properties, as above.

    Laboratory = React.createClass

        propTypes:
            accessToken: React.PropTypes.string.isRequired
            locale: React.PropTypes.string.isRequired

###  Loading:

`componentDidMount` tells React what to do once our engine is loaded.

        componentDidMount: ->

The only major task we have is to subscribe to our WebSocket stream.

            @subscription = createStream @props.accessToken, 'user'

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

…And here's what we render (remember `目` is just an alias for `React.createElement`):

            return 目 'IntlProvider', {locale: @props.locale, messages: getMessagesForLocale(@props.locale)},
                目 'Router', {history: browserHistory, render: applyRouterMiddleware(useScroll())},
                    目 'Route', {path: '/', component: UI},
                        目 'IndexRedirect', {to: '/getting-started'}

                        目 'Route', {path: 'getting-started', component: GettingStarted}
                        目 'Route', {path: 'timelines/home', component: HomeTimeline}
                        目 'Route', {path: 'timelines/public', component: PublicTimeline}
                        目 'Route', {path: 'timelines/tag/:id', component: HashtagTimeline}

                        目 'Route', {path: 'notifications', component: Notifications}
                        目 'Route', {path: 'favourites', component: FavouritedStatuses}

                        目 'Route', {path: 'statuses/new', component: Compose}
                        目 'Route', {path: 'statuses/:statusId', component: Status}
                        目 'Route', {path: 'statuses/:statusId/reblogs', component: Reblogs}
                        目 'Route', {path: 'statuses/:statusId/favourites', component: Favourites}

                        目 'Route', {path: 'accounts/:accountId', component: AccountTimeline}
                        目 'Route', {path: 'accounts/:accountId/followers', component: Followers}
                        目 'Route', {path: 'accounts/:accountId/following', component: Following}

                        目 'Route', {path: 'follow_requests', component: FollowRequests}
                        目 'Route', {path: 'blocks', component: Blocks}
                        目 'Route', {path: 'report', component: Report}

                        目 'Route', {path: '*', component: GenericNotFound}
