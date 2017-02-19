#  `研.handlers.LaboratoryStream`  #

##  Coverage  ##

**The following events from `LaboratoryStream` have handlers:**

- `LaboratoryStream.Message`

**The following events from `LaboratoryStream` do *not* have handlers:**

- `LaboratoryStream.Open`
- `LaboratoryStream.Close`
- `LaboratoryStream.Error`

##  Object Initialization  ##

    此 = 研.handlers.LaboratoryStream = {}

##  Handlers  ##

###  `LaboratoryStream.Message`

The Mastodon API sends a number of different messages, distinguished by the `event` property on the message data.
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

The `LaboratoryStatusLoaded` event will handle any new posts which have been made.

            when "update" then document.dispatchEvent 研.events.LaboratoryTimeline.StatusLoaded
                fromStream: event.detail.stream
                payload: JSON.parse event.detail.data.payload

The `LaboratoryStatusDeleted` event will handle any old posts which have been deleted.

            when "delete" then document.dispatchEvent 研.events.LaboratoryTimeline.StatusDeleted
                fromStream: event.detail.stream
                payload: JSON.parse event.detail.data.payload

The `LaboratoryNotificationLoaded` event will handle any new notifications which have appeared.
We don't need to specify the stream here because notifications are only sent to `"user"`.

            when "notification" then document.dispatchEvent 研.events.LaboratoryNotification.NotificationLoaded
                payload: JSON.parse event.detail.data.payload

    此.Message.type = 研.events.LaboratoryStream.Message.type
    Object.freeze 此.Message

##  Object Freezing  ##

    Object.freeze 此
