#  `Laboratory.Handlers.Timeline`  #

##  Coverage  ##

**The following events from `Timeline` have handlers:**

- `Timeline.Requested`
- `Timeline.Received`
- `Timeline.Removed`

**The following events from `Timeline` do *not* have handlers:**

- `Timeline.StatusLoaded`
- `Timeline.StatusDeleted`

##  Object Initialization  ##

    current = Laboratory.Handlers.Timeline = {}

##  For Convenience  ##

We'll let `attributes` store the various attributes expected from the JSON response, so we can easily iterate over them.

    attributes = [
        "id"
        "uri"
        "url"
        "in_reply_to_id"
        "content"
        "created_at"
        "reblogs_count"
        "favourites_count"
        "reblogged"
        "favourited"
        "sensitive"
        "spoiler_text"
        "visibility"
    ]

##  Handlers  ##

###  `Timeline.Requested`

We have two things that we need to do when timeline is requested: query the server for its information, and hold onto the component requesting access.
We hold those here.

    current.Requested = (event) ->

        return unless event? and this? and event.type is current.Requested.type

The name of the timeline doesn't directly correspond to the API URL we use to access it, so we derive that here.

        name = event.detail.name
        url = @meta.apiURL + switch
            when name is "global" then "timelines/public"
            when name is "community" then "timelines/public?local=true"
            when name is "home" then "timelines/home"
            when name.substr(0, 8) is "hashtag/" then "timelines/tag/" + name.substr(8)
            when name.substr(0, 5) is "user/" then "accounts/" + name.substr(5) + "/statuses"
            else name

If we want to adjust the slice of time our timeline is taken from, we can do that now.

        url += (if name isnt community then "?" else "&") + "max_id=" + event.detail.before if event.detail.before?
        url += (if name isnt community and not event.detail.before? then "?" else "&") + "since_id=" + event.detail.since if event.detail.since?

The `interfaces.timelines` object will store our timeline components, organized by the timeline urls.
We need to create an array to store our component in if one doesn't already exist:

        Object.defineProperty @interfaces.timelines, name, {value: [], enumerable: true} unless @interfaces.timelines[name] instanceof Array

We can now add our component.

        @interfaces.timelines[name].push event.detail.component if event.detail.component?

Next, we send the request.
Upon completion, it should trigger an `Timeline.Received` event so that we can handle the data.

        Laboratory.Functions.requestFromAPI url, @meta.accessToken, Laboratory.Events.Timeline.Received, {name}

        return

    current.Requested.type = Laboratory.Events.Timeline.Requested.type
    Object.freeze current.Requested

###  `Timeline.Received`

When an timeline's data is received, we need to update its information in any components which might be using it.

    current.Received = (event) ->

        return unless event? and this? and event.type is current.Received.type

        name = event.detail.params.name

If there aren't any timelines to update, then we do nothing.

        return unless @interfaces.timelines[name] instanceof Array

If we don't have a place to stick our data yet, let's create it:

        Object.defineProperty @timelines, name, {value: Object.seal {posts: {}, postOrder: []}, enumerable: true} unless (@timelines[name] instanceof Object) and (@timelines[name].posts instanceof Object) and (@timelines[name].postOrder instanceof Array)

The timeline `data` lives in `event.detail.data`.
We want to merge this with any existing data in our timelines and then provide our components with the result.

        posts = {}
        postOrder = []

We load the new information first because it will have the most current data.
You'll note we copy the post information into a new object, which attempts to fetch post's parent account on request.
We also fire an `Account.Received` event containing the account data we received with the post.
(This event *should* be handled by the time the post is displayed.)

        receivedAccounts = []

        for post in event.detail.data
            posts[post.id] = do (post, receivedAccounts) =>
                computedPost = {}
                sourcePost = if post.reblog? then post.reblog else post
                computedPost[attribute] = sourcePost[attribute] for attribute in attributes
                computedPost.media_attachments = Object.freeze (Object.freeze {url: attachment.url, preview_url: attachment.preview_url, type: attachment.type} for attachment in sourcePost.media_attachments)
                computedPost.mentions = Object.freeze (Object.freeze {url: mention.url, acct: mention.acct, id: mention.id} for mention in sourcePost.mentions)
                computedPost.application = Object.freeze {name: sourcePost.application.name, website: sourcePost.application.website}
                Object.defineProperty computedPost, "account",
                    get: => return @accounts[sourcePost.account.id]
                    enumerable: true
                if receivedAccounts.indexOf(sourcePost.account.id) is -1
                    Laboratory.Events.Account.Received sourcePost.account
                    receivedAccounts.push sourcePost.account.id
                if post.reblog?
                    computedPost.id = post.id
                    Object.defineProperty computedPost, "reblogged_by",
                        get: => return @accounts[post.account.id]
                        enumerable: true
                    if receivedAccounts.indexOf(post.account.id) is -1
                        Laboratory.Events.Account.Received post.account
                        receivedAccounts.push post.account.id
                return Object.freeze computedPost

            postOrder.push(post.id)

Then we load any previously-existing posts if they haven't already been loaded.

        for id in @timelines[name].postOrder when not posts[id]?
            posts[id] = @timelines[name].posts[id]
            postOrder.push(id)

We can now sort our post order and save our data, giving our loaded timeline components the end result.

        postOrder.sort (a, b) -> b - a

        @timelines[name].postOrder = Object.freeze postOrder
        @timelines[name].posts = Object.freeze posts

        timeline.setState {posts, postOrder} for timeline in @interfaces.timelines[name]

        return

    current.Received.type = Laboratory.Events.Timeline.Received.type
    Object.freeze current.Received

##  `Timeline.Removed`  ##

`Timeline.Removed` has a much simpler handler than our previous two:
We just look for the provided component, and remove it from our timeline interface.
Then, if there are no remaining timelines for that `name` (as is probable), we go ahead and get rid of our information to conserve memory.

    current.Removed = (event) ->

        return unless event? and this? and event.type is current.Removed.type

Of course, if we don't have any components assigned to the provided name, we can't do anything.

        return unless @interfaces.timelines[event.detail.name] instanceof Array

This iterates over our components until we find the right one, and removes it from the array.

        index = 0;
        index++ until @interfaces.timelines[event.detail.name][index] = event.detail.component or index >= @interfaces.timelines[event.detail.name].length
        @interfaces.timelines[event.detail.name].splice index, 1

If we no longer have any components assigned to the timeline, we re-initialize it in our store:

        return unless @timelines[event.detail.name] instanceof Object
        @timelines[event.detail.name].posts = Object.freeze {}
        @timelines[event.detail.name].postOrder = Object.freeze []

…And we're done!

        return

    current.Removed.type = Laboratory.Events.Timeline.Removed.type
    Object.freeze current.Removed

##  Object Freezing  ##

    Object.freeze current
