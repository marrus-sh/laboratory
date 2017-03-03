#  POST TYPE ENUMERALS  #

This file provides enumerals for various post types.
The options are as follows:

| Enumeral | Numeric Value | Description |
| :------: | :-----------: | :---------- |
| `Laboratory.PostType.UNKNOWN` | `0x00` | The post type cannot be determined |
| `Laboratory.PostType.STATUS` | `0x01` | The post is an status |
| `Laboratory.PostType.NOTIFICATION` | `0x02` | The post is a notification |

##  Implementation  ##

    Enumerals.PostType = generateEnumerals
        UNKNOWN: 0x00
        STATUS: 0x01
        NOTIFICATION: 0x02
