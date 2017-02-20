#  `作.createStream`

This module is used to open a WebSocket stream with the Ardipithecus/Mastodon API.

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

    作.createStream = (accessToken, stream) ->
        ws = new WebSocket createWebSocketURL "#{STREAMING_API_BASE_URL}/api/v1/streaming/#{stream}?access_token=#{accessToken}"
        ws.addEventListener(
            "open",
            (e) -> 动.Stream.Open
                stream: stream
        )
        ws.addEventListener(
            "close",
            (e) -> 动.Stream.Close
                stream: stream
                code: e.code
        )
        ws.addEventListener(
            "message",
            (e) -> 动.Stream.Message
                stream: stream
                data: JSON.parse e.data
        )
        ws.addEventListener(
            "error",
            (e) -> 动.Stream.Error
                stream: stream
        )
        return ws
