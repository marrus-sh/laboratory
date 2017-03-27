#  CHANGELOG  #

##  Version 0  ##

###  0.3:

####  0.3.1 [IN PROGRESS].

#####  CHANGED

* Fixed [Issue #3](https://github.com/marrus-sh/laboratory/issues/3) where Laboratory would request an access token even when it had a perfectly good one already
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