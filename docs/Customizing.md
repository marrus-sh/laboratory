#  Customizing Laboratory  #

##  Styling  ##

Laboratory has a number of CSS variables that you can set in order to change the basic appearance of the frontend.
It is recommended that you do this in `app/assets/variables.scss`, as this file is automatically loaded by the frontend styles.

The possible variables are as follows:

|  Variable  |  Purpose  |
| :--------- | :-------- |
| **Backgrounds** | Backgrounds can be any value accepted by `background`, not just colours. |
| `$laboratory-background` | Used to set the background of the entire frontend. |
| **Colours** | Colours are used to style text and the flat backgrounds of some objects. |
| `$laboratory-bgColor` | The background colour for the page; drawn behind `$laboratory-background`. |
| `$laboratory-mainTextColor` | The main colour for text on the page. |
| `$laboratory-emphTextColor` | The colour of emphasized text and other text which needs to stand out. |
| `$laboratory-highlightColor` | The background colour used for highlighted text. |
| `$laboratory-highlightTextColor` | The text colour used for highlighted text. |
| `$laboratory-columnColor` | The background colour for frontend columns. |
| `$laboratory-headerColor` | The background colour for the frontend header. |
| `$laboratory-headerTextColor` | The text colour for the frontend header. |
| **Opacities** | Decimal numbers between 0 and 1 used to render transparent content. |
| `$laboratory-notificationBgOpacity` | By default the notification column is slightly transparent, and you can configure that here. |
| `$laboratory-notificationTextOpacity` | For readability purposes it is recommended that you not make notification text as opaque as the notification background. |

##  `data-*` Attributes  ##

In addition to configuring the page through custom styles, there are a number of `data-*` attributes which can be set to change frontend appearance and functionality.
One option is to set these attributes based on user settings for a more personalized experience.

It is recommended that you set these attributes on the `<html>` element, but `#frontend` or any of its ancestors will also work.

The possible attributes are as follows:

|  Attribute  |  Purpose  |
| :---------- | :-------- |
| `data-laboratory-simple` | Makes the interface more minimal by removing the text labels next to icons. |
| `data-laboratory-no_transparency` | Makes every element opaque. |

##  Setting the Initial Store  ##

Laboratory reads in its initial store in from `window.INITIAL_STORE`.
Store properties can be defined with the property definition syntax used by `Object.defineProperty` to make them mutable; otherwise, all store properties are assumed to be immutable.
Laboratory expects the following properties:

|  Property  |  Required?  |  Purpose  |
| :--------- | :---------- | :-------- |
| **`meta` properties** |  |  |
| `meta.access_token` | REQUIRED | The access token used to open the WebSocket stream. |
| `meta.locale` | REQUIRED | The locale used to render the site. |
| **`site` properties** |  |  |
| `site.title` | OPTIONAL | Used to set the title for the site. |
