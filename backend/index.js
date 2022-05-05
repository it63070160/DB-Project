const express = require("express")

const app = express();
const cors = require('cors')
const { logger } = require('./middlewares')
app.use(logger)
app.use(cors())

// Statics
app.use(express.static('static'))
app.use(express.json()) // for parsing application/json
app.use(express.urlencoded({ extended: true })) // for parsing application/x-www-form-urlencoded

// routers
const indexRouter = require('./routes/index')
const cardRouter = require('./routes/card')
const userRouter = require('./routes/user')
const bankRouter = require('./routes/bank')
const accountRouter = require('./routes/account')
const transactionRouter = require('./routes/transaction')
const storeRouter = require('./routes/store')

app.use(indexRouter.router)
app.use(cardRouter.router)
app.use(userRouter.router)
app.use(bankRouter.router)
app.use(accountRouter.router)
app.use(storeRouter.router)
app.use(transactionRouter.router)

app.listen(3000, () => {
  console.log(`Example app listening at http://localhost:3000`)
})
