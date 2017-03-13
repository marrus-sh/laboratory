#  LABORATORY  #

__Laboratory__ is a client-side engine for interfacing with the API of [__Mastodon__](https://github.com/tootsuite/mastodon), a free and open-source social networking server.
Laboratory pulls and stores data from a Mastodon server and makes it accessible to frontends through its __Event API.__
Check out the __[source code](src)__ for more information on Laboratory and how to use it.
Or, you can read more about the principles behind Laboratory below:

##  Principles  ##

 -  __Abstraction of API and data storage.__
    Laboratory does not make its internal storage mechanisms available to users, and data is only accessible through its event interface.
    This allows multiple components to share the same Laboratory store without conflicting with each other's operation.

 -  __Asynchronous, event-based operation.__
    Because much of Laboratory's operation involves making requests to an external server, asynchronous operation is a given.
    However, because Laboratory routes all its behaviour through events and their handlers, multiple components can easily pick up on and share the same data.

 -  __Literate, readable source code.__
    Laboratory is written using __Literate CoffeeScript,__ which makes reading through its source code a breeze.
    Each source file can be viewed in any Markdown reader, including directly from its hosted location on GitHub.

 -  __Compatibility with frontend frameworks like React.__
    Laboratory wouldn't be very useful if you couldn't use it to make stuff in your project.
    It has been designed with technologies like React in mind, to make operation as seamless as possible.

##  API Quick Reference  ##

>  Current version: *0.2.0*

| Mastodon API Equivalent | Making a request | Listening for a response |
| --- | --- | --- |
| [**Initialization**](src/Events/Initialization.litcoffee) |  |  |
| *No equivalent* | *N/A* | `LaboratoryInitializationLoad`
| *No equivalent* | *N/A* | `LaboratoryInitializationReady`
| [**Authorization**](src/Events/Authorization.litcoffee) |  |  |
| `/api/v1/apps` | `LaboratoryAuthorizationClientRequested` | `LaboratoryAuthorizationClientReceived` |
| `/oauth/token` | `LaboratoryAuthorizationRequested` | `LaboratoryAuthorizationReceived` |
| `/api/v1/accounts/verify_credentials` | *N/A* | `LaboratoryAuthorizationVerified` |
| `/api/v1/favourites` | `LaboratoryAuthorizationFavourites` | *N/A* |
| `/api/v1/blocks` | `LaboratoryAuthorizationBlocks` | *N/A* |
| [**Account**](src/Events/Account.litcoffee) |  |  |
| `/api/v1/accounts/relationships` | `LaboratoryAccountRelationshipsRequested` | `LaboratoryAccountRelationshipsReceived` |
| `/api/v1/accounts/:id` | `LaboratoryAccountRequested` | `LaboratoryAccountReceived` |
| *No equivalent* | `LaboratoryAccountRemoved` | *N/A*  |
| `/api/v1/accounts/:id/followers` | `LaboratoryAccountFollowers` | *N/A* |
| `/api/v1/accounts/:id/following` | `LaboratoryAccountFollowing` | *N/A* |
| `/api/v1/accounts/search` | `LaboratoryAccountSearch` | *N/A* |
| `/api/v1/accounts/follow`, `/api/v1/accounts/unfollow` | `LaboratoryAccountFollow` | *N/A* |
| `/api/v1/accounts/block`, `/api/v1/accounts/unblock` | `LaboratoryAccountBlock` | *N/A* |
| [**Timeline**](src/Events/Timeline.litcoffee) |  |  |
| `/api/v1/timelines/home`, `/api/v1/timelines/public`, `/api/v1/timelines/tag/:hashtag`, `/api/v1/notifications/` | `LaboratoryTimelineRequested` | `LaboratoryTimelineReceived` |
| *No equivalent* | `LaboratoryTimelineRemoved` | *N/A*  |
| [**Status**](src/Events/Status.litcoffee) |  |  |
| `/api/v1/statuses/:id` | `LaboratoryStatusRequested`, `LaboratoryStatusDeletion` | `LaboratoryStatusReceived` |
| `/api/v1/statuses/:id/reblogged_by` | `LaboratoryStatusReblogs` | *N/A* |
| `/api/v1/statuses/:id/favourited_by` | `LaboratoryStatusFavourites` | *N/A* |
| `/api/v1/statuses/:id/reblog`, `/api/v1/statuses/:id/unreblog` | `LaboratoryStatusSetReblog` | *N/A* |
| `/api/v1/statuses/:id/favourite`, `/api/v1/statuses/:id/unfavourite` | `LaboratoryStatusSetFavourite` | *N/A* |
| [**Composer**](src/Events/Composer.litcoffee) |  |  |
| `/api/v1/media` | `LaboratoryComposerUploadRequested` | `LaboratoryComposerUploadReceived` |
| *No equivalent* | `LaboratoryComposerRequested` | *N/A* |
| `/api/v1/statuses` | `LaboratoryComposerPost` | *N/A* |
| *No equivalent* | `LaboratoryComposerRemoved` | *N/A* |

<!-- Uncomment once labcoat actually gets made lol

##  Labcoat  ##

[__Labcoat__](https://github.com/marrus-sh/labcoat) is a sample frontend built with Laboratory.
Take a look if you want to see what this framework can do!

-->
