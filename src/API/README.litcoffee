<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.4.0</i> <br> <code>API/README.litcoffee</code></p>

#  LABORATORY API  #

 - - -

##  Description  ##

Laboratory does not give you direct access to the information it receives from a Mastodon server.
Instead, it makes this information available through the __Laboratory API,__ which is documented here.
This page will provide the basics on the API and how it works, and then direct you to further resources for specific components.

The Laboratory API is split up into two parts, both of which you will need a basic understanding of in order to use the script.
These are the __Event API__ and the __Request API__.
Generally speaking, you will use the Event API to initialize your scripts and create Laboratory extensions, while you will use the Request API for making API requests and retreiving information.

###  Understanding the Event API:

In order to understand Laboratory's Event API, you first need to understand how Laboratory stores its data.
All of the information that Laboratory receives and keeps track of from a Mastodon server is kept within a single central __store__, which is essentially just a large JavaScript object.
The idea of a central store might be familiar to you if you've used systems like Redux before.

However, unlike with Redux, many areas of Laboratory's store are left fully mutable.
This means that the store can be quickly modified in-place to add and remove data.
However, it also means that, in order to maintain the sanctity of its data, the Laboratory store can't be exposed to the public view.
**Laboratory's store is declared inside of a closure for which there is no external access.**
The only functions which are allowed to modify the Laboratory store are a collection of __Laboratory Event Handlers__ (colloquially, just "handlers"), which listen for Laboratory-specific events dispatched to the `document`.

The only means outside programs have to interact with the Laboratory store is then through a series of pre-defined __Laboratory Events__, which can be issued, listened for, and logged by external parties.
The Laboratory Event API describes these events and their function.

####  What events do, and why they are needed.

Laboratory events generally serve two main purposes:

1.  They provide new information to the Laboratory store
2.  They inform Laboratory scripts and extensions that the information has been updated

When a `Profile`, `Post`, `Timeline`, or `Rolodex` is received, events are dispatched containing all the `Profile`s and `Post`s that were created during the process.
This means that, if a `Timeline.Request` discovers that a user's avatar has changed, a `Profile.Request` that is listening for updates will be able to detect the change and update its value accordingly.
Clients can also create and dispatch their own events (for example, to insert custom notifications into a user's Notifications timeline); however, at the moment this functionality is somewhat limited.

####  Creating, issuing, and listening for Laboratory Events.

Laboratory Events are implemented as DOM `CustomEvents`.
Consequently, each event has just two pieces of information that you need to account for: its `type`, which identifies the event, and its `detail`, which is an object holding the event's data.
Every Laboratory Event will have a `detail` which is an immutable object.

Laboratory events are dispatched to the `document` and can be listened for using `document.addEventListener()`.
The `dispatch()` function has been created to make dispatching Laboratory events easier, and it is __strongly recommended__ that you use it instead of, say, `document.dispatchEvent()`.
`dispatch()` will automatically handle `CustomEvent` creation and `detail` assignment, and will fill in default values as necessary for the events you dispatch.
For example, the following code will dispatch a `LaboratorySomeEvent` event for you:

>   ```javascript
>   Laboratory.dispatch("LaboratorySomeEvent", detail);
>   ```

####  Event details.

Dispatching most events requires calling `Laboratory.dispatch()` with not only a string specifying the event, but also a `detail`, which is an object containing additional event information.
Generally, the type of this object is provided in its name: `LaboratoryProfileReceived`, for example, requires a `detail` which is a `Profile`.
When listening for events, the `detail` property on the event can be used to access this data.

###  Understanding the Request API:

Constantly calling, listening for, and handling events can get tedious, so Laboratory also comes with a Request API.
Generally speaking, using this API means following these basic steps:

1.  Create a new `Request` object, for example by calling `new Laboratory.Post.Request()`
2.  Associate the `response` event with a callback using `request.addEventListener`
3.  Send the request using `request.start()`

>   __[Issue #63](https://github.com/marrus-sh/laboratory/issues/63) :__
>   The method by which you listen for responses to `Request`s may change drastically in the future.

Every `Request` object has `start()` and `stop()` methods which can be used to send and cancel the request.
In order to prevent memory leaks, it is recommended that you always call `stop()` when you are done with a `Request`.
However, this is only required if the `Request` you are using is listening for live updates.

The first argument of a `Request()` constructor is always a `data` object whose properties further clarify the request.
The specifics of this object depends on the kind of `Request` you are trying to make.
Some `Request`s take further arguments, so be sure to consult the documentation.
However, only the `data` object is ever required.

###  API reference:

The Laboratory API is broken up into several __modules__, each of which is documented within its source.
These are as follows:

- [__Initialization__](Initialization.litcoffee)
- [__Request__](Request.litcoffee)
- [__Client__](Client.litcoffee)
- [__Authorization__](Authorization.litcoffee)
- [__Profile__](Profile.litcoffee)
- [__Rolodex__](Rolodex.litcoffee)
- [__Attachment__](Attachment.litcoffee)
- [__Post__](Post.litcoffee)
- [__Timeline__](Timeline.litcoffee)

 - - -

##  Examples  ##

###  Listening for `LaboratoryInitializationReady`:

>   ```javascript
>   document.addEventListener("LaboratoryInitializationReady", callback);
>   ```

###  Requesting authorization:

>   __[Issue #63](https://github.com/marrus-sh/laboratory/issues/63) :__
>   The method by which you listen for responses to `Request`s may change drastically in the future.

>   ```javascript
>   request = Laboratory.Authorization.Request({
>       origin: "https://myinstance.social"
>       name: "My Laboratory Client"
>       redirect: "/"
>       scope: Laboratory.Authorization.READWRITEFOLLOW
>   });
>   request.addEventListener("response", callback);
>   request.send();
>   ```

 - - -

##  Implementation  ##

###  Event processing:

There is a fair amount that goes on behind-the-scenes to make Laboratory events easy to dispatch and listen for.
Roughly speaking, we have to:

1.  Keep a record of all accepted Laboratory events.
2.  Specify what is expected of an event's `detail`, and give default values
3.  Associate our handlers with events and keep track of them for later
4.  Create the `dispatch()` function to dispatch events

For simplicity's sake, we will store our events inside an object called `LaboratoryEvent`, whose methods will greatly ease this process.
`LaboratoryEvent` won't be exposed to the window, it's just for our own internal use.

    LaboratoryEvent =

        Events: {}
        Handlers: []

####  Adding new events.

The `LaboratoryEvent.create()` function registers a new event and associates it with a `detail`.
If the provided `detail` is an object, then its own properties will determine the allowed and default properties of the event's detail; if it is a constructor, then the provided detail must be an instance (or `null`).

        create: (type, detail) ->
            LaboratoryEvent.Events[type] = Object detail unless LaboratoryEvent.Events[type]?
            return LaboratoryEvent

####  Setting up handlers.

The `LaboratoryEvent.handle()` function just associates a `type` with a `callback`.
It sets things up so we can easily add our handlers later.

>   __Note :__
>   The `handle()` function directly modifies and stores its `callback` argument, which would definitely be a no-go if we were exposing it to outsiders.
>   It saves us having to wrap the callback in an object or, worse, yet another function though, so let's just treat it responsibly and keep this between us.

        handle: (type, callback) ->
            return LaboratoryEvent unless LaboratoryEvent.Events[type = String type]?
            callback.type = type
            LaboratoryEvent.Handlers.push callback
            return LaboratoryEvent

####  Dispatching events.

We can now create our `dispatch()` function.
It just sets up our detail and dispatches the event to `document`.

>   __[Issue #30](https://github.com/marrus-sh/laboratory/issues/30) :__
>   Event dispatching may be metered in the future.

    Laboratory.dispatch = dispatch = (event, props) ->
        return no unless (initials = LaboratoryEvent.Events[event = String event])?
        if typeof initials is "function"
            return no unless (detail = props) instanceof initials
        else if props?
            detail = {}
            for prop, initial of initials
                detail[prop] = if props[prop]? then props[prop] else initial
            Object.freeze detail
        document.dispatchEvent new CustomEvent event, {detail}
        return yes
