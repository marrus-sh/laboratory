#  PROFILE EVENTS  #

##  Introduction  ##

The __Profile__ module of the Laboratory API is comprised of those events which are related to Mastodon accounts.

###  Quick reference:

| Event | Description |
| :---- | :---------- |
| `LaboratoryProfileRequested` | Requests a `Laboratory.Profile` for a specified account |
| `LaboratoryProfileReceived` | Fires when a `Laboratory.Profile` has been processed |
| `LaboratoryProfileFailed` | Fires when a `Laboratory.Profile` fails to process |
| `LaboratoryProfileSetRelationship` | Petitions the Mastodon server to change the relationship between the user and the specified account |

##  Requesting a Profile  ##

>   - __API equivalent :__ `/api/v1/accounts/:id`, `/api/v1/accounts/relationships`
>   - __Request parameters :__
>       - __`id` :__ The id of the profile to request
>       - __`requestRelationships` :__ Whether to request current relationship information regarding the specified account (default: `true`)
>   - __Request :__ `LaboratoryProfileRequested`
>   - __Response :__ `LaboratoryProfileReceived`
>   - __Failure :__ `LaboratoryProfileFailed`

Laboratory Profile events are used to request [`Profile`](../Constructors/Profile.litcoffee)s containing data on a specified account.
The request, `LaboratoryProfileRequested`, takes an object whose `id` parameter specifies the account to fetch.
Laboratory Profile events automatically request up-to-date relationship information for the accounts they fetch; if this is not needed, you can set the `requestRelationships` to `false`.

Laboratory keeps track of all of the `Profile`s it receives in its internal store.
This means that for each `LaboratoryProfileRequested` event, there could be as many as *three* `LaboratoryProfileReceived` responses: one containing the cached data from the store, one containing updated information from the server, and a third if the relationship information has changed as well.
However, Laboratory will only fire as many responses as necessary; if nothing has changed from the stored value, then only one response will be given.

##  Changing Relationship Status  ##

>   - __API equivalent :__ `/api/v1/accounts/follow`, `/api/v1/accounts/unfollow`, `/api/v1/accounts/block`, `/api/v1/accounts/unblock`, `/api/v1/accounts/mute`, `/api/v1/accounts/unmute`
>   - __Miscellanous events :__
>       - `LaboratoryProfileSetRelationship`

The `LaboratoryProfileSetRelationship` event can be used to set the relationship status for an account.
It should be fired with a `detail` which has two properties: `id`, which gives the id of the account, and `relationship`, which gives a new [`Laboratory.Profile.Relationship`](../Constructors/Profile.litcoffee) for the account.

Note that only some relationship aspects can be changed; you can't, for example, make an account stop following you using `LaboratoryProfileSetRelationship`.
For the purposes of this event, a follow and a follow request are treated as equivalent.

##  Implementation  ##

###  Creating the events:

Here we create the events as per our specifications.

    LaboratoryEvent
        .create "LaboratoryProfileRequested",
            id: undefined
            requestRelationships: yes
        .create "LaboratoryProfileReceived", Profile
        .create "LaboratoryProfileFailed", Failure
        .associate "LaboratoryProfileRequested", "LaboratoryProfileReceived", "LaboratoryProfileFailed"

        .create "LaboratoryProfileSetRelationship",
            id: undefined
            relationship: undefined

###  Handling the events:

Laboratory provides handlers for the following Authorization events:

- `LaboratoryProfileRequested`
- `LaboratoryProfileReceived`
- `LaboratoryProfileSetRelationship`

####  `LaboratoryProfileRequested`.

The `LaboratoryProfileRequested` event requests an account from the Mastodon API, processes it, and fires a `LaboratoryProfileReceived` event with the resultant `Profile`.

        .handle "LaboratoryProfileRequested", (event) ->

            unless isFinite id = Number event.detail.id
                dispatch "LaboratoryProfileFailed", new Failure "Unable to fetch profile; no id specified", "LaboratoryProfileRequested"
                return

If we already have information for the specified account loaded into our `Store`, we can go ahead and fire a `LaboratoryProfileReceived` event with that information now.

            dispatch "LaboratoryProfileReceived", Store.profiles[id] if Store.profiles[id]?

When our new profile data is received, we'll process it and do the same—*if* something has changed.
We'll also request the account's relationships if necessary.

            onComplete = (response, data, params) ->
                unless response.id is id
                    dispatch "LaboratoryProfileFailed", new Failure "Unable to fetch profile; returned profile did not match requested id", "LaboratoryProfileRequested"
                    return
                profile = new Profile response
                dispatch "LaboratoryProfileReceived", profile unless profile.compare Store.profiles[id]
                serverRequest "GET", Store.auth.origin + "/api/v1/accounts/relationships", {id}, Store.auth.accessToken, onRelationshipsComplete, onError if event.detail.requestRelationships
                return

The function call is a little different, but the same is true with our profile relationships.

            onRelationshipsComplete = (response, data, params) ->
                relationships = response[0]
                return if Store.profiles[id]?.relationship is relationship = Profile.Relationship.fromValue (
                    (
                        Profile.Relationship.FOLLOWER * relationships.followed_by +
                        Profile.Relationship.FOLLOWING * relationships.following +
                        Profile.Relationship.REQUESTED * relationships.requested +
                        Profile.Relationship.BLOCKING * relationships.blocking +
                        Profile.Relationship.MUTING * relationships.muting +
                        Profile.Relationship.SELF * (relationships.id is Store.auth.me)
                    ) or Profile.Relationship.UNKNOWN
                )
                dispatch "LaboratoryProfileReceived", new Profile Store.profiles[id], relationship
                return

If something goes wrong, then we need to throw an error.

            onError = (response, data, params) ->
                dispatch "LaboratoryProfileFailed", new Failure response.error, "LaboratoryProfileRequested", params.status
                return

Finally, we can make our server request.

            serverRequest "GET", Store.auth.origin + "/api/v1/accounts/" + id, null, Store.auth.accessToken, onComplete, onError

            return

####  `LaboratoryProfileReceived`.

The `LaboratoryProfileReceived` event simply adds a received profile to our store.

        .handle "LaboratoryProfileReceived", (event) ->
            return unless event.detail instanceof Profile and isFinite id = Number event.detail.id
            Store.profiles[id] = event.detail
            return

####  `LaboratoryProfileSetRelationship`.

The `LaboratoryProfileSetRelationship` event attempts to set the relationship of an account to match that given by the `relationship` parameter of its detail.
It will fire a new `LaboratoryProfileReceived` event updating the account's information if it succeeds.

        .handle "LaboratoryProfileSetRelationship", (event) ->

Obviously we need an `id` and `relationship` to do our work.

            dispatch "LaboratoryProfileFailed", new Failure "Cannot set relationship for account: Either relationship or id is missing", "LaboratoryProfileSetRelationship" unless (relationship = event.detail.relationship) instanceof Profile.Relationship and isFinite id = Number event.detail.id

Here we handle the server response for our relationship setting:

            onComplete = (response, data, params) ->
                dispatch "LaboratoryProfileReceived", new Profile response
                return

            onError = (response, data, params) ->
                dispatch "LaboratoryProfileFailed", new Failure response.error, "LaboratoryProfileSetRelationship", params.status
                return

If we already have a profile for the specified account loaded into our `Store`, then we can test its current relationship to avoid unnecessary requests.
The XOR operation `profile.relationship ^ relationship` will allow us to identify which aspects of the relationship have changed.
We'll store this information in `changes`.

            if (profile = Store.profiles[id]) instanceof Profile
                changes = profile.relationship ^ relationship
                if changes & Profile.FOLLOWING then serverRequest "POST", Store.auth.origin + "/api/v1/accounts/" + id + (if relationship & Profile.FOLLOWING then "/follow" else "/unfollow"), null, Store.auth.accessToken, onComplete, onError
                else if changes & Profile.REQUESTED then serverRequest "POST", Store.auth.origin + "/api/v1/accounts/" + id + (if relationship & Profile.REQUESTED then "/follow" else "/unfollow"), null, Store.auth.accessToken, onComplete, onError
                if changes & Profile.BLOCKING then serverRequest "POST", Store.auth.origin + "/api/v1/accounts/" + id + (if relationship & Profile.BLOCKING then "/block" else "/unblock"), null, Store.auth.accessToken, onComplete, onError
                if changes & Profile.MUTING then serverRequest "POST", Store.auth.origin + "/api/v1/accounts/" + id + (if relationship & Profile.MUTING then "/mute" else "/unmute"), null, Store.auth.accessToken, onComplete, onError

Otherwise (if we don't have a profile on file), we have no choice but to send a request for everything.

            else
                serverRequest "POST", Store.auth.origin + "/api/v1/accounts/" + id + (if relationship & Profile.FOLLOWING or relationship & Profile.REQUESTED then "/follow" else "/unfollow"), null, Store.auth.accessToken, onComplete, onError
                serverRequest "POST", Store.auth.origin + "/api/v1/accounts/" + id + (if relationship & Profile.BLOCKING then "/block" else "/unblock"), null, Store.auth.accessToken, onComplete, onError
                serverRequest "POST", Store.auth.origin + "/api/v1/accounts/" + id + (if relationship & Profile.MUTING then "/mute" else "/unmute"), null, Store.auth.accessToken, onComplete, onError

            return
