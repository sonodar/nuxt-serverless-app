module.exports = {
  moduleNameMapper: {
    '^~~/(.*)$': '<rootDir>/$1',
    '^~/(.*)$': '<rootDir>/nuxt-src/$1',
    '^vue$': 'vue/dist/vue.common.js',
  },
  moduleFileExtensions: ['ts', 'js', 'vue', 'json'],
  transform: {
    '^.+\\.ts$': 'ts-jest',
    '^.+\\.js$': 'babel-jest',
    '.*\\.(vue)$': 'vue-jest',
  },
  collectCoverage: true,
  collectCoverageFrom: [
    '<rootDir>/nuxt-src/components/**/*.vue',
    '<rootDir>/nuxt-src/pages/**/*.vue',
  ],
}
