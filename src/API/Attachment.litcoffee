<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.5.0</i> <br> <code>API/Attachment.litcoffee</code></p>

#  ATTACHMENT REQUESTS  #

 - - -

##  Description  ##

The __Attachment__ module of the Laboratory API is comprised of those requests which are related to Mastodon media attachments.

###  Quick reference:

####  Requests.

| Request | Description |
| :------ | :---------- |
| `Attachment.Request()` | Requests a media attachment from the Mastodon server. |

###  Requesting an attachment:

>   ```javascript
>   request = new Laboratory.Attachment.Request(data);
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
>   //  Suppose `myAttachment` is a `File`.
>   var request = new Laboratory.Attachment.Request({
>       file: myAttachment
>   });
>   request.assign(requestCallback);
>   request.start();
>   ```

###  Using the result of an Attachment request:

>   ```javascript
>   function requestCallback(event) {
>       useAttachment(event.response);
>   }
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

Our first order of business is checking that we were provided a `File` and that `FormData` is supported on our platform.
If not, that's a `TypeError`.

                unless this and this instanceof AttachmentRequest
                    throw new TypeError "this is not an AttachmentRequest"
                unless typeof File is "function" and (file = data.file) instanceof File
                    throw new TypeError "Unable to create attachment; none provided"
                unless typeof FormData is "function"
                    throw new TypeError "Unable to create attachment; `FormData` not supported"

We create a new `form` and add the `file` to it.
This will be directly uploaded to the server during the request.

                form = new FormData
                form.append "file", file

Here we create the request.

                Request.call this, "POST", Store.auth.origin + "/api/v1/media", form,
                    Store.auth.accessToken, (result) =>
                        dispatch "LaboratoryAttachmentReceived", decree =>
                            @response = police -> new Attachment result

                Object.freeze this

Our `Attachment.Request.prototype` just inherits from `Request`.

            Object.defineProperty AttachmentRequest, "prototype",
                configurable: no
                enumerable: no
                writable: no
                value: Object.freeze Object.create Request.prototype,
                    constructor:
                        enumerable: no
                        value: AttachmentRequest

            return AttachmentRequest
