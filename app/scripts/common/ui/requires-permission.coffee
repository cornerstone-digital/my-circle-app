'use strict'

angular.module('smartRegisterApp')
  .directive('requiresPermission', ['Auth', (Auth) ->
    restrict: 'A'
    scope: true
    controller: ['$scope','Auth', ($scope, Auth) ->
      $scope.toggleClass = (permission, element) ->
        element.toggleClass 'ng-hide', !Auth.hasRole(permission)
    ]

    link: ($scope, $element, $attrs) ->
      permission = $attrs.requiresPermission

      $scope.toggleClass(permission, $element)

      $scope.$on 'auth:updated', ->
        $scope.toggleClass(permission, $element)
  ])
