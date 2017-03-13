#  STATUS EVENTS  #

    Events.Status = Object.freeze

The __Status__ module of Laboratory Events is comprised of those events which are related to interacting with Mastodon statuses.

| Event / Builder | Description |
| :-------------- | :---------- |
| `LaboratoryStatusRequested` / `Laboratory.Status.Requested` | Requests a status from the Mastodon API |
| `LaboratoryStatusReceived` / `Laboratory.Status.Received` | Fired when a status is received from the Mastodon API |
| `LaboratoryStatusReblogs` / `Laboratory.Status.Reblogs` | Requests the users which have reblogged a status from the Mastodon API |
| `LaboratoryStatusFavourites` / `Laboratory.Status.Favourites` | Requests the users which have favourited a status from the Mastodon API |
| `LaboratoryStatusSetReblog` / `Laboratory.Status.SetReblog` | Informs the Mastodon API that a status should be (un-)reblogged |
| `LaboratoryStatusSetFavourite` / `Laboratory.Status.SetFavourite` | Informs the Mastodon API that a status should be (un-)favourited |
| `LaboratoryStatusDeletion` / `Laboratory.Status.Deletion` | Informs the Mastodon API that a status should be deleted |

##  `LaboratoryStatusRequested`  ##

>   - __Builder :__ `Laboratory.Status.Requested`
>   - __Properties :__
>       - `id` – The id of the status.
>       - `callback` – The callback to call when the status is received.

        Requested: new Constructors.LaboratoryEvent "LaboratoryStatusRequested",
            id: null
            callback: null

The `LaboratoryStatusRequested` event requests detailed information on a status with the given `id`.
Its `callback` will receive a [`Laboratory.Post`](../Constructors/Post.litcoffee) object containing the status.
This callback is not remembered so be sure to specify one each time.

##  `LaboratoryStatusReceived`  ##

>   - __Builder :__ `Laboratory.Status.Received`
>   - __Properties :__
>       - `data` – The response from the server.

        Received: new Constructors.LaboratoryEvent "LaboratoryStatusReceived",
            data: null

The `LaboratoryStatusReceived` event describes a response from the server for a Laboratory status request.
It will also update any timelines in which the status is contained.
Generally speaking, this isn't something you need to listen for yourself, as the callback you provided when you requested the data will have also been called.

##  `LaboratoryStatusReblogs`  ##

>   - __Builder :__ `Laboratory.Status.Reblogs`
>   - __Properties :__
>       - `id` – The id of the status.
>       - `callback` – The callback to call when the reblogs are received.
>       - `before` – The id at which to end the request.
>       - `after` – The id at which to start the request.

        Reblogs: new Constructors.LaboratoryEvent "LaboratoryStatusReblogs",
            id: null
            callback: null
            before: null
            after: null

The `LaboratoryStatusReblogs` event requests who has reblogged a status with the given `id`.
Its `callback` will receive an array of [`Laboratory.Profile`](../Constructors/Profile.litcoffee) objects, containing the requested users.
The range of ids covered by this list can be provided through `before` and `after`.

##  `LaboratoryStatusFavourites`  ##

>   - __Builder :__ `Laboratory.Status.Favourites`
>   - __Properties :__
>       - `id` – The id of the status.
>       - `callback` – The callback to call when the favourites are received.
>       - `before` – The id at which to end the request.
>       - `after` – The id at which to start the request.

        Favourites: new Constructors.LaboratoryEvent "LaboratoryStatusFavourites",
            id: null
            callback: null
            before: null
            after: null

The `LaboratoryStatusFavourites` event requests who has favourited a status with the given `id`.
Its `callback` will receive an array of [`Laboratory.Profile`](../Constructors/Profile.litcoffee) objects, containing the requested users.
The range of ids covered by this list can be provided through `before` and `after`.

##  `LaboratoryStatusSetReblog`  ##

>   - __Builder :__ `Laboratory.Status.SetReblog`
>   - __Properties :__
>       - `id` – The id of the status.

        SetReblog: new Constructors.LaboratoryEvent "LaboratoryStatusSetReblog",
            id: null

The `LaboratoryStatusSetReblog` event requests a reblog on a status with the given `id`.
Once this request goes through, a `LaboratoryStatusReceived` event will fire with the updated status information.

##  `LaboratoryStatusSetFavourite`  ##

>   - __Builder :__ `Laboratory.Status.SetFavourite`
>   - __Properties :__
>       - `id` – The id of the status.

        SetFavourite: new Constructors.LaboratoryEvent "LaboratoryStatusSetFavourite",
            id: null

The `LaboratoryStatusSetFavourite` event requests a favourite on a status with the given `id`.
Once this request goes through, a `LaboratoryStatusReceived` event will fire with the updated status information.

##  `LaboratoryStatusDeletion`  ##

>   - __Builder :__ `Laboratory.Status.Deletion`
>   - __Properties :__
>       - `id` – The id of the status.

        Deletion: new Constructors.LaboratoryEvent "LaboratoryStatusDeletion",
            id: null

The `LaboratoryStatusDeletion` event requests a deletion on a status with the given `id`.
It will also remove the status from the Laboratory internal store.
