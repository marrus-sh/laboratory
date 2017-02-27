#  `Laboratory.Events.Store`  #

##  Usage  ##

>   ```javascript
>       //  Fires when the laboratory store is created:
>       Store.Up()
>   ```

##  Object Initialization  ##

    current = Laboratory.Events.Store = {}

##  Events  ##

###  `Store.Up`:

The `Store.Up` event doesn't have any associated data—it's just a simple event.

    current.Up = Laboratory.Events.newBuilder 'LaboratoryStoreUp'

##  Object Freezing  ##

    Object.freeze current
