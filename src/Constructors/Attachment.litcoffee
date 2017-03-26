#  THE ATTACHMENT CONSTRUCTOR  #

##  Introduction  ##

The `Attachment()` constructor creates a unique, read-only object which represents an attached piece of media sent through the Mastodon API.
Its properties are summarized below, alongside their Mastodon API equivalents:

| Property  | API Response  | Description |
| :-------: | :-----------: | :---------- |
|   `id`    |     `id`      | The id of the media attachment |
|  `href`   |     `url`     | The url of the media attachment |
| `preview` | `preview_url` | The url of a preview for the media attachment |
|  `type`   |    `type`     | An `Attachment.Type` |

###  Media types:

The possible `Attachment.Type`s are as follows:

| Enumeral | Binary Value | Description |
| :------: | :----------: | :---------- |
| `Attachment.Type.UNKNOWN` | `00` | The media type cannot be determined |
| `Attachment.Type.PHOTO` | `01` | The media is a photo |
| `Attachment.Type.VIDEO` | `10` | The media is a video |
| `Attachment.Type.GIFV` | `11` | The media is a gif-video |

##  Implementation  ##

###  The constructor:

The `Attachment()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.

    Laboratory.Attachment = Attachment = (data) ->

        throw new Error "Laboratory Error : `Attachment()` must be called as a constructor" unless this and this instanceof Attachment
        throw new Error "Laboratory Error : `Attachment()` was called without any `data`" unless data?

        @id = Number data.id
        @href = String data.url
        @preview = String data.preview_url
        @type = switch data.type
            when "image" then Attachment.Type.IMAGE
            when "video" then Attachment.Type.VIDEO
            when "gifv" then Attachment.Type.GIFV
            else Attachment.Type.UNKNOWN

        return Object.freeze this

###  The prototype:

The `Attachment` prototype just inherits from `Object`.

    Object.defineProperty Attachment, "prototype",
        value: Object.freeze {}

###  Defining media types:

Here we define our `Attachment.Type`s, as described above:

    Attachment.Type = Enumeral.generate
        UNKNOWN : 0b00
        PHOTO   : 0b01
        VIDEO   : 0b10
        GIFV    : 0b11
