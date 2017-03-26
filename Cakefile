fs     = require 'fs'
{exec} = require 'child_process'

files = [
  'README'
  'Constructors/README'
  'Constructors/Enumeral' #  The Enumeral constructor is used by other constructors
  'Constructors/Application'
  'Constructors/Attachment'
  'Constructors/Authorization'
  'Constructors/Client'
  'Constructors/Failure'
  'Constructors/Post'
  'Constructors/Profile'
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

task 'build', 'Build single application file from source files', ->
  contents = new Array remaining = files.length
  for file, index in files then do (file, index) ->
    fs.readFile "src/#{file}.litcoffee", "utf8", (err, fileContents) ->
      throw err if err
      contents[index] = "> From [/src/#{file}.litcoffee](../src/#{file}.litcoffee) :\n\n" + fileContents
      do process if --remaining is 0
  process = ->
    fs.writeFile "dist/laboratory.litcoffee", (contents.join '\n\n- - -\n\n'), 'utf8', (err) ->
      throw err if err
      exec "coffee --compile dist/laboratory.litcoffee", (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
        exec "uglifyjs dist/laboratory.js --comments all --compress --output dist/laboratory.min.js", (err, stdout, stderr) ->
          throw err if err
          console.log stdout + stderr
          console.log "Done."
