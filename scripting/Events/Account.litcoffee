#  `Laboratory.Events.Account`  #

##  Usage  ##

>   ```javascript
>       //  Fires when an account view is requested:
>       Account.Requested({id: …, component: …})
>       //  Fires when an account's information is received:
>       Account.Received({data: …})
>       //  Fires when an account's relationship is received:
>       Account.RelationshipsReceived({data: …})
>       //  Fires when an account view is removed:
>       Account.Removed({id: …, component: …})
>   ```
>   - **`id` :** The id of the account.
>   - **`component` :** A timeline component.
>   - **`data` :** The JSON account/relationship data.

##  Object Initialization  ##

    current = Laboratory.Events.Account = {}

##  Events  ##

###  `Account.Requested`:

The `Account.Requested` event has two properties: the `id` of the requested account and the `component` that it will be rendered in.

    current.Requested = Laboratory.Events.newBuilder 'LaboratoryAccountRequested',
        id: null,
        component: null

###  `Account.Received`:

The `Account.Received` event has one property: the `data` of the response.

    current.Received = Laboratory.Events.newBuilder 'LaboratoryAccountReceived',
        data: null

###  `Account.RelationshipsReceived`:

The `Account.RelationshipsReceived` event has one property: the `data` of the response.

    current.RelationshipsReceived = Laboratory.Events.newBuilder 'LaboratoryAccountRelationshipsReceived',
        data: null

###  `Account.Removed`:

The `Account.Removed` event has two properties: the `id` of the account and the `component` that was removed.

    current.Removed = Laboratory.Events.newBuilder 'LaboratoryAccountRemoved',
        id: null,
        component: null

##  Object Freezing  ##

    Object.freeze current
