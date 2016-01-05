'use strict'

angular.module('smartRegisterApp').constant 'environments',
  Object.freeze
    development:
      baseURL: 'http://dev-java.mycircleinc.net'
    test:
      baseURL: 'http://platform-test.amazon.mycircleinc.net'
    staging:
      baseURL: 'https://platform-staging.mycircleinc.com'
    demo:
      baseURL: 'https://platform-demo.mycircleinc.com'
    trial:
      baseURL: 'https://platform-trial.mycircleinc.com'
    live:
      baseURL: 'https://platform-live.mycircleinc.com'
