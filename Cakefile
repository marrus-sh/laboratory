###
    #  CAKEFILE  #

     - - -

    This file compiles the Laboratory source into a single, minified file.
    Our source is located in `src/` and our resultant file(s) are located in `dist/`.

    The `fs` package gives us access to the file system, and `exec` allows us to run commands.
###

fs     = require 'fs'
{exec} = require 'child_process'

###
    ##  The Files  ##

    We list all of our files individually, allowing us to ensure that they are placed in the correct order.
    Generally speaking, we need to load all of our constructors before we attach requests to them via the API.
    Many constructors have attached Enumerals, so we need to make sure `Enumeral` is loaded first.
    Our `README`s handle initial setup, and `INSTALLING` handles our final operations.
###

files = [
    'README'
    'Constructors/README'
    'Constructors/Enumeral'
    'Constructors/Application'
    'Constructors/Attachment'
    'Constructors/Authorization'
    'Constructors/Client'
    'Constructors/Failure'
    'Constructors/Post'
    'Constructors/Profile'
    'Constructors/Request'
    'Constructors/Rolodex'
    'Constructors/Timeline'
    'API/README'
    'API/Attachment'
    'API/Authorization'
    'API/Client'
    'API/Initialization'
    'API/Post'
    'API/Profile'
    'API/Request'
    'API/Rolodex'
    'API/Timeline'
    'INSTALLING'
]

###
    ##  Processing  ##

    `process()` will process an array of files specified by `contents()`, producing three files:

    - __`dist/laboratory.litcoffee` :__ A Literate CoffeeScript file that is just the concatenated contents of each source file
    - __`dist/laboratory.js` :__ A compiled JavaScript file produced from `dist/laboratory.litcoffee`
    - __`dist/laboratory.min.js` :__ A minified Javascript file (using UglifyJS) produced from `dist/laboratory.js`
###

process = (contents) ->

    ###
        First we join our files.
        For readability, we put a line break in the Markdown between each one.
    ###

    console.log "Joining files..."
    fs.writeFile "dist/laboratory.litcoffee", (contents.join "\n\n- - -\n\n"), "utf8", (err) ->
        throw err if err

        ###
            Next we compile the CoffeeScript.
            The `.litcoffee` extension is all we need to tell the compiler that our CoffeeScript is literate.
            The file will automatically be saved as `dist/laboratory.js`.
        ###

        console.log "Compiling CoffeeScript..."
        exec "coffee --compile dist/laboratory.litcoffee", (err, stdout, stderr) ->
            throw err if err
            console.log stdout + stderr if stdout or stderr

            ###
                We use UglifyJS 2 to minify our final output.
                We keep comments in the file—in our case, this amounts to just the brief identification information at the beginning.
            ###

            console.log "Minifying JavaScript..."
            exec "uglifyjs dist/laboratory.js --comments all --compress --output dist/laboratory.min.js", (err, stdout, stderr) ->
                throw err if err
                console.log stdout + stderr if stdout or stderr
                console.log "...Done."

###
    ##  Building  ##

    `build()` reads in our `files` and produces an array of `contents`, which it then passes on to `process()` once there are no more files remaning.
    This code is a little complex because `fs.readFile` is an asynchronous task.
###

build = ->
    contents = new Array remaining = files.length
    console.log "Reading files..."
    for file, index in files
        do (file, index) ->
            fs.readFile "src/#{file}.litcoffee", "utf8", (err, fileContents) ->
                throw err if err
                contents[index] = fileContents
                process contents if --remaining is 0

###
    ##  Watching  ##

    `buildAndWatch()` immediately invokes `build()`, and then watches the `src/` directory for changes.
    If it detects any, it `build()`s again.
###

buildAndWatch = ->
    do build
    fs.watch "src/", interval: 200, (eventType, filename) ->
        if eventType is 'change'
            console.log "File `src/#{filename}` changed, rebuilding..."
            do build

###
    ##  Task Definitions  ##

    Here we define our tasks.
###

task "build", "Build a single application file from the source files", build
task "build:watch", "Watch and continually rebuild a single application file from the source files", buildAndWatch
