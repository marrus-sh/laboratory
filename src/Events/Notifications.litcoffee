#  `Laboratory.Events.Notifications`  #

##  Usage  ##

>   ```javascript
>       //  Fires when a new timeline is requested:
>       Notifications.Requested({component: …, before: …, since: …})
>       //  Fires when a timeline is received:
>       Notifications.Received({data: …, prev: …, next: …})
>       //  Fires when a feed of notifications is removed:
>       Notifications.Removed({component: …})
>       //  Fires when a new Notifications is created:
>       Notifications.ItemLoaded({payload: …})
>   ```
>   - **`payload` :** The content of the Notifications.
>   - **`component` :** A Notifications feed.
>   - **`before` :** Only show posts younger than this ID.
>   - **`since` :** Only show posts older than this ID.
>   - **`data` :** The JSON timeline data.
>   - **`prev` :** The url for the previous page of the request.
>   - **`next` :** The url for the next page of the request.

##  Object Initialization  ##

    Laboratory.Events.Notifications = {}

##  Events  ##

###  `Notifications.Requested`:

The `Notifications.Requested` event has one property: the `component` that it will be rendered in.

    Laboratory.Events.Notifications.Requested = Laboratory.Events.newBuilder 'LaboratoryNotificationsRequested',
        component: null

###  `Notifications.Received`:

The `Notifications.Received` event has one property: the `component` that it will be rendered in.

    Laboratory.Events.Notifications.Received = Laboratory.Events.newBuilder 'LaboratoryNotificationsReceived',
        data: null
        prev: null
        next: null

###  `Notifications.Removed`:

The `Notifications.Removed` event has one property: the `component` that was removed.

    Laboratory.Events.Notifications.Removed = Laboratory.Events.newBuilder 'LaboratoryNotificationsRemoved',
        component: null

###  `Notifications.ItemLoaded`:

The `Notifications.ItemLoaded` event has one property: the `payload` it was issued with.

    Laboratory.Events.Notifications.ItemLoaded = Laboratory.Events.newBuilder 'LaboratoryNotificationsItemLoaded',
        payload: null

##  Object Freezing  ##

    Object.freeze Laboratory.Events.Notifications
