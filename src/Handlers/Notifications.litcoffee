#  `Laboratory.Handlers.Notifications`  #

##  Coverage  ##

**The following events from `Notifications` have handlers:**

- `Notifications.Requested`
- `Notifications.Received`
- `Notifications.Removed`

**The following events from `Notifications` do *not* have handlers:**

- `Notifications.ItemLoaded`

##  Object Initialization  ##

    Laboratory.Handlers.Notifications = {}

##  Handlers  ##

###  `Notifications.Requested`

We have two things that we need to do when notifications are requested: query the server for their information, and hold onto the component requesting access.
We hold those here.

    Laboratory.Handlers.Notifications.Requested = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Notifications.Requested.type

        url = @auth.api + "/notifications"

If we want to adjust the slice of time our notifications are taken from, we can do that now.

        url += "?max_id=" + event.detail.before if event.detail.before?
        url += (if event.detail.before? then "&" else "?") + "since_id=" + event.detail.since if event.detail.since?

The `interfaces.notifications` object will store our notifications components.

        @interfaces.notifications.push event.detail.component if event.detail.component?

Next, we send the request.
Upon completion, it should trigger an `Notifications.Received` event so that we can handle the data.

        Laboratory.Functions.requestFromAPI url, @auth.accessToken, Laboratory.Events.Notifications.Received

        return

    Laboratory.Handlers.Notifications.Requested.type = Laboratory.Events.Notifications.Requested.type
    Object.freeze Laboratory.Handlers.Notifications.Requested

###  `Notifications.Received`

When notification data is received, we need to update its information in any components which might be using it.

    Laboratory.Handlers.Notifications.Received = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Notifications.Received.type

If there aren't any notifications components to update, then we do nothing.

        return unless @interfaces.notifications.length

We'll let `attributes` store the various attributes expected from the JSON response, so we can easily iterate over them.

        attributes = [
            "id"
            "url"
            "in_reply_to_id"
            "content"
            "created_at"
            "reblogged"
            "favourited"
            "sensitive"
            "spoiler_text"
            "visibility"
        ]

The notification `data` lives in `event.detail.data`.
We want to merge this with any existing data in our notifications and then provide our components with the result.

        items = {}
        itemOrder = []

We load the new information first because it will have the most Laboratory.Handlers.Notifications data.
You'll note we copy the notification information into a new object, which attempts to fetch the notification's parent account on request.
We also fire an `Account.Received` event containing the account data we received with the post.
(This event *should* be handled by the time the post is displayed.)

        receivedAccounts = []

        for item in event.detail.data
            items[item.id] = do (item, receivedAccounts) =>
                computedItem = {}
                if item.type isnt "follow"
                    computedItem[attribute] = item.status[attribute] for attribute in attributes
                    computedItem.media_attachments = Object.freeze (Object.freeze {url: attachment.url, preview_url: attachment.preview_url, type: attachment.type} for attachment in item.status.media_attachments)
                    computedItem.mentions = Object.freeze (Object.freeze {url: mention.url, acct: mention.acct, id: mention.id, username: mention.username} for mention in item.status.mentions)
                    if item.type isnt "mention" then Object.defineProperty computedItem,
                        switch item.type
                            when "reblog" then "reblogged_by"
                            when "favourite" then "favourited_by"
                        {
                            get: => return @accounts[item.account.id]
                            enumerable: true
                        }
                    Object.defineProperty computedItem, "account",
                        get: => return @accounts[item.status.account.id]
                        enumerable: true
                    if receivedAccounts.indexOf(item.status.account.id) is -1
                        Laboratory.Events.Account.Received {data: item.status.account}
                        receivedAccounts.push item.status.account.id
                else
                    computedItem.followed = true
                    Object.defineProperty computedItem, "account",
                        get: => return @accounts[item.account.id]
                        enumerable: true
                computedItem.id = item.id
                if receivedAccounts.indexOf(item.account.id) is -1
                    Laboratory.Events.Account.Received {data: item.account}
                    receivedAccounts.push item.account.id

                return Object.freeze computedItem

            itemOrder.push(item.id)

Then we load any previously-existing notifications if they haven't already been loaded.

        for id in @notifications.itemOrder when not items[id]?
            items[id] = @notifications.items[id]
            itemOrder.push(id)

We can now sort our notification order and save our data, giving our loaded notifications components the end result.

        itemOrder.sort (a, b) -> b - a

        @notifications.itemOrder = Object.freeze itemOrder
        @notifications.items = Object.freeze items

        notifications.setState {items, itemOrder} for notifications in @interfaces.notifications

        return

    Laboratory.Handlers.Notifications.Received.type = Laboratory.Events.Notifications.Received.type
    Object.freeze Laboratory.Handlers.Notifications.Received

##  `Notifications.Removed`  ##

`Notifications.Removed` has a much simpler handler than our previous two:
We just look for the provided component, and remove it from our notification interface.
Then, if there are no remaining components in our interface, we go ahead and get rid of our information to conserve memory.

    Laboratory.Handlers.Notifications.Removed = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Notifications.Removed.type

Of course, if we don't have any components assigned to the provided name, we can't do anything.

        return unless @interfaces.notifications?.length

This iterates over our components until we find the right one, and removes it from the array.

        index = 0;
        index++ until @interfaces.notifications[index] = event.detail.component or index >= @interfaces.notifications.length
        @interfaces.notifications.splice index, 1

If we no longer have any components assigned to our notifications, we re-initialize it in our store:

        unless @interfaces.notifications.length
            @notifications.items = Object.freeze {}
            @notifications.itemOrder = Object.freeze []

…And we're done!

        return

    Laboratory.Handlers.Notifications.Removed.type = Laboratory.Events.Notifications.Removed.type
    Object.freeze Laboratory.Handlers.Notifications.Removed

##  Object Freezing  ##

    Object.freeze Laboratory.Handlers.Notifications
