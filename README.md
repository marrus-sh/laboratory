#  LABORATORY  #

__Laboratory__ is a client-side engine for interfacing with the API of [__Mastodon__](https://github.com/tootsuite/mastodon), a free and open-source social networking server.
Laboratory pulls and stores data from a Mastodon server and makes it accessible to frontends through its __Event API.__
Check out the __[source code](src)__ for more information how to Laboratory in your own projects.
Or, you can keep reading for a brief overview of the project and what it's about.

##  Why Laboratory?  ##

There are a number of client-side API's for interacting with servers like Mastodon.
The advantage to using Laboratory is that it provides **more than just a repackaging of `XMLHttpRequest`**—it is an extensive library for interacting with the data types that Mastodon provides and storing them for later use.
Laboratory maintains a store of all the data it receives from the server for quick access later, and uses an event-based API to manage its asynchronous operations.

The principles which guide Laboratory development are as follows:

 -  __Abstraction of API and data storage.__
    Laboratory does not make its internal storage mechanisms available to users, and data is only accessible through its event interface.
    This allows multiple components to share the same Laboratory store without conflicting with each other's operation.
    Laboratory does not require users to be familiar with the Mastodon API or its data structures.

 -  __Asynchronous, event-based operation.__
    Because much of Laboratory's operation involves making requests to an external server, asynchronous operation is a given.
    However, because Laboratory routes all its behaviour through events and their handlers, multiple components can easily pick up on and share the same data.
    Logging Laboratory operations, as well as extending them with your own components, is a breeze.

 -  __Literate, readable source code.__
    Laboratory is written using __Literate CoffeeScript,__ which enables it to combine its source and documentation into the same files.
    Each source file can be viewed in any Markdown reader, including directly from its hosted location on GitHub.

 -  __Compatibility with frontend frameworks like React.__
    Laboratory wouldn't be very useful if you couldn't use it to make stuff in your project.
    It has been designed with technologies like React in mind, to make operation as seamless as possible.

##  Compatibility  ##

Laboratory makes heavy use of ECMAScript 5.1 features; consequently, you will need a system which supports this.
Laboratory does not make use of features exclusive to ECMAScript 2015.

Laboratory requires basic support for `XMLHttpRequest` to communicate with a Mastodon server, and `CustomEvent` for its event handling.
However, it does not require the `CustomEvent()` constructor as this is not available everywhere.

Given these requirements, the baseline browser compatability for Laboratory should be as seen in the table below:

| Chrome | Edge  | Firefox |  IE   | Opera | Safari (Webkit) |
| :----: | :---: | :-----: | :---: | :---: | :-------------: |
|   6    | _Any_ |    6    |   9   | 12.10 |       5.1       |

Certain aspects of the API have additional requirements.
Laboratory will not attempt to polyfill these features but will take advantage of them if present.

- Remembering authorization credentials between sessions requires access to `localStorage()`
- The `LaboratoryAttachmentRequested` event requires support for `FormData()` and `File()`
- The `Laboratory.request()` method requires support for `Promise()`

If your system doesn't support these features, you should still be able to safely use the remaining parts of the API.

##  API Quick Reference  ##

>  Current version: *0.3.1*

###  Request pipelines:

| Mastodon API | Request | Response | Failure |
| --- | --- | --- | --- |
| [__Initialization__](src/API/Initialization.litcoffee) |  |  |  |
| [__Request__](src/API/Request.litcoffee) |  |  |  |
| [__Client__](src/API/Client.litcoffee) |  |  |  |
| `/api/v1/apps` | `LaboratoryClientRequested` | `LaboratoryClientReceived` | `LaboratoryClientFailed` |
| [__Authorization__](src/API/Authorization.litcoffee) |  |  |  |
| `/oauth/token`, `/api/v1/accounts/verify_credentials` | `LaboratoryAuthorizationRequested` | `LaboratoryAuthorizationReceived` | `LaboratoryAuthorizationFailed` |
| [__Profile__](src/API/Profile.litcoffee) |  |  |  |
| `/api/v1/accounts/:id`, `/api/v1/accounts/relationships` | `LaboratoryProfileRequested` | `LaboratoryProfileReceived` | `LaboratoryProfileFailed` |
| [__Rolodex__](src/API/Rolodex.litcoffee) |  |  |  |
| `/api/v1/accounts/search`, `/api/v1/accounts/:id/followers`, `/api/v1/accounts/:id/following`, `/api/v1/statuses/:id/reblogged_by`, `/api/v1/statuses/:id/favourited_by`, `/api/v1/blocks` | `LaboratoryRolodexRequested` | `LaboratoryRolodexReceived` | `LaboratoryRolodexFailed` |
| [__Attachment__](src/API/Attachment.litcoffee) |  |  |
| `/api/v1/media` | `LaboratoryAttachmentRequested` | `LaboratoryAttachmentReceived` | `LaboratoryAttachmentFailed` |
| [__Post__](src/Events/Post.litcoffee) |  |  |
| `/api/v1/statuses/:id` | `LaboratoryPostRequested` | `LaboratoryPostReceived` | `LaboratoryPostFailed` |
| [__Timeline__](src/API/Timeline.litcoffee) |  |  |  |
| `/api/v1/timelines/home`, `/api/v1/timelines/public`, `/api/v1/timelines/tag/:hashtag`, `/api/v1/notifications/`, `/api/v1/favourites` | `LaboratoryTimelineRequested` | `LaboratoryTimelineReceived` | `LaboratoryTimelineFailed` |

###  Other events:

| Mastodon API | Event |
| --- | --- |
| [__Initialization__](src/API/Initialization.litcoffee) |  |
| *N/A* | `LaboratoryInitializationLoaded` |
| *N/A* | `LaboratoryInitializationReady` |
| [__Request__](src/API/Request.litcoffee) |  |
| *N/A* | `LaboratoryRequestOpen` |
| *N/A* | `LaboratoryRequestUpdate` |
| *N/A* | `LaboratoryRequestComplete` |
| *N/A* | `LaboratoryRequestError` |
| [__Client__](src/API/Client.litcoffee) |  |
| [__Authorization__](src/API/Authorization.litcoffee) |  |
| [__Profile__](src/API/Profile.litcoffee) |  |
| `/api/v1/accounts/follow`, `/api/v1/accounts/unfollow`, `/api/v1/accounts/block`, `/api/v1/accounts/unblock`, `/api/v1/accounts/mute`, `/api/v1/accounts/unmute` | `LaboratoryProfileSetRelationship` |
| [__Rolodex__](src/API/Rolodex.litcoffee) |  |
| [__Attachment__](src/API/Attachment.litcoffee) |  |
| [__Post__](src/API/Post.litcoffee) |  |
| `/api/v1/statuses` | `LaboratoryPostCreation` |
| `/api/v1/statuses/:id` | `LaboratoryPostDeletion` |
| `/api/v1/statuses/:id/reblog`, `/api/v1/statuses/:id/unreblog` | `LaboratoryPostSetReblog` |
| `/api/v1/statuses/:id/favourite`, `/api/v1/statuses/:id/unfavourite` | `LaboratoryPostSetFavourite` |
| [__Timeline__](src/API/Timeline.litcoffee) |  |

##  Labcoat  ##

[__Labcoat__](https://github.com/marrus-sh/labcoat) is a sample frontend built with Laboratory.
Take a look if you want to see what this framework can do!
