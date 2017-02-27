#  Customizing Laboratory  #

##  Styling  ##

Laboratory has a number of CSS variables that you can set in order to change the basic appearance of the frontend.
It is recommended that you do this in `app/assets/variables.scss`, as this file is automatically loaded by the frontend styles.

The possible variables are as follows:

|  Variable  |  Purpose  |
| :--------- | :-------- |
| **Backgrounds** |  |
| `$laboratory-background` | Used to set the background of the entire frontend. |
| **Colours** |  |
| `$laboratory-backgroundColor` | The background colour for the page; drawn behind `$laboratory-background`. |
| `$laboratory-mainTextColor` | The main colour for text on the page. |
| `$laboratory-accentTextColor` | The colour of emphasized text and other text which needs to stand out. |
| `$laboratory-cardColor` | The background colour used for highlighted text. |
| `$laboratory-cardTextColor` | The text colour used for highlighted text. |
| `$laboratory-cardAccentColor` | The background colour used for accented highlighted text. |
| `$laboratory-cardAccentTextColor` | The text colour used for accented highlighted text. |
| `$laboratory-columnColor` | The background colour for frontend columns. |
| `$laboratory-headerColor` | The background colour for the frontend header. |
| `$laboratory-headerTextColor` | The text colour for the frontend header. |
| `$laboratory-buttonColor` | The background colour for buttons. |
| `$laboratory-buttonTextColor` | The text colour for buttons. |
| `$laboratory-buttonHoverColor` | The background colour for buttons while hovering over them. |
| `$laboratory-buttonHoverTextColor` | The text colour for buttons while hovering over them. |
| `$laboratory-curtainColor` | The colour of the curtain which is drawn over the UI when the module is opened (eg, to compose a post). |
| `$laboratory-moduleColor` | The colour of the module which appears in front of the UI to display certian kinds of content. |
| `$laboratory-moduleTextColor` | The text colour of the aforementioned module. |
| `$laboratory-moduleShadowColor` | The box-shadow colour of the aforementioned module. |
| `$laboratory-moduleAsideColor` | The background colour of module asides, which show things like other posts in the conversation. |
| `$laboratory-moduleAsideTextColor` | The text colour of module asides. |
| `$laboratory-moduleAsideBorderColor` | The border colour of module asides. |
| `$laboratory-textboxColor` | The background colour of the textbox used to compose posts. |
| `$laboratory-textboxTextColor` | The text colour of the textbox used to compose posts. |
| `$laboratory-textboxPlaceholderColor` | The text colour of the placeholder text for the textbox. |
| `$laboratory-textboxBorderColor` | The border colour of the textbox. |
| `$laboratory-composerMessageColor` | The background colour of the input used to enter hidden-content messages. |
| `$laboratory-composerMessageTextColor` | The text colour of the input used to enter hidden-content messages. |
| `$laboratory-composerMessageBorderColor` | The border colour of the input used to enter hidden-content messages. |
| `$laboratory-toggleOffColor` | The colour associated with a toggle's "off" state. |
| `$laboratory-toggleOnColor` | The colour associated with a toggle's "on" state. |
| `$laboratory-toggleHoverOffColor` | The colour associated with a toggle's "off" state when the toggle is being hovered over. |
| `$laboratory-toggleHoverOnColor` | The colour associated with a toggle's "on" state when the toggle is being hovered over. |
| `$laboratory-toggleForegroundOffColor` | The foreground colour associated with a toggle's "off" state. |
| `$laboratory-toggleForegroundOnColor` | The foreground colour associated with a toggle's "on" state. |
| **Opacities** |  |
| `$laboratory-notificationBgOpacity` | By default the notification column is slightly transparent, and you can configure that here. |
| `$laboratory-notificationTextOpacity` | For readability purposes it is recommended that you not make notification text as opaque as the notification background. |
| `$laboratory-curtainOpacity` | The opacity of the curtain which covers the UI when a module is being viewed. |
| `$laboratory-toggleInactiveOpacity` | The opacity of the inactive labels on toggles. |

##  `data-*` Attributes  ##

In addition to configuring the page through custom styles, there are a number of `data-*` attributes which can be set to change frontend appearance and functionality.
One option is to set these attributes based on user settings for a more personalized experience.

It is recommended that you set these attributes on the `<html>` element, but `#frontend` or any of its ancestors will also work.

The possible attributes are as follows:

|  Attribute  |  Purpose  |
| :---------- | :-------- |
| `data-laboratory-simple` | Makes the interface more minimal by removing the text labels next to icons. |
| `data-laboratory-no_transparency` | Makes every element opaque. |
| `data-laboratory-reduce_motion` | Prevents ornamental animations in the UI. |

##  Setting the Initial Store  ##

Laboratory reads in its initial store in from `window.INITIAL_STORE`.
Store properties can be defined with the property definition syntax used by `Object.defineProperty` to make them mutable; otherwise, all store properties are assumed to be immutable.
Laboratory expects the following properties:

|  Property  |  Required?  |  Purpose  |
| :--------- | :---------- | :-------- |
| **`meta` properties** |  |  |
| `meta.access_token` | REQUIRED | The access token used to open the WebSocket stream. |
| `meta.locale` | REQUIRED | The locale used to render the site. |
| `meta.router_basename` | OPTIONAL | The base URL to use with the React router. Defaults to "/web". (Note that you will need to configure your Rails router separately.) |
| `meta.me` | REQUIRED | The account number of the current user's account. |
| **`site` properties** |  |  |
| `site.title` | OPTIONAL | Used to set the title for the site. |
| `site.links` | OPTIONAL | An object whose enumerable own properties provide links to other areas of the site. The names of these properties should be the localized titles for the links. |
| **`compose` properties** |  |  |
| `compose.max_chars` | OPTIONAL | The maximum number of characters allowed in a post. This is listed as "optional", but you need to provide it if your number differs from the Masto standard of 500. |
| `compose.default_privacy` | OPTIONAL | The privacy setting to set the composer's toggles to on first initialization. Can be one of {`"private"`, `"unlisted"`, `"public"`}, and defaults to `"unlisted"`. |
