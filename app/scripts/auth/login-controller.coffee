'use strict'

angular.module('smartRegisterApp')
  .controller 'LoginCtrl', ['$rootScope', '$scope', '$location', 'Auth', ($rootScope, $scope, $location, Auth) ->

    $location.path '/' if Auth.isLoggedIn()

    $scope.login = ->
      Auth.login
        email: $scope.email
        password: $scope.password
      , (credentials) ->
        $location.path if $rootScope.retryPath? and $rootScope.retryPath isnt '/login' then $rootScope.retryPath else '/'
      , (message) ->
        $rootScope.error = message
  ]
