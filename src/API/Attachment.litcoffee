<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.4.0</i> <br> <code>API/Attachment.litcoffee</code></p>

#  ATTACHMENT REQUESTS  #

 - - -

##  Description  ##

The __Attachment__ module of the Laboratory API is comprised of those requests which are related to Mastodon media attachments.

###  Quick reference:

####  Requests.

| Request | Description |
| :------ | :---------- |
| `Attachment.Request()` | Requests a media attachment from the Mastodon server. |

####  Events.

| Event | Description |
| :---- | :---------- |
| `LaboratoryAttachmentReceived` | Fires when an `Attachment` has been processed |

###  Requesting an attachment:

>   ```javascript
>       request = new Laboratory.Attachment.Request(data);
>   ```
>
>   - __API equivalent :__ `/api/v1/media`
>   - __Data parameters :__
>       - __`file` :__ The file to upload
>   - __Response :__ An [`Attachment`](../Constructors/Attachment.litcoffee)

Laboratory Attachment requests are used to upload files to the server and receive media `Attachment`s which can then be linked to posts.
The only relevant parameter is `file`, which should be the `File` to upload.

 - - -

##  Examples  ##

###  Uploading an attachment to the Mastodon server:

>   ```javascript
>       //  Suppose `myAttachment` is a `File`.
>       var request = new Laboratory.Attachment.Request({
>           file: myAttachment
>       });
>       request.addEventListener("response", requestCallback);
>       request.start();
>   ```

###  Using the result of an Attachment request:

>   ```javascript
>       function requestCallback(event) {
>           useAttachment(event.response);
>       }
>   ```

 - - -

##  Implementation  ##

###  Making the request:

    Object.defineProperty Attachment, "Request",
        configurable: no
        enumerable: yes
        writable: no
        value: do ->

            AttachmentRequest = (data) ->
        
                unless this and this instanceof AttachmentRequest
                    throw new TypeError "this is not an AttachmentRequest"
                unless typeof File is "function" and (file = data.file) instanceof File
                    throw new TypeError "Unable to create attachment; none provided"
                unless typeof FormData is "function"
                    throw new TypeError "Unable to create attachment; `FormData` not supported"

                form = new FormData
                form.append "file", file

                Request.call this, "POST", Store.auth.origin + "/api/v1/media", form,
                    Store.auth.accessToken, (result) =>
                        dispatch "LaboratoryAttachmentReceived", decree =>
                            @response = police -> new Attachment result

                Object.freeze this

            Object.defineProperty AttachmentRequest, "prototype",
                configurable: no
                enumerable: no
                writable: no
                value: Object.freeze Object.create Request.prototype,
                    constructor:
                        enumerable: no
                        value: AttachmentRequest

            return AttachmentRequest

###  Creating the events:

Here we create the events as per our specifications.

    LaboratoryEvent
        .create "LaboratoryAttachmentReceived", Attachment

###  Handling the events:

Laboratory Attachment events do not have handlers.
