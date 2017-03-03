#  MEDIA TYPE ENUMERALS  #

This file provides enumerals for various media types.
The options are as follows:

| Enumeral | Numeric Value | Description |
| :------: | :-----------: | :---------- |
| `Laboratory.MediaType.UNKNOWN` | `0x00` | The media type cannot be determined |
| `Laboratory.MediaType.PHOTO` | `0x01` | The media is a photo |
| `Laboratory.MediaType.VIDEO` | `0x02` | The media is a video |

##  Implementation  ##

    Enumerals.MediaType = generateEnumerals
        UNKNOWN: 0x00
        PHOTO: 0x01
        VIDEO: 0x02
