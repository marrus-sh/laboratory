//= require_self
//= require react_ujs

window.React    = require('react');
window.ReactDOM = require('react-dom');
window.Perf     = require('react-addons-perf');

if (!window.Intl) {
  require('intl');
  require('intl/locale-data/jsonp/en.js');
}

//  We will use 目 as an alias for React.createElement because… its way shorter lol

Object.defineProperty(window, "目", {value: React.createElement});

//  We'll also store all our Laboratory functions in 研 because why the fuck not

Object.defineProperty(window, "Laboratory", {value: {}});
Object.defineProperty(window, "研", {value: window.Laboratory});
Object.freeze(Object.defineProperties(window.研, {
  components: {value: {}},
  events: {value: {}},
  handlers: {value: {}},
  locales: {value: {}},
  functions: {value: {}}
}));
Object.freeze(Object.defineProperties(window.研.components, {
  logic: {value: {}},
  rendering: {value: {}}
}));

//  You'll see 此 in some of the source as a quick reference for the current module

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
