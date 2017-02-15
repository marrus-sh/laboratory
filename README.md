#  LABORATORY  #

A custom frontend for **Mastodon/Ardipithecus**.
Derived from the original Mastodon frontend with substantial modification.

##  Installation  ##

###  On Ardipithecus:  ###

Simply include this folder in `/lib/assets`, or `/vendor/assets`.

###  On Mastodon:  ###

Include this folder in `/lib/assets`, or `/vendor/assets`, and then perform the following actions:

1. Remove the `components` folder and `components.js` file from `/app/assets/javascripts`. This package serves as a replacement.
2. Add the line `= stylesheet_link_tag 'frontend', media: 'all'` to the `:header_tags` declaration in `/app/views/home/index.html.haml`.
3. Add the line `Rails.application.config.assets.precompile += %w(frontend.css)` to `/config/initializers/assets.rb`. This will require you to restart your server.
4. Finally, add the conditional `if controller_name != 'home'` at the end of the line `= stylesheet_link_tag('application', media: 'all')` in `/app/views/layouts/application.html.haml`. This will disable the default Mastodon styles, which would otherwise conflict withour own.
