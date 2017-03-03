#  COMPOSER HANDLERS  #

    Handlers.Composer = Object.freeze

##  `LaboratoryComposerUploadRequested`  ##

The `LaboratoryComposerUploadRequested` handler simply uploads the provided file to the server.

        UploadRequested: handle Events.Composer.UploadRequested, (event) ->

            return unless (file = event.detail.file) instanceof File

            form = new FormData()
            form.append "file", file
            serverRequest "POST", @auth.api + "/media", form, @auth.accessToken, Events.Composer.UploadReceived

            return

##  `LaboratoryComposerUploadReceived`  ##

The `LaboratoryComposerUploadReceived` handler calls any registered composer callbacks with the `MediaAttachment` sent from the server as its response.

        UploadReceived: handle Events.Composer.UploadReceived, (event) ->
            callback new MediaAttachment event.detail.data for callback in @interfaces.composer
            return

##  `LaboratoryComposerRequested`  ##

The `LaboratoryComposerRequested` handler registers a callback with the composer if it hasn't been already.

        Requested: handle Events.Composer.Requested, (event) ->

            callback = null unless typeof (callback = event.detail.callback) is "function"
            @interfaces.composer.push callback unless not callback? or callback in @interfaces.composer

            return

##  `LaboratoryComposerPost`  ##

The `LaboratoryComposerPost` handler posts the given status, with the provided settings.

        Requested: handle Events.Composer.Requested, (event) ->
            form = new FormData()
            form.append "status", String event.detail.text
            form.append "in_reply_to_id", String Number event.detail.inReplyTo if isFinite event.detail.inReplyTo
            if event.detail.mediaAttachments instanceof Array
                form.append "media_ids[]", String Number attachment for attachment, index in event.detail.mediaAttachments when isFinite attachment
            form.append "sensitive", "true" if event.detail.makeNSFW
            form.append "spoiler_text", String event.detail.message if event.detail.message
            form.append "visibility", switch
                when not event.detail.makePublic then "private"
                when not event.detail.makeListed then "unlisted"
                else "public"
            serverRequest "POST", @auth.api + "/statuses", form, @auth.accessToken, Events.Status.Received

            return

##  `LaboratoryComposerRemoved`  ##

The `LaboratoryComposerRemoved` handler removes a callback from the composer.

        Requested: handle Events.Composer.Requested, (event) ->

            index = 0;
            index++ until @interfaces.composer[index] is callback or index >= @interfaces.composer.length
            @interfaces.composer.splice index, 1

            return
