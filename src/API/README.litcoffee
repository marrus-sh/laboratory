<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.4.0</i> <br> <code>API/README.litcoffee</code></p>

#  LABORATORY EVENT API  #

 - - -

##  Description  ##

Laboratory does not give you direct access to the information it receives from a Mastodon server.
Instead, it makes this information available using a special __Event API,__ which is documented here.
This page will provide the basics on the API and how it works, and then direct you to further resources for specific components.

###  Understanding the Event API:

In order to understand Laboratory's Event API, you first need to understand how Laboratory stores its data.
All of the information that Laboratory receives and keeps track of from a Mastodon server is kept within a single central __store,__ which is a large JavaScript object with numerous different parts.
The idea of a central store might be familiar to you if you've used systems like __Redux__ before.

However, unlike with Redux, many areas of Laboratory's store are left fully mutable.
This means that the store can be quickly modified in-place to add and remove data.
However, it also means that, in order to maintain the sanctity of its data, the Laboratory store can't be exposed to the public view.
**Laboratory's store is declared inside of a closure for which there is no external access.**
The only functions which are allowed to modify the Laboratory store are a collection of __Laboratory Event Handlers__ (colloquially, just "handlers"), which listen for Laboratory-specific events dispatched to the `document`.

The only means outside programs have to interact with the Laboratory store is then through a series of pre-defined __Laboratory Events__, which can be issued, listened for, and logged by external parties.
The Laboratory Event API describes these events and their function.

###  Creating and issuing Laboratory Events:

Laboratory Events are implemented as DOM `CustomEvents`.
Consequently, each event has just two pieces of information that you need to account for: its `type`, which identifies the event, and its `detail`, which is an object holding the event's data.
Every Laboratory Event will have a `detail` which is an immutable object.

It is rare that you will need to interact with events through traditional methods, ie using `document.addEventListener()`.
Instead, the special functions `Laboratory.dispatch()`, `Laboratory.listen()`, and `Laboratory.forget()` should be used to dispatch and listen for events.
The advantage to using these functions is that they will handle event and detail creation for you.
For example, the following code would dispatch the `LaboratorySomethingRequested` event with the provided `detail`.

>   ```javascript
>       Laboratory.dispatch("LaboratorySomethingRequested", detail);
>   ```

This code can be used to associate a callback with a `LaboratorySomethingReceieved` event:

>   ```javascript
>       Laboratory.listen("LaboratorySomethingReceived", callback);
>   ```

This code can be used to forget the previous association:

>   ```javascript
>       Laboratory.forget("LaboratorySomethingReceived", callback);
>   ```

####  Three types of event.

Laboratory Events are broken up into three general categories: __requests__, __responses__, and __failures__.
(There are a few miscellaneous events which don't fall into one of these categories, but they are few and far between.)
Requests usually have names like `LaboratorySomethingRequested`, responses usually have names like `LaboratorySomethingReceived`, and failures usually have names like `LaboratorySomethingFailed`.
Typically, you will dispatch requests, and listen for their associated responses (or failures if the response doesn't go through).
Of course, there is nothing stopping you from dispatching your own responses and failures, or from listening for others' requests.
However, generally speaking this should not be necessary.

>   __[Issue #4](https://github.com/marrus-sh/laboratory/issues/4) :__
>   Events of the form `LaboratorySomethingFailed` will probably be consolidated into a single `LaboratoryFailure` event at some point in the future.

####  Event promises.

If your environment supports `Promise`s, then the `Laboratory.request()` function will handle the request/response/failure pipeline for you; for example:

>   ```javascript
>       Laboratory.request("LaboratorySomethingRequested", detail).then(callback).else(onError);
>   ```

####  Event details.

Dispatching most events requires calling `Laboratory.dispatch()` with not only a string specifying the event, but also a `detail`, which is an object containing additional event information.
The kind of information expected by a `detail` varies from event to event, so be sure to check the documentation to see what is required.

When you listen for an event using `Laboratory.listen()`, the callback function you provide will be called with the event's `detail` as its argument.
For responses, `detail`s will be instances of the modules to which the events belong; for example, the detail for a `LaboratoryProfileRequested` event is an instance of `Laboratory.Profile`.
The `detail`s for failures are all objects of type `Laboratory.Failure`.

###  Laboratory Event reference:

Laboratory Events are broken up into several __modules__, each of which is documented within its source.
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

##  Implementation  ##

There is a lot that goes on behind-the-scenes to make Laboratory events so easy to dispatch and listen for.
Roughly speaking, we have to:

1.  Keep a record of all accepted Laboratory events.
2.  Specify what is expected of an event's *detail*, and give default values
3.  Associate requests with responses and failures
4.  Associate our handlers with events and keep track of them for later
5.  Create the `dispatch()`, `listen()`, and `forget()` functions
6.  Create promises and the `request()` function for accessing them.

For simplicity's sake, we will store our events inside a giant object called `LaboratoryEvent`, whose methods will greatly ease this process.
`LaboratoryEvent` won't be exposed to the window, it's just for our own internal use.

    LaboratoryEvent =

        Events: {}
        Handlers: []

###  Adding new events:

The `LaboratoryEvent.create()` function registers a new event and associates it with a `detail`.
If the provided `detail` is an object, then its own properties will determine the allowed and default properties of the event's detail; if it is a constructor, then the provided detail must be an instance (or `null`).

        create: (type, detail) ->
            LaboratoryEvent.Events[type] = {detail: Object detail} unless LaboratoryEvent.Events[type]?
            return LaboratoryEvent

###  Associating requests with responses and failures:

The `LaboratoryEvent.associate()` function associates a request with its response or failure.

        associate: (request, response, failure) ->
            return LaboratoryEvent unless typeof (levent = LaboratoryEvent.Events[request]) is "object"
            levent.response = response if response?
            levent.failure = failure if failure?
            return LaboratoryEvent

###  Setting up handlers:

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

###  Dispatching events:

We can now create our `dispatch()` function.
It just sets up our detail and dispatches the event to `document`.

    Laboratory.dispatch = dispatch = (event, props) ->
        return no unless (levent = LaboratoryEvent.Events[event = String event])?
        if typeof (initials = levent.detail) is "function"
            return no unless (detail = props) instanceof initials
        else
            detail = {}
            (detail[prop] = if props? and props[prop]? then props[prop] else initial) for prop, initial of initials
        document.dispatchEvent new CustomEvent event, {detail: Object.freeze detail}
        return yes

###  Listening for and forgetting events:

Our `listen()` function is just a wrapper for `document.addEventListener()`.

    Laboratory.listen = listen = (event, callback) ->
        return no unless (levent = LaboratoryEvent.Events[event = String event])? and typeof callback is "function"
        document.addEventListener event, callback
        return yes

Similarly, our `forget()` function is just a wrapper for `document.removeEventListener()`.

    Laboratory.forget = forget = (event, callback) ->
        return no unless (levent = LaboratoryEvent.Events[event = String event])? and typeof callback is "function"
        document.removeEventListener event, callback
        return yes

###  Making promises:

The `request()` function handles the listening and forgetting for us, returning a `Promise`.

    Laboratory.request = request = (event, detail) -> new Promise (resolve, reject) ->
        return unless (levent = LaboratoryEvent.Events[event])?
        respond = (detail) ->
            forget response, respond if response?
            forget failure, fail if failure?
            resolve detail
        fail = (detail) ->
            forget response, respond if response?
            forget failure, fail if failure?
            reject detail
        listen response, respond if (response = levent.response)?
        listen failure, fail if (failure = levent.failure)?
        dispatch event, detail
        return
