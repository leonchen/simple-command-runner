Jade = require('koa-jade')
jade = new Jade({
  viewPath: './views'
})

module.exports = jade.middleware
