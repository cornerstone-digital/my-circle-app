'use strict'

angular.module('smartRegisterApp')
  .directive 'loggedInAs', ->
    replace: true
    restrict: 'C'
    scope: true
    template: '<span data-ng-show="username()">{{username()}}</span>'
    controller: ['$scope', 'Auth', ($scope, Auth) ->
      $scope.username = ->
        Auth.getCredentials()?.username
    ]
