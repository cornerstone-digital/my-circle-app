'use strict'

angular.module('smartRegisterApp')
  .directive 'btnLogout', ['$location', 'Auth', ($location, Auth) ->
    restrict: 'C'
    link: (scope, element) ->
      element.on 'click', ->
        Auth.logout()
        $location.path('/login')

      scope.isLoggedIn = ->
        Auth.isLoggedIn()
  ]
