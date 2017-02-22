#  `动.Composer`  #

##  Usage  ##

>   ```javascript
>       //  Fires when the composer window should be displayed.
>       Composer.Request()
>   ```

##  Object Initialization  ##

    此 = 动.Composer = {}

##  Events  ##

###  `Composer.Request`:

The `Composer.Request` event doesn't have any properties.

    此.Request = 动.newBuilder "LaboratoryComposerRequest"

###  `Composer.Post`:

The `Composer.Request` event doesn't have any properties.

    此.Post = 动.newBuilder "LaboratoryComposerPost",
        text: ""
        message: null
        makePublic: false
        makeListed: false
        makeNSFW: true

##  Object Freezing  ##

    冻 此
