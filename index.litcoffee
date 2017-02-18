#  LABORATORY  #

A custom frontend for **Mastodon/Ardipithecus**.
Derived from the original Mastodon frontend with substantial modification.

##  Installation  ##

###  On Ardipithecus:  ###

Include this folder in `/app/assets/frontends`, specify it in the `FRONTEND` variable in `.env.production`, and restart your server.

###  On Mastodon:  ###

Include this folder in `/app/assets/frontends` (feel free to create this folder if it doesn't already exist), and then perform the following actions:

**1.** Add the line `= stylesheet_link_tag 'laboratory', media: 'all'` to the `:header_tags` declaration in `/app/views/home/index.html.haml`, and replace the line `= javascript_include_tag 'application'` with `=javascript_include_tag 'laboratory'`

**2.** Add the following lines to `/config/initializers/assets.rb`:

>   ```ruby
>   Sprockets.register_mime_type 'text/literate-coffeescript', extensions: ['.litcoffee', '.coffee.md']
>   Sprockets.register_preprocessor 'text/literate-coffeescript', Tilt::CoffeeScriptLiterateTemplate
>   Sprockets.register_mime_type 'application/x-erb', extensions: ['.litcoffee.erb', '.coffee.md.erb']
>   Rails.application.config.assets.precompile += %w(laboratory.css laboratory.js)
>   ```

This code does two things: (1) It enables your server to process Literate CoffeeScript files (used in the frontend's source), and (2) it ensures that the frontend's stylesheet is properly precomiled.

This code may generate a depreciation warning about `Tilt::CoffeeScriptLiterateTemplate`; if that bothers you, feel free to suppress it by surrounding it with `ActiveSupport::Deprecation.silence do` and `end`.

**4.** Add the entry `["transform-es2015-modules-commonjs", {"loose": true}]` to the `plugins` array in `.babelrc`.
    This will be required in order to support `import` and `export` directives until Mastodon updates its version of `coffee-script-source` to `1.11.0` or greater.

**5.** Add the conditional `if controller_name != 'home'` at the end of the line `= stylesheet_link_tag('application', media: 'all')` in `/app/views/layouts/application.html.haml`.
    This will disable the default Mastodon styles, which would otherwise conflict withour own.

**6.** Restart your server.

##  Customization:  ##

Various aspects of the styling of the frontend can be easily customized through SCSS variables.
These should be placed in `/app/assets/stylesheets/variables.scss`.
The accepted variables, along with their default values, can be seen in `styling/defaults.scss`.

##  Source  ##

The source code for the Laboratory package is written in Literate CoffeeScript, which means that it can be read as regular Markdown.
This file is actually a file in the package!
Here are our only lines though:

    ###
     *= require jquery
     *= require jquery_ujs
     *= require laboratory/setup
     *= require_tree laboratory/scripting
     *= require laboratory/run
    ###
