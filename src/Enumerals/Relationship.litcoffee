#  RELATIONSHIP ENUMERALS  #

| Enumeral | Numeric Value | Description |
| :------: | :-----------: | :---------- |
| `Laboratory.Relationship.SELF` | `0x10` | The account is the user |
| `Laboratory.Relationship.FOLLOWING` | `0x02` | The account is being followed by the user |
| `Laboratory.Relationship.FOLLOWED_BY` | `0x01` | The user is being followed by the account |
| `Laboratory.Relationship.MUTUALS` | `0x03` | The user and the account are following each other |
| `Laboratory.Relationship.REQUESTED` | `0x04` | The user has requested to follow the account |
| `Laboratory.Relationship.REQUESTED_MUTUALS` | `0x05` | The account follows the user, and the user has requested to follow the account |
| `Laboratory.Relationship.NOT_FOLLOWING` | `0x00` | Neither the account nor the user are following each other |
| `Laboratory.Relationship.BLOCKING` | `0x08` | The user is blocking the account |
| `Laboratory.Relationship.UNKNOWN` | `0x20` | The relationship between the user and the account is unknown |

You can use bitwise comparisons on these enumerals to test for a specific relationship status.
Of course, many combinations are not possible.

|  Flag  | Meaning |
| :----: | ------- |
| `0x01` | The user is followed by the account |
| `0x02` | The account is followed by the user |
| `0x04` | The user has sent a follow request to the account |
| `0x08` | The user is blocking the account |
| `0x10` | The user is the same as the account |
| `0x20` | The relationship status between the user and the account is unknown |

##  Implementation  ##

    Enumerals.Relationship = generateEnumerals
        NOT_FOLLOWING: 0x00
        FOLLOWED_BY: 0x01
        FOLLOWING: 0x02
        MUTUALS: 0x03
        REQUESTED: 0x04
        REQUESTED_MUTUALS: 0x05
        BLOCKING: 0x08
        SELF: 0x10
        UNKNOWN: 0x20
