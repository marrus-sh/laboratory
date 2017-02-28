#  `Laboratory.Events.Composer`  #

##  Usage  ##

>   ```javascript
>       //  Fires when the composer window should be displayed.
>       Composer.Request()
>       //  Fires when a media attachment is added.
>       Composer.Upload({file: …})
>       //  Fires when a status should be sent.
>       Composer.Post({text: …, message: …, makePublic: …, makeListed: …, makeNSFW: …})
>   ```

##  Object Initialization  ##

    Laboratory.Events.Composer = {}

##  Events  ##

###  `Composer.Request`:

The `Composer.Request` event doesn't have any properties.

    Laboratory.Events.Composer.Request = Laboratory.Events.newBuilder "LaboratoryComposerRequest"

###  `Composer.Upload`:

The `Composer.Upload` event has one property: the `file` to upload.

    Laboratory.Events.Composer.Upload = Laboratory.Events.newBuilder 'LaboratoryComposerUpload',
        file: null

###  `Composer.Post`:

The `Composer.Post` event has several properties: the `text` of the status to post; its associated `message`, if any; and whether to `makePublic`, `makeListed`, or `makeNSFW`.

    Laboratory.Events.Composer.Post = Laboratory.Events.newBuilder "LaboratoryComposerPost",
        text: ""
        message: null
        makePublic: false
        makeListed: false
        makeNSFW: true

##  Object Freezing  ##

    Object.freeze Laboratory.Events.Composer