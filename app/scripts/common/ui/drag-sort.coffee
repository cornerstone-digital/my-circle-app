'use strict'

angular.module('smartRegisterApp')
.directive 'dragSort', [->
  scope:
    array: '=dragSort'
    disabled: '=dragDisabled'

  link: ($scope, $element, $attrs) ->
    $element.sortable
      containment: 'body'
      tolerance: 'pointer'
      start: (event, ui) ->
        ui.item.data 'start', ui.item.index()
        $scope.$parent.$broadcast "#{$attrs.dragSort}:#{event.type}"
      update: (event, ui) ->
        start = ui.item.data('start')
        end = ui.item.index()
        $scope.$apply ->
          $scope.array.splice end, 0, $scope.array.splice(start, 1)[0]
        $scope.$emit "#{$attrs.dragSort}:#{event.type}", $scope.array

    $scope.$watch 'disabled', (newValue) ->
      $element.sortable if newValue then 'disable' else 'enable'
]
