#  INITIALIZATION EVENTS  #

##  Introduction  ##

The __Initialization__ module of the Laboratory API is comprised of those events which are related to initialization of the Laboratory store and handlers.
These make up just two events: `LaboratoryInitializationLoaded` and `LaboratoryInitializationReady`.

You can check `window.Laboratory.ready` as a means of verifying if these events have fired after-the-fact:
If `window.Laboratory.ready` exists, then `LaboratoryInitializationLoaded` has fired.
If it is `true`, then `LaboratoryInitializationReady` has fired as well.

**You should not fire Laboratory Initialization events yourself.**
They will be ignored by Laboratory proper, but may confuse other components which you might have loaded.
However, you should listen for these events to know when proper communication with the Laboratory framework should begin.

###  Quick reference:

| Event | Description |
| :---- | :---------- |
| `LaboratoryInitializationLoaded` | Fires when the Laboratory script has been loaded and run |
| `LaboratoryInitializationReady` | Fires when the Laboratory event handlers are ready to receive events |

##  Checking Initialization Status  ##

>   - __API equivalent :__ _None_
>   - __Miscellanous events :__
>       - `LaboratoryInitializationLoaded`
>       - `LaboratoryInitializationReady`

The `LaboratoryInitializationLoaded` event fires when the Laboratory script has been loaded and run, and can be used when loading Laboratory in an asynchronous manner.
After this event fires, it is safe to use the `Laboratory` object in your code.
Before this event fires, the `Laboratory` object will likely not have been defined yet.

The `LaboratoryInitializationReady` event fires when the Laboratory handlers have been assigned to their appropriate events.
After this event fires, it is safe to dispatch `Laboratory` events.
Before this event fires, it is unlikely (although not *impossible*) that they will be acted upon.

Laboratory waits for the entire document to be loaded before assigning its handlers; consequently, there is a possibility that `LaboratoryInitializationLoaded` will fire well before `LaboratoryInitializationReady`, especially with scripts loaded synchronously.
Of the two, `LaboratoryInitializationReady` is almost always the one to listen for.

Neither of the Laboratory Initialization events have `detail`s.

##  Implementation  ##

###  Creating the events:

Here we create the events as per our specifications.

    LaboratoryEvent
        .create "LaboratoryInitializationLoaded"
        .create "LaboratoryInitializationReady"

###  Handling the events:

Laboratory Initialization events do not have handlers.
