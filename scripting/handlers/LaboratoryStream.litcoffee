#  `scripting/handlers/LaboratoryStream`  #

##  Coverage  ##

**The following events from `LaboratoryStream` have handlers:**

- `LaboratoryMessage`

**The following events from `LaboratoryStream` do *not* have handlers:**

- `LaboratoryOpen`
- `LaboratoryClose`
- `LaboratoryError`

##  Imports  ##

A lot of what we're going to be doing when handling `LaboratoryStream` events is forwarding stream data data to other events/handlers.
We import these here:

    `import {
        LaboratoryStatusLoaded,
        LaboratoryStatusDeleted
    } from LaboratoryTimeline;
    import {
        Laboratory
    } from LaboratoryNotification;`

##  Handlers  ##

###  `LaboratoryMessageHandler`

The Mastodon API sends a number of different messages, distinguished by the `event` property on the message data.
These are:

-   **`"update"` :**
    A new post has been made.

-   **`"delete"` :**
    An old post has been deleted.

-   **`"notification"` :**
    A notification has been triggered.

We'll simply forward the message onto the appropriate handler by creating a new event for each of these situations.

    LaboratoryMessageHandler = (event, store) ->

        return unless event? and store? and event.type = LaboratoryMessageHandler.forType

        switch event.detail.data.type

The `LaboratoryStatusLoaded` event will handle any new posts which have been made.

            when "update" then document.dispatchEvent LaboratoryStatusLoaded
                fromStream: event.detail.stream
                payload: JSON.parse event.detail.data.payload

The `LaboratoryStatusDeleted` event will handle any old posts which have been deleted.

            when "delete" then document.dispatchEvent LaboratoryStatusDeleted
                fromStream: event.detail.stream
                payload: JSON.parse event.detail.data.payload

The `LaboratoryNotificationLoaded` event will handle any new notifications which have appeared.
We don't need to specify the stream here because notifications are only sent to `"user"`.

            when "notification" then document.dispatchEvent LaboratoryNotificationLoaded
                payload: JSON.parse event.detail.data.payload

    Object.defineProperty LaboratoryMessageHandler, "forType", {value: "LaboratoryMessage"}

##  Exports  ##

This package exports the handlers listed above.

    `export {
        LaboratoryMessageHandler
    };`
