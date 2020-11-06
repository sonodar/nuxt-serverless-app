export default {
  srcDir: './nuxt-src',
  // Global page headers (https://go.nuxtjs.dev/config-head)
  head: {
    title: 'nuxt-serverless-app',
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: '' },
    ],
    link: [{ rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }],
  },

  // Global CSS (https://go.nuxtjs.dev/config-css)
  css: [],

  // Plugins to run before rendering page (https://go.nuxtjs.dev/config-plugins)
  plugins: [],

  // Auto import components (https://go.nuxtjs.dev/config-components)
  components: true,

  // Modules for dev and build (recommended) (https://go.nuxtjs.dev/config-modules)
  buildModules: [
    // https://go.nuxtjs.dev/typescript
    '@nuxt/typescript-build',
  ],

  // Modules (https://go.nuxtjs.dev/config-modules)
  modules: ['@nuxtjs/axios'],

  router: {
    base: process.env.BASE_PATH || '/',
  },

  // Build Configuration (https://go.nuxtjs.dev/config-build)
  build: {
    publicPath: (process.env.BASE_URL || '') + '/_nuxt/',
  },

  axios: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
  },

  serverMiddleware: ['~~/server/index.ts'],
}
