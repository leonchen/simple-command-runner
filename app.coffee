koa = require 'koa'

router = require './router'

PORT = process.env.PORT || 3000

app = new koa()

app.use require('koa-bodyparser')()
app.use require('./view')
app.use router.routes()
app.use router.allowedMethods()


app.listen(PORT)
