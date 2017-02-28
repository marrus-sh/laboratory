#  `Laboratory.Handlers.Account`  #

##  Coverage  ##

**The following events from `Account` have handlers:**

- `Account.Requested`
- `Account.Received`
- `Account.Removed`

##  Object Initialization  ##

    Laboratory.Handlers.Account = {}

##  Handlers  ##

###  `Account.Requested`

We have two things that we need to do when an account is requested: query the server for its information, and hold onto the component requesting access.
We hold those here.

    Laboratory.Handlers.Account.Requested = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Account.Requested.type

We'll let `attributes` store the various attributes expected from the JSON response, so we can easily iterate over them.

        attributes = [
            "id"
            "username"
            "acct"
            "display_name"
            "note"
            "url"
            "avatar"
            "header"
            "locked"
            "followers_count"
            "following_count"
            "statuses_count"
        ]

The `interfaces.accounts` object will store our account components, organized by the account ids.
We need to create an array to store our component in if one doesn't already exist:

        Object.defineProperty @interfaces.accounts, event.detail.id, {value: [], enumerable: true} unless @interfaces.accounts[event.detail.id] instanceof Array

We can now add our component.

        @interfaces.accounts[event.detail.id].push event.detail.component if event.detail.component?

If we already have information on this account loaded into our store, we can pre-fill the component with that information.
We pass our information as a frozen shallow clone of `accounts[id]` in our store.

        if @accounts[event.detail.id]
            stateData = {}
            stateData[attribute] = @accounts[event.detail.id][attribute] for attribute in attributes
            event.detail.component.setState {account: Object.freeze stateData}

Next, we send the request.
Upon completion, it should trigger an `Account.Received` event so that we can handle the data.

        Laboratory.Functions.requestFromAPI @auth.api + "/accounts/" + event.detail.id, @auth.accessToken, Laboratory.Events.Account.Received

We also send a request asking for the user's relationship to the account, so that we know whether we should display "Follow", "Unfollow", or "Block".

        Laboratory.Functions.requestFromAPI @auth.api + "/accounts/relationships?id=" + event.detail.id, @auth.accessToken, Laboratory.Events.Account.RelationshipsReceived

        return

    Laboratory.Handlers.Account.Requested.type = Laboratory.Events.Account.Requested.type
    Object.freeze Laboratory.Handlers.Account.Requested

###  `Account.Received`

When an account's data is received, we need to update its information both inside our store, and in any components which might also be using it.

    Laboratory.Handlers.Account.Received = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Account.Received.type

We'll let `attributes` store the various attributes expected from the JSON response, so we can easily iterate over them.

        attributes = [
            "id"
            "username"
            "acct"
            "display_name"
            "note"
            "url"
            "avatar"
            "header"
            "locked"
            "followers_count"
            "following_count"
            "statuses_count"
        ]

The account `data` lives in `event.detail.data`, and the copy that we'll pass to our components we'll store in `stateData`.
There are two possible cases:
We already have the account loaded, or we don't.
If the account is already loaded, then we need to update its data; if it isn't, then we need to create it.

        data = event.detail.data
        return unless data instanceof Object
        stateData = {}

When updating previous data, we should keep track if any of it has changed.
If not, then we don't need to update our related components.
As we're checking this, let's start copying information into `stateData` just in case.

        if @accounts[data.id]
            hasChanged = false
            for attribute in attributes
                stateData[attribute] = data[attribute]
                if @accounts[data.id][attribute] isnt data[attribute]
                    @accounts[data.id][attribute] = data[attribute]
                    hasChanged = true

Of course, if we're creating the data fresh, it obviously has changed.
We use `Object.defineProperty` and `Object.seal` to keep our data safe.

        else
            Object.defineProperty @accounts, data.id,
                value: Object.seal do (data, stateData, attributes) ->
                    newData = {}
                    stateData[attribute] = newData[attribute] = data[attribute] for attribute in attributes
                    return newData
                enumerable: true
            hasChanged = true

If our values changed, we should iterate over our components and feed them the new account data.

        if hasChanged and (@interfaces.accounts[data.id] instanceof Array)
            component.setState {account: Object.freeze stateData} for component in @interfaces.accounts[data.id]

        return

    Laboratory.Handlers.Account.Received.type = Laboratory.Events.Account.Received.type
    Object.freeze Laboratory.Handlers.Account.Received

##  `Account.RelationshipsReceived`  ##

When an account's relationships are received, we need to update our related components to reflect this.
We don't keep track of relationships in our store since it is rare we need to access more than one of them at a given time.

    Laboratory.Handlers.Account.RelationshipsReceived = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Account.RelationshipsReceived.type

        return unless event.detail.data instanceof Array

        for relationship in event.detail.data
            continue unless @interfaces.accounts[relationship.id] instanceof Array
            for account in @interfaces.accounts[relationship.id]
                account.setState
                    relationship: switch
                        when relationship.id is @auth.me then Laboratory.Symbols.Relationships.SELF
                        when relationship.blocking then Laboratory.Symbols.Relationships.BLOCKING
                        when relationship.following and relationship.followed_by then Laboratory.Symbols.Relationships.MUTUALS
                        when relationship.following then Laboratory.Symbols.Relationships.FOLLOWING
                        when relationship.followed_by then Laboratory.Symbols.Relationships.FOLLOWED_BY
                        when relationship.requested and relationship.followed_by then Laboratory.Symbols.Relationships.REQUESTED_MUTUALS
                        when relationship.requested then Laboratory.Symbols.Relationships.REQUESTED
                        else Laboratory.Symbols.Relationships.NOT_FOLLOWING

        return

    Laboratory.Handlers.Account.RelationshipsReceived.type = Laboratory.Events.Account.RelationshipsReceived.type
    Object.freeze Laboratory.Handlers.Account.RelationshipsReceived

##  `Account.Removed`  ##

`Account.Removed` has a much simpler handler than our previous two:
We just look for the provided component, and remove it from our account interface.

    Laboratory.Handlers.Account.Removed = (event) ->

        return unless event? and this? and event.type is Laboratory.Handlers.Account.Removed.type

Of course, if we don't have any components assigned to the provided id, we can't do anything.

        return unless @interfaces.accounts[event.detail.id] instanceof Array

This iterates over our components until we find the right one, and removes it from the array.

        index = 0;
        index++ until @interfaces.accounts[event.detail.id][index] = event.detail.component or index >= @interfaces.accounts[event.detail.id].length
        @interfaces.accounts[event.detail.id].splice index, 1

…And we're done!

        return

    Laboratory.Handlers.Account.Removed.type = Laboratory.Events.Account.Removed.type
    Object.freeze Laboratory.Handlers.Account.Removed

##  Object Freezing  ##

    Object.freeze Laboratory.Handlers.Account
