#  Installing Laboratory  #

##  On Ardipithecus  ##

Simply include this folder in `/app/assets/frontends`, specify it in the `FRONTEND` variable in `.env.production`, and restart your server.

##  On Mastodon  ##

Include this folder in `/app/assets/frontends` (feel free to create this folder if it doesn't already exist), and then perform the following actions:

1.  In the file `/app/views/home/index.html.haml`:

    - Change the line `= javascript_include_tag 'application'` to instead read `= javascript_include_tag 'laboratory'`
    - Add the line `= stylesheet_link_tag 'laboratory', media: 'all'` to the `:header_tags` declaration.
    - Remove the line `= react_component 'Mastodon', default_props, class: 'app-holder', prerender: false`.
    - Optionally, add the line `#frontend` in the location that you want the frontend to render. If this is not specified then the frontend will render in the `<body>` element, which React doesn't recommend.

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

3.  Add the conditional `if controller_name != 'home'` at the end of the line `= stylesheet_link_tag('application', media: 'all')` in `/app/views/layouts/application.html.haml`.
    This will disable the default Mastodon frontend styles, which would otherwise conflict with our own.

4.  Restart your server.
