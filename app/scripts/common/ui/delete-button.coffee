'use strict';

angular.module('smartRegisterApp')
  .directive 'deleteButton', [->
    scope:
      resource: '='
    restrict: 'A'
    controller: ['$scope', '$element', '$attrs', ($scope, $element, $attrs) ->
      disableButton = -> $element.prop 'disabled', true
      enableButton = -> $element.prop 'disabled', false

      $element.on 'click', ->
        $scope.$emit 'delete:requested', $scope.resource

      $scope.$on 'delete:pending', (event, entity) ->
        disableButton() if entity.id is $scope.resource.id

      $scope.$on 'delete:succeeded', (event, entity) ->
        enableButton() if entity.id is $scope.resource.id

      $scope.$on 'delete:failed', (event, entity) ->
        enableButton() if entity.id is $scope.resource.id
    ]
  ]
