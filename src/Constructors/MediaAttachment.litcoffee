#  THE MEDIA ATTACHMENT CONSTRUCTOR  #

The `MediaAttachment()` constructor creates a unique, read-only object which represents an attached piece of media sent through the Mastodon API.
Its properties are summarized below, alongside their Mastodon API equivalents:

| Property  | API Response  | Description |
| :-------: | :-----------: | :---------- |
|   `id`    |     `id`      | The id of the media attachment |
|  `href`   |     `url`     | The url of the media attachment |
| `preview` | `preview_url` | The url of a preview for the media attachment |
|  `type`   |    `type`     | A [`Laboratory.MediaType`](../Enumerals/MediaType.litcoffee) |

##  Implementation  ##

###  The constructor:

The `MediaAttachment()` constructor takes a `data` object from an API response and reads its attributes into an instance's properties.

    Constructors.MediaAttachment = (data) ->

        return unless this and (this instanceof Constructors.MediaAttachment) and data?

        @id = data.id
        @href = data.url
        @preview = data.preview_url
        @type = if data.type is "image" then Enumerals.MediaType.IMAGE else if data.type is "video" then Enumerals.MediaType.VIDEO else Enumerals.MediaType.UNKNOWN

        return Object.freeze this

###  The prototype:

The `MediaAttachment` prototype just inherits from `Object`.

    Object.defineProperty Constructors.MediaAttachment, "prototype",
        value: Object.freeze {}
