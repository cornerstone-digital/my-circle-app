'use strict'

###
Creates a sortable column header for a table.
###
angular.module('smartRegisterApp')
  .directive('sortable', [->
    replace: false
    restrict: 'A'
    template: '<a href="" data-ng-transclude></a>'
    transclude: true
    link: ($scope, $element, $attrs) ->
      sortableExpr = $attrs.sortable
      $element.delegate 'a', 'click', ->
        $scope.$apply ->
          $scope.reverse = if $scope.sort is sortableExpr then !$scope.reverse else false
          $scope.sort = sortableExpr

      $scope.$watch 'sort', (value) ->
        $element.toggleClass 'active', value is sortableExpr

      $scope.$watch 'reverse', (value) ->
        $element.toggleClass 'desc', value
  ])
