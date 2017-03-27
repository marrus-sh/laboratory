<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.3.1</i> <br> <code>API/Attachment.litcoffee</code></p>

#  ATTACHMENT EVENTS  #

 - - -

##  Description  ##

The __Attachment__ module of the Laboratory API is comprised of those events which are related to Mastodon media attachments.

###  Quick reference:

| Event | Description |
| :---- | :---------- |
| `LaboratoryAttachmentRequested` | Requests an `Attachment` from the Mastodon server |
| `LaboratoryAttachmentReceived` | Fires when an `Attachment` has been processed |
| `LaboratoryAttachmentFailed` | Fires when an `Attachment` fails to process |

###  Requesting an attachment:

>   - __API equivalent :__ `/api/v1/media`
>   - __Request parameters :__
>       - __`file` :__ The file to upload
>   - __Request :__ `LaboratoryAttachmentRequested`
>   - __Response :__ `LaboratoryAttachmentReceived`
>   - __Failure :__ `LaboratoryAttachmentFailed`

Laboratory Attachment events are used to upload files to the server and receive media `Attachment`s which can then be linked to posts.
The only relevant parameter is `file`, which should be the `File` to upload.

 - - -

##  Implementation  ##

###  Creating the events:

Here we create the events as per our specifications.

    LaboratoryEvent
        .create "LaboratoryAttachmentRequested",
            file: undefined
        .create "LaboratoryAttachmentReceived", Attachment
        .create "LaboratoryAttachmentFailed", Failure
        .associate "LaboratoryAttachmentRequested", "LaboratoryAttachmentReceived", "LaboratoryAttachmentFailed"

###  Handling the events:

Laboratory provides handlers for the following Authorization events:

- `LaboratoryAttachmentRequested`

####  `LaboratoryAttachmentRequested`.

The `LaboratoryAttachmentRequested` event uploads a file to the Mastodon API and turns the response into an `Attachment`.

        .handle "LaboratoryAttachmentRequested", (event) ->

            unless File? and (file = event.detail.file) instanceof File
                dispatch "LaboratoryAttachmentFailed", new Failure "Unable to create attachment; none provided", "LaboratoryAttachmentRequested"
                return
            unless FormData?
                dispatch "LaboratoryAttachmentFailed", new Failure "Unable to create attachment; `FormData` is not supported on this platform"

            onComplete = (response, data, params) ->
                dispatch "LaboratoryAttachmentReceived", new Attachment response
                return

            onError = (response, data, params) ->
                dispatch "LaboratoryAttachmentFailed", new Failure response.error, "LaboratoryAttachmentRequested", params.status
                return

            serverRequest "POST", Store.auth.origin + "/api/v1/media", (
                form = new FormData
                form.append "file", file
                form
            ), Store.auth.accessToken, onComplete, onError

            return
