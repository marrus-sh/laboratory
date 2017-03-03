#  ACCOUNT HANDLERS  #

    Handlers.Account = Object.freeze

##  `LaboratoryAccountRelationshipsRequested`  ##

When an account's relationships are requested, we just forward the request to the server, with `Events.RelationshipsReceived()` as our callback.

        RelationshipsRequested: handle Events.Account.RelationshipsRequested, (event) ->
            return unless isFinite id = Number event.detail.id
            serverRequest "GET", @auth.api + "/accounts/relationships?id=" + id, null, @auth.accessToken, Events.Account.RelationshipsReceived
            return

##  `LaboratoryAccountRelationshipsReceived`  ##

When an account's relationships are received, we need to update the related accounts to reflect this.
We also call any related callbacks with the new information.

        RelationshipsReceived: handle Events.Account.RelationshipsReceived, (event) ->

            return unless (data = event.detail.data) instanceof Array

            for relationships in data
                continue unless isFinite(id = Number relationships.id) and @accounts[id]?
                relationship = Enumerals.Relationship.byValue(
                    Enumerals.Relationship.FOLLOWED_BY * relationships.followed_by +
                    Enumerals.Relationship.FOLLOWING * relationships.following +
                    Enumerals.Relationship.REQUESTED * relationships.requested +
                    Enumerals.Relationship.BLOCKING * relationships.blocking +
                    Enumerals.Relationship.SELF * (relationships.id is @auth.me)
                ) || Enumerals.Relationship.UNKNOWN
                if @accounts[id].relationship isnt relationship
                    @accounts[id] = new Constructors.Profile @accounts[id], @auth.origin, relationship
                    continue unless @interfaces.accounts[id]?
                    callback @accounts[id] for callback in @interfaces.accounts[id]

            return

##  `LaboratoryAccountRequested`  ##

We have two things that we need to do when an account is requested: query the server for its information, and hold onto the callback requesting access.
We do those here.

        Requested: handle Events.Account.Requested, (event) ->

            return unless isFinite id = Number event.detail.id
            callback = null unless typeof (callback = event.detail.callback) is "function"

The `interfaces.accounts` object will store our account callbacks, organized by the account ids.
We need to create an array to store our callback in if one doesn't already exist:

            Object.defineProperty @interfaces.accounts, id, {value: [], enumerable: yes} unless @interfaces.accounts[id] instanceof Array

We can now add our callback, if applicable.

            @interfaces.accounts[id].push callback unless not callback? or callback in @interfaces.accounts[id]

If we already have information on this account loaded into our store, we can send the callback that information right away.
Note that accounts are stored as immutable objects.

            callback @accounts[id] if @accounts[id] and callback?

Next, we send the request.
Upon completion, it should trigger an `LaboratoryAccountReceived` event so that we can handle the data.

            serverRequest "GET", @auth.api + "/accounts/" + id, null, @auth.accessToken, Events.Account.Received

We also need to request the user's relationship to the account, since that doesn't come with our first request.
We can do that with a `LaboratoryAccountRelationshipsRequested` event.

            LaboratoryAccountRelationshipsRequested {id}

            return

##  `LaboratoryAccountReceived`  ##

When an account's data is received, we need to update its information both inside our store, and with any callbacks which might also be depending on it.

        Received: handle Events.Account.Received, (event) ->

            return unless (data = event.detail.data) instanceof Object and isFinite id = Number data.id

Right away, we can generate a `Profile` from our `data`.

            profile = new Constructors.Profile data

If we already have a profile associated with this account id, then we need to check if anything has changed.
If it hasn't, we have nothing more to do.

            return if @accounts[id] and profile.compare @accounts[id]

Otherwise, something has changed.
We overwrite the previous data and fire all of our associated callback functions.

            @accounts[id] = profile
            return unless @interfaces.accounts[id]?
            callback @accounts[id] for callback in @interfaces.accounts[id]

            return

##  `LaboratoryAccountRemoved`  ##

`LaboratoryAccountRemoved` has a much simpler handler than our previous two:
We just look for the provided callback, and remove it from our account interface if it exists.

        Removed: handle Events.Account.Removed, (event) ->

Of course, if we don't have any callbacks assigned to the provided id, we can't do anything.

            return unless isFinite(id = Number event.detail.id) and typeof (callback = event.detail.callback) is "function" and @interfaces.accounts[id] instanceof Array

This iterates over our callbacks until we find the right one, and removes it from the array.

            index = 0;
            index++ until @interfaces.accounts[id][index] is callback or index >= @interfaces.accounts[id].length
            @interfaces.accounts[id].splice index, 1

…And we're done!

            return

##  `LaboratoryAccountFollowers`  ##

When a `LaboratoryAccountFollowers` event is fired, we simply petition the server for a list of followers and pass this to our callback.
We wrap the callback in a function which formats the follower list for us.

        Followers: handle Events.Account.Followers, (event) ->

            return unless isFinite(id = Number event.detail.id) and typeof (callback = event.detail.callback) is "function"

            query = ""
            query += "?max_id=" + Number event.detail.before if isFinite event.detail.before
            query += (if query then "&" else "?") + "since_id=" + Number event.detail.after if isFinite event.detail.after

            serverRequest "GET", @auth.api + "/accounts/" + id + "/followers" + query, null, @auth.accessToken, (response) -> callback(Constructors.Profile(data) for data in response.data)

##  `LaboratoryAccountFollowing`  ##

When a `LaboratoryAccountFollowing` event is fired, we simply petition the server for a list of people following the user and pass this to our callback.
We wrap the callback in a function which formats the list for us.

        Following: handle Events.Account.Following (event) ->

            return unless isFinite(id = Number event.detail.id) and typeof (callback = event.detail.callback) is "function"

            query = ""
            query += "?max_id=" + Number event.detail.before if isFinite event.detail.before
            query += (if query then "&" else "?") + "since_id=" + Number event.detail.after if isFinite event.detail.after

            serverRequest "GET", @auth.api + "/accounts/" + id + "/following" + query, null, @auth.accessToken, (response) -> callback(Constructors.Profile(data) for data in response.data)

##  `LaboratoryAccountSearch`  ##

When a `LaboratoryAccountSearch` event is fired, we send the server a user search query and pass this to our callback.
We wrap the callback in a function which formats the list of results for us.

        Search: handle Events.Account.Search, (event) ->

            return unless isFinite(id = Number event.detail.id) and typeof (callback = event.detail.callback) is "function"

            query = ""
            query += "?q=" + event.detail.query if event.detail.query
            query += (if query then "&" else "?") + "limit=" + Number event.detail.limit if isFinite event.detail.limit

            serverRequest "GET", @auth.api + "/accounts/" + id + "/search" + query, null, @auth.accessToken, (response) -> callback(Constructors.Profile(data) for data in response.data)

##  `LaboratoryAccountFollow`  ##

When a `LaboratoryAccountFollow` event is fired, we send the server a request to follow/unfollow the specified user.
We issue `Events.Account.RelationshipsReceived()` as our callback function, since the result of this request should be an object giving the account's updated relationship to the user.

        Follow: handle Events.Account.Follow, (event) ->

            return unless isFinite(id = Number event.detail.id)

            serverRequest "POST", @auth.api + "/accounts/" + id + (if event.detail.value then "/follow" else "/unfollow"), null, @auth.accessToken, Events.Account.RelationshipsReceived

##  `LaboratoryAccountBlock`  ##

When a `LaboratoryAccountBlock` event is fired, we send the server a request to block/unblock the specified user.
We issue `Events.Account.RelationshipsReceived()` as our callback function, since the result of this request should be an object giving the account's updated relationship to the user.

        Block: handle Events.Account.Block, (event) ->

            return unless isFinite(id = Number event.detail.id)

            serverRequest "POST", @auth.api + "/accounts/" + id + (if event.detail.value then "/block" else "/unblock"), null, @auth.accessToken, Events.Account.RelationshipsReceived
