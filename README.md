#  LABORATORY  #

A custom frontend for **Mastodon/Ardipithecus**.
Inspired by the original Mastodon frontend, but completely rewritten.

##  Installation  ##

###  On Ardipithecus:  ###

Simply include this folder in `/app/assets/frontends`, specify it in the `FRONTEND` variable in `.env.production`, and restart your server.

###  On Mastodon:  ###

Include this folder in `/app/assets/frontends` (feel free to create this folder if it doesn't already exist), and then perform the following actions:

1.  In the file `/app/views/home/index.html.haml`:

    -   Change the line `= javascript_include_tag 'application'` to instead read `= javascript_include_tag 'laboratory'`
    -   Add the line `= stylesheet_link_tag 'laboratory', media: 'all'` to the `:header_tags` declaration.
    -  Remove the line `= react_component 'Mastodon', default_props, class: 'app-holder', prerender: false`.

2.  Add the following lines to `/config/initializers/assets.rb`:

    ```ruby
    # Adds support for Literate CoffeeScript & Literate CoffeeScript + ERB

    module LitCoffeeTransformer
      def self.call(input)
        tilter = Tilt::CoffeeScriptLiterateTemplate.new input[:filename], input[:data]
        {data: tilter.render}
      end
    end
    Sprockets.register_mime_type 'text/literate-coffeescript', extensions: ['.litcoffee', '.coffee.md']
    Sprockets.register_transformer 'text/literate-coffeescript', 'application/javascript', LitCoffeeTransformer
    Sprockets.register_mime_type 'application/x-erb', extensions: ['.litcoffee.erb', '.coffee.md.erb']

    # Precompiles necessary assets
    Rails.application.config.assets.precompile += %w(laboratory.css laboratory.js)
    ```

3.  Add the entry `["transform-es2015-modules-commonjs", {"loose": true}]` to the `plugins` array in `.babelrc`.
    This will be required in order to support `import` and `export` directives until Mastodon updates its version of `coffee-script-source` to `1.11.0` or greater.

4.  Add the conditional `if controller_name != 'home'` at the end of the line `= stylesheet_link_tag('application', media: 'all')` in `/app/views/layouts/application.html.haml`.
    This will disable the default Mastodon styles, which would otherwise conflict with our own.

5.  Restart your server.

##  Customization:  ##

Various aspects of the styling of the frontend can be easily customized through SCSS variables.
These should be placed in `/app/assets/stylesheets/variables.scss`.
The accepted variables, along with their default values, can be seen in `styling/defaults.scss`.

##  Source  ##

The source code for the Laboratory package is written in Literate CoffeeScript, which means that it can be read as regular Markdown.
This file is actually a file in the package!
Here are our only lines though:
