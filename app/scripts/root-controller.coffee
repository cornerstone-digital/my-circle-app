'use strict'

angular.module('smartRegisterApp')
.controller 'RootCtrl', ['$scope','$rootScope', 'SettingsService','$location', ($scope, $rootScope, SettingsService, $location) ->

  $rootScope.hasModuleEnabled = (moduleName) ->
    SettingsService.hasModuleEnabled moduleName

  $scope.safeApply = (fn) ->
    phase = @$root.$$phase
    if phase is "$apply" or phase is "$digest"
      fn()  if fn and (typeof (fn) is "function")
    else
      @$apply fn
    return
]
