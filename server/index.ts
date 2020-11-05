import express from 'express'

const app = express()
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

const apiRouter = express.Router()
apiRouter.post('/echo', (req, res) => res.json(req.body))
app.use('/api', apiRouter)

export default app
