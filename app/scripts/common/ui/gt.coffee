'use strict'

angular.module('smartRegisterApp')
  .directive 'gt', [->
    require: 'ngModel'
    restrict: 'A'
    link: ($scope, $element, $attrs, model) ->
      # update this field's value when the dependent one changes
      $scope.$watch $attrs.gt, (newValue) ->
        model.$setViewValue model.$viewValue
        $element.trigger 'change'

      # validate during parse
      model.$parsers.push (viewValue) ->
        otherValue = $scope.$eval $attrs.gt
        newValue = model.$modelValue
        if viewValue > otherValue
          model.$setValidity 'gt', true
          newValue = viewValue
        else
          model.$setValidity 'gt', false
        newValue
  ]
