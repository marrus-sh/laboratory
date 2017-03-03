#  TIMELINE HANDLERS  #

    Handlers.Timeline = Object.freeze

##  `LaboratoryTimelineRequested`  ##

We have two things that we need to do when timeline is requested: query the server for its information, and hold onto the callback requesting access.
We do this here.

        Requested: handle Events.Timeline.Requested, (event) ->

            callback = null unless typeof (callback = event.detail.callback) is "function"

The name of the timeline doesn't directly correspond to the API URL we use to access it, so we derive that here.

            name = String event.detail.name
            url = @auth.api + switch
                when name is "global" then "/timelines/public"
                when name is "community" then "/timelines/public?local=true"
                when name is "home" then "/timelines/home"
                when name.substr(0, 8) is "hashtag/" then "/timelines/tag/" + name.substr(8)
                when name.substr(0, 5) is "user/" then "/accounts/" + name.substr(5) + "/statuses"
                when name is "notifications" then "/notifications"
                else name

If we want to adjust the slice of time our timeline is taken from, we can do that now.

            url += (if name isnt community then "?" else "&") + "max_id=" + event.detail.before if event.detail.before?
            url += (if name isnt community and not event.detail.before? then "?" else "&") + "since_id=" + event.detail.since if event.detail.since?

The `interfaces.timelines` object will store our timeline callbacks, organized by name.
We need to create an array to store our callback in if one doesn't already exist:

            Object.defineProperty @interfaces.timelines, name, {value: [], enumerable: yes} unless @interfaces.timelines[name] instanceof Array

We can now add our callback.

            @interfaces.timelines[name].push event.detail.callback if event.detail.callback?

Next, we send the request.
Upon completion, it should trigger an `LaboratoryTimelineReceived` event so that we can handle the data.

            serverRequest "GET", url, null, @auth.accessToken, Events.Timeline.Received, {name}

            return

###  `LaboratoryTimelineReceived`

When an timeline's data is received, we need to send an update to any callbacks which might be using it.

        Received: handle Events.Timeline.Received, (event) ->

            name = String event.detail.params.name
            return unless (data = event.detail.data) instanceof Array

If there aren't any callbacks depending on our data, then we do nothing.

            return unless @interfaces.timelines[name]?.length

If we don't have a place to stick our data yet, let's create it:

            Object.defineProperty @timelines, name, {value: Object.seal {posts: {}, postOrder: []}, enumerable: yes} unless (@timelines[name] instanceof Object) and (@timelines[name].posts instanceof Object) and (@timelines[name].postOrder instanceof Array)

We want to merge our timeline data with any existing data in our timelines and then provide our components with the result.

            posts = {}
            postOrder = []

We load the new information first because it will have the most recent data.
If an item has an id but not an account, then we take this to signify that the post has been deleted.
We also fire an `LaboratoryAccountReceived` event containing the account data we received with the post.

            receivedAccounts = []

            for item in data
                continue unless item.id
                unless item.account?
                    posts[id] = null
                    continue
                unless item.id in postOrder
                    post = if item.type is "follow" then new Follow(item, @accounts) else new Post item, @accounts
                    postOrder.push item.id
                    posts[item.id] = post
                unless item.account.id in receivedAccounts
                    receivedAccounts.push post.account.id
                    Events.Account.Received {data: post.account}
                unless not item.status? or item.status.account.id in receivedAccounts
                    receivedAccounts.push item.status.account.id
                    Events.Account.Received {data: item.status.account}
                unless not item.reblog? or item.reblog.account.id in receivedAccounts
                    receivedAccounts.push item.reblog.account.id
                    Events.Account.Received {data: item.reblog.account}

Then we load any previously-existing posts if they haven't already been loaded.

            for id in @timelines[name].postOrder when not (id of posts)
                posts[id] = @timelines[name].posts[id]
                postOrder.push(id)

We can now sort our post order and save our data, giving our timeline callbacks the end result.

            postOrder.sort (a, b) -> b - a

            @timelines[name].postOrder = Object.freeze postOrder
            @timelines[name].posts = Object.freeze posts

            response = Object.freeze {posts, postOrder}
            callback response for callback in @interfaces.timelines[name]

            return

##  `Timeline.Removed`  ##

`Timeline.Removed` has a much simpler handler than our previous two:
We just look for the provided callback, and remove it from our timeline interface.
Then, if there are no remaining timelines for that `name` (as is probable), we go ahead and get rid of that information to conserve memory.

        Removed: handle Events.Timeline.Removed, (event) ->

Of course, if we don't have any callbacks assigned to the provided name, we can't do anything.

            return unless @interfaces.timelines[name = String event.detail.name]?.length and typeof (callback = event.detail.callback) is "function"

This iterates over our callbacks until we find the right one, and removes it from the array.

            index = 0;
            index++ until @interfaces.timelines[name][index] is callback or index >= @interfaces.timelines[name].length
            @interfaces.timelines[name].splice index, 1

If we no longer have any callbacks assigned to the timeline, we re-initialize it in our store:

            return unless @timelines[name] instanceof Object
            unless @interfaces.timelines[name].length
                @timelines[name].posts = Object.freeze {}
                @timelines[name].postOrder = Object.freeze []

…And we're done!

            return
