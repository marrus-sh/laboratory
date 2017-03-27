<p align="right"><i>Laboratory</i> <br> Source Code and Documentation <br> API Version: <i>0.3.1</i> <br> <code>API/Request.litcoffee</code></p>

#  REQUEST EVENTS  #

 - - -

##  Introduction  ##

The __Request__ module of the Laboratory API is comprised of those events which are related to Laboratory's various `XMLHttpRequest`s.
Generally speaking you shouldn't have to interact with these events yourself, but they provide an interface for logging which events Laboratory currently has open.

###  Quick reference:

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

The `detail` of each Laboratory Request event is the associated `XMLHttpRequest`.

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
