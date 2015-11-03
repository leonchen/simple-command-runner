{spawn} = require 'child_process'

class Run
  @newRun: (name, cmd, params) ->
    run = new Run(name, cmd)
    for k, c of cmd.form
      error = run.applyParam(k, c, params[k])
      if error
        run.error = error
        return run
    run.ready = true
    return run


  constructor: (@name, @config) ->
    @ready = false
    @error = null
    @params = {}


  applyParam: (key, config, val) ->
    return key+" required" if config.required and !val
    
    val = config.default if !val and config.default?

    if config.format?
      for regStr in config.format
        reg = new RegExp(regStr)
        return "invalid #{key} format" unless reg.test(val)
    @params[key] = val
    return null


  getArgs: ->
    args = []
    for a in @config.args
      filled = a.replace /(\#\{\w+\})/g, (str) =>
        key = str.replace /[\#\{\}]/g, ''
        return @params[key] || ""
      args.push filled
    return args


  run: ->
    return "not ready" unless @ready

    env = {}
    env[k] = v for k, v of process.env
    env[k] = v for k, v of @config.envs
    args = @getArgs()

    child = spawn @config.command, args, {cwd: @config.cwd, env, stdio: 'pipe'}
    return child.stdout


module.exports = Run
