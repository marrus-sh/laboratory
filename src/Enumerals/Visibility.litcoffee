#  VISIBILITY ENUMERALS  #

This file provides enumerals for post visibility.
The options are as follows:

| Enumeral | Numeric Value | Description |
| :------: | :-----------: | :---------- |
| `Laboratory.Visibility.PRIVATE` | `0x00` | The post cannot be reblogged and appears as unlisted |
| `Laboratory.Visibility.UNLISTED` | `0x01` | The post is unlisted but can be reblogged |
| `Laboratory.Visibility.UNREBLOGGABLE` | `0x02` | The post can be reblogged but is unlisted |
| `Laboratory.Visibility.PUBLIC` | `0x03` | The post is listed and can be reblogged |

However, `Laboratory.Visibility.UNREBLOGGABLE` (`0x02`) is not a valid visibility for a Mastodon post.
(The valid visibilities evaluate to `0x00`, `0x01`, and `0x03`, repsectively.)

Note that the visibility of the post can be evaluating using bitwise comparisons:

|  Flag  |          Meaning          |
| :----: | ------------------------- |
| `0x01` | The post can be reblogged |
| `0x02` | The post is listed        |

##  Implementation  ##

    Enumerals.Visibility = generateEnumerals
        PRIVATE: 0x00
        UNLISTED: 0x01
        UNREBLOGGABLE: 0x02
        PUBLIC: 0x03
        REQUESTED: 0x04
        REQUESTED_MUTUALS: 0x05
        BLOCKING: 0x08
        SELF: 0x10
        UNKNOWN: 0x20
