'use strict'

angular.module('smartRegisterApp')
.factory 'SettingsService', ['$rootScope', ($rootScope) ->

  getModules: ->
    multivenue: {
      enabledEnv: {
        development: true
        test: true
        staging: true
        demo: true
        trial: false
        live: true
      }
    }


  hasModuleEnabled: (moduleName) ->
    @getModules()[moduleName].enabledEnv[$rootScope.env]
]
