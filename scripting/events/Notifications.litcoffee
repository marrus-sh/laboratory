#  `Laboratory.Events.Notifications`  #

##  Usage  ##

>   ```javascript
>       //  Fires when a new Notifications is created:
>       Notifications.ItemLoaded({payload: …})
>       //  Fires when a feed of notifications is requested:
>       Notifications.Requested({component: …})
>       //  Fires when a feed of notifications is removed:
>       Notifications.Removed({component: …})
>   ```
>   - **`payload` :** The content of the Notifications.
>   - **`component` :** A Notifications feed.

##  Object Initialization  ##

    current = Laboratory.Events.Notifications = {}

##  Events  ##

###  `Notifications.ItemLoaded`:

The `Notifications.ItemLoaded` event has one property: the `payload` it was issued with.

    current.ItemLoaded = Laboratory.Events.newBuilder 'LaboratoryNotificationsItemLoaded',
        payload: null

###  `Notifications.Requested`:

The `Notifications.Requested` event has one property: the `component` that it will be rendered in.

    current.Requested = Laboratory.Events.newBuilder 'LaboratoryNotificationsRequested',
        component: null

###  `Notifications.Removed`:

The `Notifications.Removed` event has one property: the `component` that was removed.

    current.Removed = Laboratory.Events.newBuilder 'LaboratoryNotificationsRemoved',
        component: null

##  Object Freezing  ##

    Object.freeze current
