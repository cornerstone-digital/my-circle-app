(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('after', [
    function() {
      return {
        require: 'ngModel',
        restrict: 'A',
        link: function($scope, $element, $attrs, model) {
          $scope.$watch($attrs.after, function(newValue) {
            model.$setViewValue(model.$viewValue);
            return $element.trigger('change');
          });
          return model.$parsers.push(function(viewValue) {
            var newValue, otherValue;
            otherValue = $scope.$eval($attrs.after);
            newValue = model.$modelValue;
            if (viewValue.isAfter(otherValue)) {
              model.$setValidity('after', true);
              newValue = viewValue;
            } else {
              model.$setValidity('after', false);
            }
            return newValue;
          });
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=moment-comparison.js.map
