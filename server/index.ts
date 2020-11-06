import express from 'express'
import cors from 'cors'

const app = express()
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

// express の動作確認用に API のエンドポイントを追加しておきます
const apiRouter = express.Router()
apiRouter.use(cors())
apiRouter.post('/echo', (req, res) => res.json(req.body))
app.use('/api', apiRouter)

export default app
