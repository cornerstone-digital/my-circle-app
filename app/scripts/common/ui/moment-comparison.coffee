'use strict'

angular.module('smartRegisterApp')
  .directive 'after', [->
    require: 'ngModel'
    restrict: 'A'
    link: ($scope, $element, $attrs, model) ->
      # update this field's value when the dependent one changes
      $scope.$watch $attrs.after, (newValue) ->
        model.$setViewValue model.$viewValue
        $element.trigger 'change'

      # validate during parse
      model.$parsers.push (viewValue) ->
        otherValue = $scope.$eval $attrs.after
        newValue = model.$modelValue
        if viewValue.isAfter otherValue
          model.$setValidity 'after', true
          newValue = viewValue
        else
          model.$setValidity 'after', false
        newValue
  ]
