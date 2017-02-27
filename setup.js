window.React       = require('react');
window.ReactDOM    = require('react-dom');
window.ReactRouter = require('react-router');
window.ReactIntl   = require('react-intl');
window.Perf        = require('react-addons-perf');

window.EmojiOne = require('emojione');
window.EmojiOne.imageType    = 'png';
window.EmojiOne.sprites      = false;
window.EmojiOne.imagePathPNG = '/emoji/';

if (!window.Intl) {
  require('intl');
  require('intl/locale-data/jsonp/en.js');
}

//  This sets up our Laboratory object

Object.defineProperty(window, "Laboratory", {
  value: Object.freeze({
    Components: Object.freeze({
      Columns: Object.freeze({parts: {}, productions: {}}),
      Modules: Object.freeze({parts: {}, productions: {}}),
      Shared: Object.freeze({parts: {}, productions: {}}),
      UI: Object.freeze({parts: {}, productions: {}}),
    }),
    Events: {},
    Handlers: {},
    Locales: {},
    Functions: {},
    Symbols: {}
  })
});

//  We'll use `彁` in place of `React.createElement` for brevity.

Object.defineProperty(window, "彁", {value: React.createElement});

//  Polyfill for IE 9 `CustomEvent()`

(function () {
  if ( typeof window.CustomEvent === "function" ) return false;
  function CustomEvent ( event, params ) {
    params = params || {bubbles: false, cancelable: false, detail: undefined};
    var evt = document.createEvent('CustomEvent');
    evt.initCustomEvent(event, params.bubbles, params.cancelable, params.detail);
    return evt;
  }
  CustomEvent.prototype = window.Event.prototype;
  window.CustomEvent = CustomEvent;
})();

//  Semi-polyfill for `Symbol()`

if (!window.Symbol) {
  window.Symbol = function (n) {
    if (!(this instanceof Symb)) return new Symbol(n);
    this.description = String(n);
    return Object.freeze(this);
  }
  Symbol.prototype = {
    toString: function () {return this.description},
    valueOf: function () {return this},
    toSource: function () {return "Symbol(" + this.description + ")"}
  };
  Object.freeze(Symbol);
  Object.freeze(Symbol.prototype);
}
