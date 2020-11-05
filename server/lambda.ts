import http from 'http'
import { APIGatewayProxyHandler } from 'aws-lambda'
import awsServerlessExpress from 'aws-serverless-express'
import awsServerlessExpressMiddleware from 'aws-serverless-express/middleware'
import { loadNuxt } from 'nuxt-start'
import app from './index'

const binaryMimeTypes = [
  'application/javascript',
  // 'application/json',
  'application/octet-stream',
  'application/xml',
  'font/eot',
  'font/opentype',
  'font/otf',
  'image/jpeg',
  'image/png',
  'image/svg+xml',
  'text/comma-separated-values',
  'text/css',
  'text/html',
  'text/javascript',
  'text/plain',
  'text/text',
  'text/xml',
]

let server: http.Server

async function createServer(): Promise<http.Server> {
  const nuxt = await loadNuxt('start')
  app.use(awsServerlessExpressMiddleware.eventContext())
  app.use(nuxt.render)
  server = awsServerlessExpress.createServer(app, undefined, binaryMimeTypes)
  return server
}

// ここでは async function 不可
export const handler: APIGatewayProxyHandler = (event, context) => {
  createServer().then((server) =>
    awsServerlessExpress.proxy(server, event, context)
  )
}
