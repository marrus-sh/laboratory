<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.3.1</i> <br> <code>API/Rolodex.litcoffee</code></p>

#  ROLODEX EVENTS  #

 - - -

##  Description  ##

The __Rolodex__ module of the Laboratory API is comprised of those events which are related to rolodexes of Mastodon accounts.

###  Quick reference:

| Event | Description |
| :---- | :---------- |
| `LaboratoryRolodexRequested` | Requests a `Rolodex` for a specified query |
| `LaboratoryRolodexReceived` | Fires when a `Rolodex` has been processed |
| `LaboratoryRolodexFailed` | Fires when a `Rolodex` fails to process |

###  Requesting a rolodex:

>   - __API equivalent :__ `/api/v1/accounts/search`, `/api/v1/accounts/:id/followers`, `/api/v1/accounts/:id/following`, `/api/v1/statuses/:id/reblogged_by`, `/api/v1/statuses/:id/favourited_by`, `/api/v1/blocks`, `/api/v1/mutes`
>   - __Request parameters :__
>       - __`type` :__ The [`Laboratory.Rolodex.Type`](../Constructors/Rolodex.litcoffee) of the `Rolodex`
>       - __`query` :__ The associated query
>       - __`before` :__ The id at which to end the rolodex
>       - __`after` :__ The id at which to begin the rolodex
>       - __`limit` :__ The number of accounts to show (for searches only)
>   - __Request :__ `LaboratoryRolodexRequested`
>   - __Response :__ `LaboratoryRolodexReceived`
>   - __Failure :__ `LaboratoryRolodexFailed`

Laboratory Rolodex events are used to request lists of [`Profile`](../Constructors/Profile.litcoffee)s according to the specified `type` and `query`.
If the `type` is `Rolodex.Type.SEARCH`, then `query` should provide the string to search for; otherwise, `query` should be the id of the relevant account or status.
In the case of `Rolodex.Type.BLOCKS` and `Rolodex.Type.MUTES`, no `query` is required.

For `Rolodex.Type.SEARCH`es, the number of accounts to return can be specified using the `limit` parameter; otherwise, the `before` and `after` parameters can be used to change the range of accounts returned.

 - - -

##  Implementation  ##

###  Creating the events:

Here we create the events as per our specifications.

    LaboratoryEvent
        .create "LaboratoryRolodexRequested",
            type: Rolodex.Type.SEARCH
            query: ""
            before: undefined
            after: undefined
            limit: undefined
        .create "LaboratoryRolodexReceived", Rolodex
        .create "LaboratoryRolodexFailed", Failure
        .associate "LaboratoryRolodexRequested", "LaboratoryRolodexReceived", "LaboratoryRolodexFailed"

###  Handling the events:

Laboratory provides handlers for the following Authorization events:

- `LaboratoryRolodexRequested`

####  `LaboratoryRolodexRequested`.

The `LaboratoryRolodexRequested` event requests an account from the Mastodon API, processes it, and fires a `LaboratoryRolodexReceived` event with the resultant `Rolodex`.

        .handle "LaboratoryRolodexRequested", (event) ->

            query = String event.detail.query
            limit = null unless isFinite limit = Number event.detail.limit
            before = null unless isFinite before = Number event.detail.before
            after = null unless isFinite after = Number event.detail.after
            unless (type = event.detail.type) instanceof Rolodex.Type and type isnt Rolodex.Type.UNDEFINED
                dispatch "LaboratoryRolodexFailed", new Failure "Unable to fetch rolodex; no type specified", "LaboratoryRolodexRequested"
                return

When our list of accounts is received, we'll process it and call a `LaboratoryRolodexReceived` event with the resulting `Rolodex`.
We'll also dispatch a `LaboratoryProfileReceived` event with each profile contained in the response.

            onComplete = (response, data, params) ->
                ids = []
                dispatch "LaboratoryProfileReceived", account for account in response when (ids.indexOf account.id) is -1 and ids.push account.id
                dispatch "LaboratoryRolodexReceived", new Rolodex response,
                    type: type
                    query: query
                    before: ((params.prev.match /.*since_id=([0-9]+)/) or [])[1]
                    after: ((params.next.match /.*max_id=([0-9]+)/) or [])[1]
                return

If something goes wrong, then we need to throw an error.

            onError = (response, data, params) ->
                dispatch "LaboratoryRolodexFailed", new Failure response.error, "LaboratoryRolodexRequested", params.status
                return

Finally, we can make our server request.
Note that `serverRequest` ignores data parameters which have a value of `undefined` or `null`.

            serverRequest "GET", Store.auth.origin + (
                switch type
                    when Rolodex.Type.SEARCH then "/api/v1/accounts/search"
                    when Rolodex.Type.FOLLOWERS then "/api/v1/accounts/" + query + "/followers"
                    when Rolodex.Type.FOLLOWING then "/api/v1/accounts/" + query + "/following"
                    when Rolodex.Type.FAVOURITED_BY then "/api/v1/statuses/" + query + "/favourited_by"
                    when Rolodex.Type.REBLOGGED_BY then "/api/v1/statuses/" + query + "/reblogged_by"
                    when Rolodex.Type.BLOCKS then "/api/v1/blocks"
                    when Rolodex.Type.MUTES then "/api/v1/mutes"
                    else "/api/v1"
            ), (
                switch type
                    when Rolodex.Type.SEARCH
                        q: query
                        limit: limit
                    when Rolodex.Type.FOLLOWERS, Rolodex.Type.FOLLOWING, Rolodex.Type.FAVOURITED_BY, Rolodex.Type.REBLOGGED_BY, Rolodex.Type.BLOCKS, Rolodes.Type.MUTES
                        max_id: before
                        since_id: after
                    else null
            ), Store.auth.accessToken, onComplete, onError

            return
