'use strict'

angular.module('smartRegisterApp')
  .directive('requiresTool', ['Auth', (Auth) ->
    restrict: 'A'
    scope: true
    link: ($scope, $element, $attrs) ->
      toolId = $attrs.requiresTool
      $scope.$on 'auth:updated', ->
        $element.toggleClass 'ng-hide', !Auth.hasTool(toolId)
  ])
