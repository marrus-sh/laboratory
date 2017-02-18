#  `scripting/scripts/createStream`

This module is used to open a WebSocket stream with the Ardipithecus/Mastodon API.

##  Imports  ##

Of course, to handle our stream, we need to import our stream-related Laboratory events:

    `import * from '../events/LaboratoryStream';`

##  Getting the URL  ##

The function `createWebSocketURL(url)` uses an `<a>` element to generate a URL object from a given url, while changing the protocol to `ws` or `wss` depending on the original URL's security levels.
It returns the full `ws(s)://` url.

    createWebSocketURL = (url) ->
        a = document.createElement('a')
        a.href     = url
        a.href     = a.href
        a.protocol = if a.protocol is 'https' or a.protocol is 'wss' then 'wss' else 'ws'
        return a.href

##  Creating the Stream ##

The `createStream()` function takes an `accessToken` and a `stream` and uses these to generate a new `WebSocket`, which it returns.

Note `STREAMING_API_BASE_URL` is set on the `Window` object during configuration (see `/app/views/home/index.html.haml` in the Mastodon source).

    createStream = (accessToken, stream) ->
        ws = new WebSocket("#{createWebSocketURL(STREAMING_API_BASE_URL)}/api/v1/streaming/#{stream}?access_token=#{accessToken}")
        ws.addEventListener "open", ((e) -> document.dispatchEvent(LaboratoryOpen {stream: stream})), false
        ws.addEventListener "close", ((e) -> document.dispatchEvent(LaboratoryClose {stream: stream, code: e.code})), false
        ws.addEventListener "message", ((e) -> document.dispatchEvent(LaboratoryMessage {stream: stream, data: JSON.parse(e.data)})), false
        ws.addEventListener "error", ((e) -> document.dispatchEvent(LaboratoryError {stream: stream})), false
        return ws

##  Exports  ##

The only thing this module exports is `createStream()`.

    `export default createStream;`
