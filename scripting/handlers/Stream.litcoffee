#  `理.Stream`  #

##  Coverage  ##

**The following events from `Stream` have handlers:**

- `Stream.Message`

**The following events from `Stream` do *not* have handlers:**

- `Stream.Open`
- `Stream.Close`
- `Stream.Error`

##  Object Initialization  ##

    此 = 理.Stream = {}

##  Handlers  ##

###  `Stream.Message`

The Mastodon API sends a number of different messages, distinguished by the `type` property on the message data.
These are:

-   **`"update"` :**
    A new post has been made.

-   **`"delete"` :**
    An old post has been deleted.

-   **`"notification"` :**
    A notification has been triggered.

We'll simply forward the message onto the appropriate handler by creating a new event for each of these situations.

    此.Message = (event, store) ->

        return unless event? and store? and event.type is 此.Message.type

        switch event.detail.data.type

The `Timeline.StatusLoaded` event will handle any new posts which have been made.

            when "update" then 动.Timeline.StatusLoaded
                fromStream: event.detail.stream
                payload: JSON.parse event.detail.data.payload

The `Timeline.StatusDeleted` event will handle any old posts which have been deleted.

            when "delete" then 动.Timeline.StatusDeleted
                fromStream: event.detail.stream
                payload: JSON.parse event.detail.data.payload

The `Notifications.ItemLoaded` event will handle any new notifications which have appeared.
We don't need to specify the stream here because notifications are only sent to `"user"`.

            when "notification" then 动.Notifications.ItemLoaded
                payload: JSON.parse event.detail.data.payload

    此.Message.type = 动.Stream.Message.type
    冻 此.Message

##  Object Freezing  ##

    冻 此
