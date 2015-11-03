router = require('koa-router')()
commands = require './commands.json'

Run = require './run'

run = (gameId) ->


router.get '/', ->
  @.render 'index', {commands}

router.get '/task/:cmd', ->
  name = @.params['cmd']
  cmd = commands[name]
  if cmd
    @.render 'command',{name, command: cmd}
  else
    @.status = 404

router.post '/run', ->
  name = @.request.body['command']
  cmd = commands[name]
  unless cmd
    @.status = 404
    return

  run = Run.newRun(name, cmd, @.request.body)
  if run.error
    @.status = 400
    @.body = run.error
  else
    @.type = 'html'
    @.body = run.run()

module.exports = router
