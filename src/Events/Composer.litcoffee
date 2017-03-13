#  COMPOSER EVENTS  #

    Events.Composer = Object.freeze

The __Composer__ module of Laboratory Events is comprised of those events which are related to composing and posting statuses.

| Event / Builder | Description |
| :-------------- | :---------- |
| `LaboratoryComposerUploadRequested` / `Laboratory.Composer.UploadRequested` | Fires when a media file should be sent to the server |
| `LaboratoryComposerUploadReceived` / `Laboratory.Composer.UploadReceived` | Fires when a media file has been received by the server |
| `LaboratoryComposerRequested` / `Laboratory.Composer.Requested` | Registers a composer callback function |
| `LaboratoryComposerPost` / `Laboratory.Composer.Post` | Fires when a post should be made to the server |
| `LaboratoryComposerRemoved` / `Laboratory.Composer.Removed` | Asks to remove a composer callback function |

##  `LaboratoryComposerUploadRequested`  ##

>   - __Builder :__ `Laboratory.Composer.UploadRequested`
>   - __Properties :__
>       - `file` – The file which should be uploaded.

        UploadRequested: new Constructors.LaboratoryEvent 'LaboratoryComposerUploadRequested',
            file: null

The `LaboratoryComposerUploadRequested` event sends a `file` to the Mastodon server for uploading.

##  `LaboratoryComposerUploadReceived`  ##

>   - __Builder :__ `Laboratory.Composer.UploadReceived`
>   - __Properties :__
>       - `data` – The response from the server.

        UploadReceived: new Constructors.LaboratoryEvent 'LaboratoryComposerUploadReceived',
            data: null

The `LaboratoryComposerUploadReceived` fires when an upload has been received by the Mastodon server, and its `data` contains the server's response.
The handler for `LaboratoryComposerUploadReceived` will call any composer callbacks with an immutable `Laboratory.MediaAttachment` object with the following properties:

| Property  | API Response  | Description |
| :-------: | :-----------: | :---------- |
|   `id`    |     `id`      | The id of the media attachment |
|  `href`   |     `url`     | The url of the media attachment |
| `preview` | `preview_url` | The url of a preview for the media attachment |
|  `type`   |    `type`     | Either `Laboratory.MediaType.PHOTO` (for a photo attachment) or `Laboratory.MediaType.VIDEO` (for a video attachment) |

##  `LaboratoryComposerRequested`:  ##

>   - __Builder :__ `Laboratory.Composer.Requested`
>   - __Properties :__
>       - `callback` – The callback to associate with the composer.

        Requested: new Constructors.LaboratoryEvent 'LaboratoryComposerRequested',
            file: null

The `LaboratoryComposerRequested` event requests an association between composer events and a provided `callback`.
This `callback` will receive media uploads from the handler for `LaboratoryComposerUploadReceived`; see the description of that event for more information.

##  `LaboratoryComposerPost`  ##

>   - __Builder :__ `Laboratory.Composer.Post`
>   - __Properties :__
>       - `text` – The text of the post.
>       - `inReplyTo` – The id of the post this post is replying to.
>       - `mediaAttachments` – An array of `Laboratory.MediaAttachment`s.
>       - `message` – A message to hide the post behind.
>       - `makePublic` – Whether to make the post public.
>       - `makeListed` – Whether to make the post listed.
>       - `makeNSFW` – Whether to mark the post's media as sensitive.

        Post: new Constructors.LaboratoryEvent "LaboratoryComposerPost",
            text: ""
            inReplyTo: null
            mediaAttachments: null
            message: null
            makePublic: false
            makeListed: false
            makeNSFW: true

The `LaboratoryComposerPost` event sends a post to the server.

##  `LaboratoryComposerRemove`  ##

>   - __Builder :__ `Laboratory.Composer.Remove`
>   - __Properties :__
>       - `callback` – The callback to disassociate from the composer.

        Remove: new Constructors.LaboratoryEvent 'LaboratoryComposerRemove',
            callback: null

The `LaboratoryComposerRemove` event requests that an association between composer events and the given `callback` be broken.
If no association has been made, the handler for this event does nothing.
