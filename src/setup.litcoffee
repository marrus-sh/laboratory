If this is an API redirect, then we hand our opener our code.

    codesearch = location.search.match(/code=([^&]*)/)
    code = codesearch[1] if codesearch?
    if code? and window.opener.Laboratory then window.opener.Laboratory.Events.Authentication.Granted {window: window, code: code}

This sets up our Laboratory object:

    Object.defineProperty window, "Laboratory",
        value: Object.freeze
            Components: Object.freeze
                Columns: Object.freeze
                    parts: {}
                    productions: {}
                Modules: Object.freeze
                    parts: {}
                    productions: {}
                Shared: Object.freeze
                    parts: {}
                    productions: {}
                UI: Object.freeze
                    parts: {}
                    productions: {}
            Events: {}
            Handlers: {}
            Locales: {}
            Functions: {}
            Symbols: {}

We'll use `彁` in place of `React.createElement` for brevity.

    Object.defineProperty window, "彁", {value: React.createElement}

Depending on how we loaded React, the PureRenderMixin might not be where we expect:

    ReactPureRenderMixin = React.addons.PureRenderMixin unless ReactPureRenderMixin?

Semi-polyfill for `Symbol()`:

    unless window.Symbol
        window.Symbol = (n) ->
            return new Symbol(n) unless this instanceof Symbol
            @description = String n
            return Object.freeze this
        Symbol.prototype =
            toString: -> @description
            valueOf: -> this
            toSource: -> "Symbol(" + @description + ")";
        Object.freeze Symbol
        Object.freeze Symbol.prototype
