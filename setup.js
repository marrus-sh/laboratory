//= require_self
//= require react_ujs

window.React    = require('react');
window.ReactDOM = require('react-dom');
window.Perf     = require('react-addons-perf');

if (!window.Intl) {
  require('intl');
  require('intl/locale-data/jsonp/en.js');
}

//  This sets up our Laboratory object

Object.defineProperty(window, "Laboratory", {value: {}});
Object.freeze(Object.defineProperties(window.Laboratory, {
  components: {value: {}, enumerable: true},
  constructors: {value: {}, enumerable: true},
  events: {value: {}, enumerable: true},
  handlers: {value: {}, enumerable: true},
  locales: {value: {}, enumerable: true},
  functions: {value: {}, enumerable: true}
}));
Object.freeze(Object.defineProperties(window.Laboratory.components, {
  logic: {value: {}, enumerable: true},
  rendering: {value: {}, enumerable: true}
}));

//  We will use Han characters as aliases for Laboratory components to save room.

(function () {

  var hasOwnP = ({}).hasOwnProperty;

  Object.defineProperties(window, {
    页: {value: document},
    目: {value: React.createElement},
    定: {value: Object.defineProperty},
    定定: {value: Object.defineProperties},
    冻: {value: Object.freeze},
    有: {value: function (obj, val) {return hasOwnP.call(obj, val)}},
    听: {value: document.addEventListener.bind(document)},
    除: {value: document.removeEventListener.bind(document)},
    研: {value: window.Laboratory},
    块: {value: window.Laboratory.components},
    论: {value: window.Laboratory.components.logic},
    示: {value: window.Laboratory.components.rendering},
    建: {value: window.Laboratory.constructors},
    动: {value: window.Laboratory.events},
    理: {value: window.Laboratory.handlers},
    语: {value: window.Laboratory.locales},
    作: {value: window.Laboratory.functions}
  });

})();

//  You'll see 此 in some of the source as a quick reference for the current module or result

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
