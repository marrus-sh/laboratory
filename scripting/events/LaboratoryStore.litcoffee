#  `研.events.LaboratoryStore`  #

##  Usage  ##

>   ```javascript
>       //  Fires when the laboratory store is created:
>       LaboratoryStore.StoreUp()
>   ```

##  Object Initialization  ##

    此 = 研.events.LaboratoryStore = {}

##  Events  ##

###  `LaboratoryStore.StoreUp`:

The `LaboratoryStore.StoreUp` event doesn't have any associated data—it's just a simple event.

    此.StoreUp = getEventBuilder 'LaboratoryStoreUp'

##  Object Freezing  ##

Object.freeze 此
