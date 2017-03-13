fs     = require 'fs'
{exec} = require 'child_process'

files = [
  'README'
  'Constructors/README'
  'Constructors/Application'
  'Constructors/Enumeral'
  'Constructors/Follow'
  'Constructors/LaboratoryEvent'
  'Constructors/MediaAttachment'
  'Constructors/Mention'
  'Constructors/Post'
  'Constructors/Profile'
  'Enumerals/README'
  'Enumerals/MediaType'
  'Enumerals/PostType'
  'Enumerals/Relationship'
  'Enumerals/Visibility'
  'Events/README'
  'Events/Account'
  'Events/Authorization'
  'Events/Composer'
  'Events/Initialization'
  'Events/Status'
  'Events/Timeline'
  'Handlers/README'
  'Handlers/Account'
  'Handlers/Authorization'
  'Handlers/Composer'
  'Handlers/Initialization'
  'Handlers/Status'
  'Handlers/Timeline'
  'INSTALLING'
]

task 'build', 'Build single application file from source files', ->
  contents = new Array remaining = files.length
  for file, index in files then do (file, index) ->
    fs.readFile "src/#{file}.litcoffee", "utf8", (err, fileContents) ->
      throw err if err
      contents[index] = fileContents
      process() if --remaining is 0
  process = ->
    fs.writeFile "dist/laboratory.litcoffee", contents.join('\n\n'), 'utf8', (err) ->
      throw err if err
      exec "coffee --compile dist/laboratory.litcoffee", (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
        exec "uglifyjs dist/laboratory.js --comments all --compress --output dist/laboratory.min.js", (err, stdout, stderr) ->
          throw err if err
          console.log stdout + stderr
          console.log "Done."
