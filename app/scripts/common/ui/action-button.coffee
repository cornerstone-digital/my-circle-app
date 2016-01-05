'use strict';

angular.module('smartRegisterApp')
  .directive('actionButton', [->
    restrict: 'A'
    link: ($scope, $element, $attrs) ->
      originalText = $element.html()
      loadingText = $attrs.loadingText ? 'Loading\u2026'
      $scope.$on "#{$attrs.action}:starting", ->
        $element.prop('disabled', true).html loadingText
      $scope.$on "#{$attrs.action}:complete", ->
        $element.prop('disabled', false).html originalText
  ])
