#  CHANGELOG  #

##  Version 0  ##

###  0.4

####  0.4.0

#####  NEW

+ Added documentation for currently-open [GitHub Issues](https://github.com/marrus-sh/laboratory/issues) ([#14](https://github.com/marrus-sh/laboratory/issues/14))
+ Added a new Request API to make interacting with Laboratory substantially easier and less alien to those not used to event-based operations ([#15](https://github.com/marrus-sh/laboratory/issues/15))
+ Laboratory can now retrieve a list of follow requests ([#18](https://github.com/marrus-sh/laboratory/issues/18))
+ Support for local hashtag searches ([#16](https://github.com/marrus-sh/laboratory/issues/16))

#####  CHANGED

* Fixed [Issue #34](https://github.com/marrus-sh/laboratory/issues/3), where Laboratory used `localStorage` for things where it didn't need to
* The numeric values associated with the `Timeline.Type`s have changed

#####  REMOVED

- Request events and Failure events have been removed, as these features are now provided by the Request API
- `LaboratoryTimelineReceived` and `LaboratoryRolodexReceived` events have been removed, and the Event API now only concerns those data types which directly impact the store
- `Timeline`s and `Rolodex`es no longer have `type`, `query`, `before` or `after` properties, as these are made available on their parent requests

 - - -

###  0.3:

####  0.3.1.

#####  CHANGED

* Fixed [Issue #3](https://github.com/marrus-sh/laboratory/issues/3), where Laboratory would request an access token even when it had a perfectly good one already
* Improved documentation in a couple of areas

#####  REMOVED

- `LaboratoryClientGranted` no longer takes a `window` parameter, and instead automatically closes any `LaboratoryOAuth` window currently open

####  0.3.0.

#####  NEW

+ Added support for muting
+ Added support for GIFV media types
+ Added a number of new data types and constructors
+ Better support for error handling
+ Added a number of useful `Enumeral`s
+ The Laboratory store is now available to constructors as well as handlers

#####  CHANGED

* Reworked API interface:
    * Events no longer receive callbacks, but instead are broken up into __requests,__ __responses,__ and __failures__
    * Every event response is now associated with a constructor
    * `Laboratory.Module.EventName.dispatch()` is now `Laboratory.dispatch("LaboratoryModuleEventName")`, and the `Laboratory.listen()`, `Laboratory.forget()`, and `Laboratory.request()` methods have been added
* `Enumeral`s are now associated with related constructors instead of a root `Enumeral` object for clarity
* Many event names have changed and a couple of events have been consolidated
* The `Laboratory.user` exposed property has been replaced by `Laboratory.auth`, which contains the current `Authorization` object

 - - -

###  0.2:

####  0.2.0.

#####  NEW

+ First release with (well, mostly) working implementation
+ Laboratory now remembers access tokens between sessions
+ Added a few exposed properties:
    + `Laboratory.ready` can be used to detect if `LaboratoryInitializationReady` has fired
    + `Laboratory.user` gives the id of the currently-logged-in user, or `null`

 - - -

###  0.1:

####  0.1.0.

#####  NEW

+ Initial, untested release
+ First API release with broken implementation
