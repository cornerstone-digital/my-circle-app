'use strict'

angular.module('smartRegisterApp')
  .factory 'Config', ['$rootScope', '$location', 'environments', ($rootScope, $location, environments) ->
    baseURL: ->
      @_overrideFromQueryString 'env'
      @_reverseLookupEnvFromBaseURL()
      @_defaultEnvFromHost()
      @_rejectInvalidEnv()
      environments[$rootScope.env]?.baseURL

    mode: ->
      @_overrideFromQueryString 'mode'
      $rootScope.mode ? 'browser'

    _overrideFromQueryString: (key) ->
      value = $location.search()[key]
      if value
        $rootScope[key] = value
        # $location.search key, null

    _reverseLookupEnvFromBaseURL: ->
      baseURL = $location.search().baseURL
      if baseURL?
        $rootScope.env = _.find _.keys(environments), (it) ->
          environments[it].baseURL is baseURL

    _defaultEnvFromHost: ->
        if $location.host() is 'localhost'
          $rootScope.env = 'test'
        else if $location.host() is 'imac.mycircleinc.net'
          $rootScope.env = 'test'
        else if $location.host() is 'merchant.mycircleinc.com'
          $rootScope.env = 'live'
        else
          match = /^merchant[\.-](\w+)\./.exec($location.host())
          $rootScope.env = match[1] if match?

    _rejectInvalidEnv: ->
      unless $rootScope.env in _.keys(environments)
        console.warn "Invalid environment '#{$rootScope.env}'"
        delete $rootScope.env
        $location.path '/invalid-env'
  ]
