#  Extending Laboratory #

(AKA, the Laboratory API)

Laboratory manages state changes by firing events on the `document` object.
While Laboratory doesn't make its state available to outside observers, you *can* listen for Laboratory events and respond to them when they appear.
Additionally, you can send these events (using `CustomEvent`) in order to simulate Laboratory actions.
For example, the following event produces a custom notification:

```javascript
    document.dispatchEvent(
        new CustomEvent("LaboratoryNotificationsItemLoaded", {details: {
            payload: mynotification
        }});
    );
```

A quick reference for these events follows:

##  Table of Contents  ##

- [`Composer Events`](#composer-events)
    - [`LaboratoryComposerRequest`](#laboratorycomposerrequest)
- [`Drop Events`](#drop-events)
    - [`LaboratoryDropNew`](#laboratorydropnew)
- [`Notifications Events`](#notifications-events)
    - [`LaboratoryNotificationsItemLoaded`](#laboratorynotificationsitemloaded)
    - [`LaboratoryNotificationsRequested`](#laboratorynotificationsrequested)
    - [`LaboratoryNotificationsRemoved`](#laboratorynotificationsremoved)
- [`Store Events`](#store-events)
    - [`LaboratoryStoreUp`](#laboratorystoreup)
- [`Stream Events`](#stream-events)
    - [`LaboratoryStreamOpen`](#laboratorystreamopen)
    - [`LaboratoryStreamClose`](#laboratorystreamclose)
    - [`LaboratoryStreamMessage`](#laboratorystreammessage)
    - [`LaboratoryStreamError`](#laboratorystreamerror)
- [`Timeline Events`](#timeline-events)
    - [`LaboratoryTimelineStatusLoaded`](#laboratorytimelinestatusloaded)
    - [`LaboratoryTimelineStatusDeleted`](#laboratorytimelinestatusdeleted)
    - [`LaboratoryTimelineRequested`](#laboratorytimelinerequested)
    - [`LaboratoryTimelineRemoved`](#laboratorytimelineremoved)

##  Composer Events  ##

###  `LaboratoryComposerRequest`:

The `LaboratoryComposerRequest` event requests for the composer dialog to appear.
This event won't have any effect if the composer dialog is already showing, of course.
Laboratory fires this event when you click the "Compose" button in the header, but you can fire it yourself if you want the composer to appear for some other purpose.

##  Drop Events  ##

###  `LaboratoryDropNew`:

The `LaboratoryDropNew` event signals that a file has been dropped onto the page.
The associated `details` object has one attribute: `file`, which contains the drop data.
You can fire this event yourself if you want to load a file into the composer by some other means.

##  Notifications Events  ##

###  `LaboratoryNotificationsItemLoaded`:

The `LaboratoryNotificationsItemLoaded` event is fired when a notification is received from the server.
The associated `details` object has one attribute: `payload`, which contains the notification data.
You can fire this event yourself if you want to send your own notifications to the Notifications pane.

###  `LaboratoryNotificationsRequested`:

The `LaboratoryNotificationsRequested` event is fired just before the notifications pane is inserted into the DOM.
The associated `details` object has one attribute: `component`, which contains the React component of the pane.
You can fire this event yourself to create additional Notifications panes, and Laboratory will dispatch the notifications to the `items` array on the given `component`'s state.

###  `LaboratoryNotificationsRemoved`:

The `LaboratoryNotificationsRemoved` event is just like the `LaboratoryNotificationsRequested` event except it is fired just before the notifications pane is removed.
If you create your own notification handlers with `LaboratoryNotificationsRequested`, then you should also deinitialize them with `LaboratoryNotificationsRemoved`.

##  Store Events  ##

###  `LaboratoryStoreUp`:

The `LaboratoryStoreUp` event is fired when the Laboratory store is created, and begins the initialization of the frontend.
You should never fire this event yourself, but as Laboratory event handlers aren't initialized until the store is created, listening for this event is the best way to know when interfacing with the frontend can begin.

##  Stream Events  ##

###  `LaboratoryStreamOpen`

The `LaboratoryStreamOpen` event is fired when Laboratory opens its WebSocket stream.
The `details` object has one attribute: `stream`, which contains the stream.
Laboratory doesn't use this event itself but you're welcome to listen for it.

###  `LaboratoryStreamClose`

The `LaboratoryStreamClose` event is fired when Laboratory closes its WebSocket stream.
The `details` object has two attributes: `stream`, which contains the stream; and `code`, which contains the closing code.
Laboratory doesn't use this event itself but you're welcome to listen for it.

###  `LaboratoryStreamMessage`

The `LaboratoryStreamMessage` event is fired when Laboratory closes its WebSocket stream.
The `details` object has two attributes: `stream`, which contains the stream; and `data`, which contains the message.
Laboratory reads this data and then routes it according to the value of its `type`.

###  `LaboratoryStreamError`

The `LaboratoryStreamError` event is fired when Laboratory has an error with its WebSocket stream.
The `details` object has one attribute: `stream`, which contains the stream.
Laboratory doesn't use this event itself but you're welcome to listen for it.

##  Timeline Events  ##

###  `LaboratoryTimelineStatusLoaded`

The `LaboratoryTimelineStatusLoaded` event is fired when a notification is received from the server.
The associated `details` object has two attributes: `payload`, which contains the status data, and `stream`, which names the WebSocket stream.
You can fire this event yourself if you want to make your own statuses appear in the timeline.

###  `LaboratoryTimelineStatusDeleted`

The `LaboratoryTimelineStatusDeleted` event is fired when a notification is received from the server.
The associated `details` object has two attributes: `payload`, which contains the status data, and `stream`, which names the WebSocket stream.
You can fire this event yourself if you want to delete certain statuses from the timeline.

###  `LaboratoryTimelineRequested`

The `LaboratoryTimelineRequested` event is fired just before the notifications pane is inserted into the DOM.
The associated `details` object has two attributes: `name`, which names the timeline; and `component`, which contains the React component of the pane.
You can fire this event yourself to create additional timelines, and Laboratory will dispatch the notifications to the `posts` array on the given `component`'s state.

###  `LaboratoryTimelineRemoved`:

The `LaboratoryTimelineRemoved` event is just like the `LaboratoryTimelineRequested` event except it is fired just before the timeline pane is removed.
If you create your own timeline handlers with `LaboratoryTimelineRequested`, then you should also deinitialize them with `LaboratoryTimelineRemoved`.
