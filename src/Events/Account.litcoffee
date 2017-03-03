#  ACCOUNT EVENTS  #

    Events.Account = Object.freeze

The __Account__ module of Laboratory Events is comprised of those events which are related to Mastodon accounts.

| Event / Builder | Description |
| :-------------- | :---------- |
| `LaboratoryAccountRelationshipsRequested` / `Laboratory.Account.RelationshipsRequested` | Fires when an account's relationship data should be requested |
| `LaboratoryAccountRelationshipsReceived` / `Laboratory.Account.RelationshipsReceived` | Fires when an account's relationship data has been received |
| `LaboratoryAccountRequested` / `Laboratory.Account.Requested` | Fires when an account's data should be requested |
| `LaboratoryAccountReceived` / `Laboratory.Account.Received` | Fires when an account's data has been received |
| `LaboratoryAccountRemoved` / `Laboratory.Account.Removed` | Fires when an account's callback should be removed |
| `LaboratoryAccountFollowers` / `Laboratory.Account.Followers` | Fires when an account's followers should be requested |
| `LaboratoryAccountFollowing` / `Laboratory.Account.Following` | Fires when data on who an account is following should be requested |
| `LaboratoryAccountSearch` / `Laboratory.Account.Search` | Fires when a search for an account should be requested |
| `LaboratoryAccountFollow` / `Laboratory.Account.Follow` | Fires when a request for a follow has been made |
| `LaboratoryAccountBlock` / `Laboratory.Account.Block` | Fires when a request for a block should be requested |

##  `LaboratoryAccountRelationshipsRequested`  ##

>   - __Builder :__ `Laboratory.Account.RelationshipsRequested`
>   - __Properties :__
>       - `id` – The id(s) of the account.

        RelationshipsRequested: new Constructors.LaboratoryEvent "LaboratoryAccountRelationshipsRequested",
            id: null

The `LaboratoryAccountRelationshipsRequested` event requests that the relationship(s) between the provided account `id`(s) and the user be updated.
If multiple `id`s are are provided, they should be given in an `Array`.

When the account relationships are received, they will be passed through the related account callbacks, so `LaboratoryAccountRelationshipsRequested` only works if the requested account(s) is/are already in the Laboratory store and have callbacks associated with them.
Since it's rare that you will want the relationship information without other information about the account, usually it's best if you just call `LaboratoryAccountRequested` instead.

##  `LaboratoryAccountRelationshipsReceived`  ##

>   - __Builder :__ `Laboratory.Account.RelationshipsReceived`
>   - __Properties :__
>       - `data` – The response from the server.

        RelationshipsReceived: new Constructors.LaboratoryEvent "LaboratoryAccountRelationshipsReceived",
            data: null

The `LaboratoryAccountRelationshipsReceived` event provides the server response for a relationship request.
The handler for this event will update the associated accounts' `relationship` property, firing their callbacks if anything changed.

##  `LaboratoryAccountRequested` ##

>   - __Builder :__ `Laboratory.Account.Requested`
>   - __Properties :__
>       - `id` – The id of the account to fetch data for.
>       - `callback` – A callback function which will be passed the information from the account.

        Requested: new Constructors.LaboratoryEvent "LaboratoryAccountRequested",
            id: null,
            callback: null

The `LaboratoryAccountRequested` event requests information about an account, and associates the account with a provided `callback`.
If information about the given account already exists in the Laboratory store the callback will be called immediately; regardless, a request for updated information will be sent.
`LaboratoryAccountRequested` will automatically also dispatch a `LaboratoryAccountRelationshipsRequested` event to inquire about the account's relationship to the current user.

`callback`s remain associated with an account until a `LaboratoryAccountRemoved` event is fired to remove them.
Whenever an account's information is updated, they are called with a new immutable `Laboratory.Profile` object whose own properties contain the new account data.

The `relationship` will initially be given as `Laboratory.Relationship.UNKNOWN`, and this value will be updated (with a new call to the callback function) once the request for the account's relationship data has gone through.

##  `Account.Received`  ##

>   - __Builder :__ `Laboratory.Account.Received`
>   - __Properties :__
>       - `data` – The response from the server.

        Received: new Constructors.LaboratoryEvent "LaboratoryAccountReceived",
            data: null

The `LaboratoryAccountReceived` event provides the server response for a relationship request.
This event is fired by a number of other handlers when they find themselves with account data—for example, the handler for `LaboratoryTimelineReceived` will fire this event for each account on its timeline.

The handler for `LaboratoryAccountReceived` will fire the associated account's callback functions if the account data has changed.
See the description for `LaboratoryAccountRequested` for more information on the type of data these callbacks will receive.

##  `LaboratoryAccountRemoved`  ##

>   - __Builder :__ `Laboratory.Account.Removed`
>   - __Properties :__
>       - `id` – The account to remove the callback for.
>       - `callback` – The callback to remove.

        Removed: new Constructors.LaboratoryEvent "LaboratoryAccountRemoved",
            id: null,
            callback: null

The `LaboratoryAccountRemoved` event requests a callback be removed from an account.
If the given `callback` has not been associated with the account with the given `id`, this event's handler does nothing.

##  `LaboratoryAccountFollowers`  ##

>   - __Builder :__ `Laboratory.Account.Followers`
>   - __Properties :__
>       - `id` – The id of the account.
>       - `callback` – The callback to call when the follower list is received.
>       - `before` – The status id at which to end the timeline request.
>       - `after` – The status id at which to start the timeline request.

        Followers: new Constructors.LaboratoryEvent "LaboratoryAccountFollowers",
            id: null
            callback: null
            before: null
            after: null

The `LaboratoryAccountFollowers` event requests that the list of followers for the provided account `id` be retrieved.
The range of ids covered by this list can be provided through `before` and `after`.
The `callback` provided to this event will not be remembered later—so make sure one is specified each time.

##  `LaboratoryAccountFollowing`  ##

>   - __Builder :__ `Laboratory.Account.Following`
>   - __Properties :__
>       - `id` – The id of the account.
>       - `callback` – The callback to call when the follower list is received.
>       - `before` – The status id at which to end the timeline request.
>       - `after` – The status id at which to start the timeline request.

        Following: new Constructors.LaboratoryEvent "LaboratoryAccountFollowing",
            id: null
            callback: null
            before: null
            after: null

The `LaboratoryAccountFollowing` event requests that the list people following the provided account `id` be retrieved.
The range of ids covered by this list can be provided through `before` and `after`.
The `callback` provided to this event will not be remembered later—so make sure one is specified each time.

##  `LaboratoryAccountSearch`  ##

>   - __Builder :__ `Laboratory.Account.Search`
>   - __Properties :__
>       - `query` – The query to search for.
>       - `callback` – The callback to call when the follower list is received.
>       - `limit` – The maximum number of results to return from the search.

        Search: new Constructors.LaboratoryEvent "LaboratoryAccountSearch",
            query: null
            callback: null
            limit: null

The `LaboratoryAccountSearch` event requests that an account search be performed for the specified query.
You can limit the number of results returned with the `limit` property.
The `callback` provided to this event will not be remembered later—so make sure one is specified each time.

##  `LaboratoryAccountFollow`  ##

>   - __Builder :__ `Laboratory.Account.Follow`
>   - __Properties :__
>       - `id` – The id of the account.
>       - `value` – `true` if the account should be followed; `false` if the account should be unfollowed

        Follow: new Constructors.LaboratoryEvent "LaboratoryAccountFollow",
            id: null
            value: true

The `LaboratoryAccountFollow` event requests a follow for the specified user id.
Once the server processes this request, a `LaboratoryAccountRelationshipsReceived` event will trigger with the updated relationship for the given account.

##  `LaboratoryAccountBlock`  ##

>   - __Builder :__ `Laboratory.Account.Block`
>   - __Properties :__
>       - `id` – The id of the account.
>       - `value` – `true` if the account should be followed; `false` if the account should be unfollowed

        Block: new Constructors.LaboratoryEvent "LaboratoryAccountBlock",
            id: null
            value: true

The `LaboratoryAccountBlock` event requests a block for the specified user id.
Once the server processes this request, a `LaboratoryAccountRelationshipsReceived` event will trigger with the updated relationship for the given account.
