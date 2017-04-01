<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.4.0</i> <br> <code>API/Request.litcoffee</code></p>

#  REQUEST EVENTS  #

 - - -

##  Description  ##

The __Request__ module of the Laboratory API is comprised of a handlful of events which are related to Laboratory's various `XMLHttpRequest`s.
Generally speaking you shouldn't have to interact with these events yourself, but they provide an interface for logging which server requests Laboratory currently has open.

>   __[Issue #44](https://github.com/marrus-sh/laboratory/issues/44) :__
>   Request events may change significantly, or be removed, in the near future.
>   You may want to avoid using them in the meantime.

###  Quick reference:

####  Events.

| Event | Description |
| :---- | :---------- |
| `LaboratoryRequestOpen` | Fires when an XMLHttpRequest is opened |
| `LaboratoryRequestUpdate` | Fires when an XMLHttpRequest is updated |
| `LaboratoryRequestComplete` | Fires when an XMLHttpRequest is done loading |
| `LaboratoryRequestError` | Fires when an XMLHttpRequest fails |

###  Listening for requests:

>   - __API equivalent :__ _None_
>   - __Miscellanous events :__
>       - `LaboratoryRequestOpen`
>       - `LaboratoryRequestUpdate`
>       - `LaboratoryRequestComplete`
>       - `LaboratoryRequestError`

Laboratory Request events fire whenever the `readystate` of an `XMLHttpRequest` changes.
`LaboratoryRequestComplete` signifies that the request was successful; that is, it had an HTTP status code in the range `200`–`205` and its response could be parsed.
Alternatively, `LaboratoryRequestError` indicates that the request completed but one or both of those conditions was not true.

The `response` of each Laboratory Request event is the associated `XMLHttpRequest`.

 - - -
 
##  Examples  ##

_[None.]_
 
 - - -

##  Implementation  ##

###  Creating the events:

Here we create the events as per our specifications.

    LaboratoryEvent
        .create "LaboratoryRequestOpen", XMLHttpRequest
        .create "LaboratoryRequestUpdate", XMLHttpRequest
        .create "LaboratoryRequestComplete", XMLHttpRequest
        .create "LaboratoryRequestError", XMLHttpRequest

###  Handling the events:

Laboratory Request events do not have handlers.
