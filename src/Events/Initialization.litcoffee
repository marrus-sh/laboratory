#  INITIALIZATION EVENTS  #

    Events.Initialization = Object.freeze

The __Initialization__ module of Laboratory Events is comprised of those events which are related to initialization of the Laboratory store and handlers.
It is comprised of two events: `LaboratoryInitializationLoaded` and `LaboratoryInitializationReady`.

**You should not fire Laboratory Initialization Events yourself.**
They will be ignored by Laboratory proper, but may confuse other components which you might have loaded.
However, you should listen for these events to know when proper communication with the Laboratory framework should begin.

| Event / Builder | Description |
| :-------------- | :---------- |
| `LaboratoryInitializationLoaded` / `Laboratory.Initialization.Loaded` | Fires when the Laboratory script has been loaded and run |
| `LaboratoryInitializationReady` / `Laboratory.Initialization.Ready` | Fires when the Laboratory event handlers are ready to receive events |

##  `LaboratoryInitializationLoaded`  ##

>   - __Builder :__ `Laboratory.Initialization.Loaded`
>   - __Properties :__ None.

        Loaded: new Constructors.LaboratoryEvent 'LaboratoryInitializationLoaded'

The `LaboratoryInitializationLoaded` event fires when the Laboratory script has been loaded and run, and can be used when loading Laboratory in an asynchronous manner.
After this event fires, it is safe to use the `Laboratory` object in your code.
Before this event fires, the `Laboratory` object will likely not have been defined yet.

Note that this event does not indicate whether the `Laboratory` handlers have been assigned to their appropriate events yet; for that, use `LaboratoryInitializationReady`.

##  `LaboratoryInitializationReady`  ##

>   - __Builder :__ `Laboratory.Initialization.Ready`
>   - __Properties :__ None.

        Ready: new Constructors.LaboratoryEvent 'LaboratoryInitializationReady'

The `LaboratoryInitializationReady` event fires when the Laboratory handlers have been assigned to their appropriate events.
After this event fires, it is safe to dispatch `Laboratory` events.
Before this event fires, it is unlikely (although not *impossible*) that they will be acted upon.

Laboratory waits for the entire document to be loaded before assigning its handlers; consequently, there is a possibility that `LaboratoryInitializationLoaded` will fire well before `LaboratoryInitializationReady`, especially with scripts loaded synchronously.
Of the two, `LaboratoryInitializationReady` is almost always the one to listen for.
