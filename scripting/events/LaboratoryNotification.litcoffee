#  `研.events.LaboratoryNotification`  #

##  Usage  ##

>   ```javascript
>       //  Fires when a new notification is created:
>       LaboratoryNotification.NotificationLoaded({payload: …})
>   ```
>   - **`payload` :** The content of the notification.

##  Object Initialization  ##

    此 = 研.events.LaboratoryNotification = {}

##  Events  ##

###  `LaboratoryNotification.NotificationLoaded`:

The `LaboratoryNotification.NotificationLoaded` event has two properties: the `stream` it was fired from, and the `payload` it was issued with.

    此.NotificationLoaded = getEventBuilder 'LaboratoryNotificationLoaded',
        payload: null

##  Object Freezing  ##

    Object.freeze 此
