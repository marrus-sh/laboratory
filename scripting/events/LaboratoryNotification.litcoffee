#  `/scripting/events/LaboratoryNotification`  #

##  Usage  ##

>   ```javascript
>       //  Fires when a new notification is created:
>       LaboratoryStatusLoaded({payload: …})
>   ```
>   - **`payload` :** The content of the notification.

##  Imports  ##

The `getEventBuilder` function is used to create new event constructors.

    `import getEventBuilder from '../scripts/getEventBuilder'`

##  Events  ##

###  `LaboratoryNotificationLoaded`:

The `LaboratoryNotificationLoaded` event has two properties: the `stream` it was fired from, and the `payload` it was issued with.

    LaboratoryNotificationLoaded = getEventBuilder 'LaboratoryNotificationLoaded',
        payload: null

##  Exports  ##

This package exports the events listed above.

    `export {
        LaboratoryNotificationLoaded
    };`
