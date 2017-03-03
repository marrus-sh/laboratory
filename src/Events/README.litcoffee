#  LABORATORY EVENT API  #

Laboratory does not give you direct access to the information it receives from a Mastodon server.
Instead, it makes this information available using a special __Event API,__ which is documented here.
This page will provide the basics on the API and how it works, and then direct you to further resources for specific components.

##  Understanding the Event API  ##

In order to understand Laboratory's Event API, you first need to understand how Laboratory stores its data.
All of the information that Laboratory receives and keeps track of from a Mastodon server is kept within a single central __store,__ which is a large JavaScript object with numerous different parts.
The idea of a central store might be familiar to you if you've used systems like __Redux__ before.

However, unlike with Redux, many areas of Laboratory's store are left fully mutable.
This means that the store can be quickly modified in-place to add and remove data.
However, it also means that, in order to maintain the sanctity of its data, the Laboratory store can't be exposed to the public view.
**Laboratory's store is declared inside of a closure for which there is no external access.**
The only functions which are allowed to act on the Laboratory store are a collection of __Laboratory Event Handlers__ (colloquially, just "handlers"), which have been bound to the store and listen for Laboratory-specific events dispatched to the `document`.

Consequently, the only means outside programs have to interact with the Laboratory store is through a series of pre-defined __Laboratory Events__, which can be issued, listened for, and logged by external parties.
The Laboratory Event API describes these events and their function.

##  Creating and Issuing Laboratory Events ##

Laboratory Events are implemented as `CustomEvents`.
Consequently, each event has just two pieces of information that you need to account for: its `type`, which identifies the event, and its `detail`, which is an object holding the event's data.
Every Laboratory Event will have a `detail` which is an immutable object.

There is no restriction on creating Laboratory Events from scratch; however, this is **not recommended.**
Instead, a number of __event builders__ have been provided, which can be used to create and dispatch Laboratory Events.
Each of these is an instance of `Laboratory.LaboratoryEvent`, and can be used in the following manner:

###  Creating a Laboratory Event:

The `Laboratory.LaboratoryEvent.prototype.new()` function is used to create a new `CustomEvent` with the appropriate `type` and `detail`.

```javascript
    //  Suppose SomeEventBuilder is an instance of Laboratory.LaboratoryEvent:
    var event = SomeEventBuilder.new(props);
```

You can pass this function an object containing properties and values which should be included in the event; however, only those properties defined by the API will be included.

###  Dispatching a Laboratory Event:

You can dispatch a Laboratory Event created with `Laboratory.LaboratoryEvent.prototype.new()` in the usual manner—by calling `document.dispatchEvent()` with the Laboratory Event as its argument.
Laboratory Events should always be dispatched on the `document`.

Usually, you want to create and dispatch an event at the same time.
The `Laboratory.LaboratoryEvent.prototype.dispatch()` function does this for you.
It has the same syntax as `Laboratory.LaboratoryEvent.prototype.new()`:

```javascript
    //  Suppose SomeEventBuilder is an instance of Laboratory.LaboratoryEvent:
    SomeEventBuilder.dispatch(props);
    SomeEventBuilder.dispatch(props, location);
```

You will note that there is an optional `location` argument on the `Laboratory.LaboratoryEvent.prototype.dispatch()` function.
You can use this argument to dispatch the event to a location other than `document`.
However, this is **not recommended,** as Laboratory handlers all listen for events on the `document` and nowhere else.

##  Listening for Laboratory Events  ##

You may find yourself not wanting to create Laboratory Events, but to listen for them.
Unlike the Laboratory handlers, you do not have access to Laboratory's store, but listening for events can still be useful when it comes to interacting with the Laboratory framework.

All Laboratory Events have a type that resembles `LaboratoryModuleEventName`, where the appropriate event builder for this event would be located at `Laboratory.Module.EventName`.
Just add an event listener to `document` with your callback to listen for these events:

```javascript
    //  Suppose LaboratorySomeEvent is a Laboratory Event:
    document.addEventListener("LaboratorySomeEvent", callback);
```

The most important event to listen for is the `LaboratoryInitializationReady` event, which tells you when Laboratory handlers have been assigned and are now listening.
This event should be used as a trigger for starting any of your Laboratory-related code.

##  How to Read This Source  ##

Unlike with most other Laboratory source files, Laboratory events interweave their source code with their documentation.
Generally speaking, you can completely ignore the source code, as the surrounding text is much more useful and informative.
However, the source code does provide one useful bit of information not disclosed anywhere else: the default values for event properties.
Supposing you see the following source code…

>   ```coffeescript
>       Event: new Constructors.LaboratoryEvent "LaboratorySomeEvent",
>           key1: null
>           key2: ""
>   ```

…you can see that the default value for `key1` of `LaboratorySomeEvent` is `null` and the default value for `key2` is the empty string.

##  Laboratory Event Reference  ##

Laboratory Events are broken up into several __modules__, each of which is documented within its source.
These are as follows:

- [__Initialization__](Initialization.litcoffee)
- [__Authorization__](Authorization.litcoffee)
- [__Account__](Account.litcoffee)
- [__Timeline__](Timeline.litcoffee)
- [__Status__](Status.litcoffee)
- [__Composer__](Composer.litcoffee)

##  Implementation  ##

Here we set up our internal `Events` object.
The own properties of this object will be copied to our global `window.Laboratory` object later.

    Events = {}
