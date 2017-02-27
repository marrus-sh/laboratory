#  `Laboratory.Symbols.Relationships`  #

>   ```javascript
>       //  Indicates the two users are the same:
>       Relationships.SELF
>       //  Indicates a user is being followed:
>       Relationships.FOLLOWING
>       //  Indicates a user is following the current user:
>       Relationships.FOLLOWED_BY
>       //  Indicates a mutual follow:
>       Relationships.MUTUALS
>       //  Indicates a follow request has been sent:
>       Relationships.REQUESTED
>       //  Indicates a follow request has been sent to a user following the current user:
>       Relationships.REQUESTED_MUTUALS
>       //  Indicates not following:
>       Relationships.NOT_FOLLOWING
>       //  Indicates a block:
>       Relationships.BLOCKING
>   ```

This file provides symbols for a number of relationships between users.

    Object.defineProperty Laboratory.Symbols, "Relationships",
        value: Object.freeze
            SELF: Symbol "LaboratoryRelationshipSelf"
            FOLLOWING: Symbol "LaboratoryRelationshipFollowing"
            FOLLOWED_BY: Symbol "LaboratoryRelationshipFollowedBy"
            MUTUALS: Symbol "LaboratoryRelationshipMutuals"
            REQUESTED: Symbol "LaboratoryRelationshipRequested"
            REQUESTED_MUTUALS: Symbol "LaboratoryRelationshipRequestedMutuals"
            NOT_FOLLOWING: Symbol "LaboratoryRelationshipNotFollowing"
            BLOCKING: Symbol "LaboratoryRelationshipBlocking"
        enumerable: true
