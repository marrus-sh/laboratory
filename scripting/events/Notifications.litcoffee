#  `动.Notifications`  #

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

    此 = 动.Notifications = {}

##  Events  ##

###  `Notifications.ItemLoaded`:

The `Notifications.ItemLoaded` event has one property: the `payload` it was issued with.

    此.ItemLoaded = 动.newBuilder 'LaboratoryNotificationsItemLoaded',
        payload: null

###  `Notifications.Requested`:

The `Notifications.Requested` event has one property: the `component` that it will be rendered in.

    此.Requested = 动.newBuilder 'LaboratoryNotificationsRequested',
        component: null

###  `Notifications.Removed`:

The `Notifications.Removed` event has one property: the `component` that was removed.

    此.Removed = 动.newBuilder 'LaboratoryNotificationsRemoved',
        component: null

##  Object Freezing  ##

    冻 此
