//= require_self
//= require react_ujs

window.React    = require('react');
window.ReactDOM = require('react-dom');
window.Perf     = require('react-addons-perf');

if (!window.Intl) {
  require('intl');
  require('intl/locale-data/jsonp/en.js');
}

//  We will use 目 as an alias for React.createElement because… its
//  way shorter lol

window.目 = React.createElement;

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
    toString: function () {return this.description}
    valueOf: function () {return this}
    toSource: function () {return "Symbol(" + this.description + ")"}
  };
  Object.freeze(Symbol);
  Object.freeze(Symbol.prototype);
}
