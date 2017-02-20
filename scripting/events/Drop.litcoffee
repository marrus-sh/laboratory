#  `动.Drop`  #

##  Usage  ##

>   ```javascript
>       //  Fires when something is dropped onto the UI.
>       Drop.New({payload: …})
>   ```
>   - **`file` :** The content of the drop.

##  Object Initialization  ##

    此 = 动.Drop = {}

##  Events  ##

###  `Drop.New`:

The `Drop.New` event has one property: the thing which was dropped.

    此.New = 动.newBuilder 'LaboratoryDropNew',
        file: null

##  Object Freezing  ##

    冻 此
