//= require react
//= require react_ujs
//= require_self
//= require ./lib/laboratory.js

//  This loads all of our dependencies

window.React                 = require('react');
window.ReactDOM              = require('react-dom');
window.ReactRouter           = require('react-router');
window.ReactIntl             = require('react-intl');
window.ReactPureRenderMixin  = require('react-addons-pure-render-mixin');
window.History               = require('history');

window.ReactIntlLocaleData = {
  en: require('react-intl/locale-data/en'),
  de: require('react-intl/locale-data/de'),
  es: require('react-intl/locale-data/es'),
  fr: require('react-intl/locale-data/fr'),
  pt: require('react-intl/locale-data/pt'),
  hu: require('react-intl/locale-data/hu'),
  uk: require('react-intl/locale-data/uk'),
}
