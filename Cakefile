fs     = require 'fs'
{exec} = require 'child_process'

literateFiles = [
    'setup'
    'Symbols/Relationships'
    'Components/Columns/parts/Column'
    'Components/Columns/parts/GoLink'
    'Components/Columns/parts/Heading'
    'Components/Columns/parts/Status'
    'Components/Columns/productions/Empty'
    'Components/Columns/productions/Go'
    'Components/Columns/productions/NotFound'
    'Components/Columns/productions/Notifications'
    'Components/Columns/productions/Timeline'
    'Components/Modules/parts/Module'
    'Components/Modules/productions/Account'
    'Components/Modules/productions/Composer'
    'Components/Modules/productions/Post'
    'Components/Modules/productions/Start'
    'Components/Shared/parts/Button'
    'Components/Shared/parts/Icon'
    'Components/Shared/parts/IDCard'
    'Components/Shared/parts/Textbox'
    'Components/Shared/parts/Toggle'
    'Components/Shared/productions/InstanceQuery'
    'Components/Shared/productions/Laboratory'
    'Components/UI/parts/Header'
    'Components/UI/parts/Title'
    'Components/UI/productions/UI'
    'Events/newBuilder'
    'Events/Account'
    'Events/Authentication'
    'Events/Composer'
    'Events/Notifications'
    'Events/Stream'
    'Events/Timeline'
    'Functions/createStream'
    'Functions/requestFromAPI'
    'Functions/sendToAPI'
    'Functions/sendToAPI'
    'Handlers/Account'
    'Handlers/Authentication'
    'Handlers/Composer'
    'Handlers/Notifications'
    'Handlers/Stream'
    'Handlers/Timeline'
    'Locales/de'
    'Locales/en'
    'Locales/es'
    'Locales/fr'
    'Locales/hu'
    'Locales/pt'
    'Locales/uk'
    'Locales/getL10n'
    'run'
]

task 'build', 'Build single application file from source files', ->
    literateContents = new Array remaining = literateFiles.length
    for file, index in literateFiles then do (file, index) ->
        fs.readFile "src/#{file}.litcoffee", "utf8", (err, fileContents) ->
            throw err if err
            literateContents[index] = fileContents
            process() if --remaining is 0
    process = ->
        fs.writeFile "lib/laboratory.litcoffee", literateContents.join('\n\n'), 'utf8', (err) ->
            throw err if err
            exec "coffee --compile lib/laboratory.litcoffee", (err, stdout, stderr) ->
                throw err if err
                console.log stdout + stderr
                exec "uglifyjs lib/laboratory.js --compress --output lib/laboratory.min.js", (err, stdout, stderr) ->
                    throw err if err
                    console.log stdout + stderr
                    exec "sass --no-cache --sourcemap=none local.scss local.css"
                    console.log "Done."
