#  `/scripting/events/LaboratoryStore`  #

##  Usage  ##

>   ```javascript
>       //  Fires when the laboratory store is created:
>       LaboratoryStoreUp()
>   ```

##  Imports  ##

The `getEventBuilder` function is used to create new event constructors.

    `import getEventBuilder from '../scripts/getEventBuilder'`

##  Events  ##

###  `LaboratoryStoreUp`:

The `LaboratoryStoreUp` event doesn't have any associated data—it's just a simple event.

    LaboratoryStoreUp = getEventBuilder 'LaboratoryStoreUp'

##  Exports  ##

This package simply exports the `LaboratoryStoreUp` event.

    `export {LaboratoryStoreUp}`
