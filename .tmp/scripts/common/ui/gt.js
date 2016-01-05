(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('gt', [
    function() {
      return {
        require: 'ngModel',
        restrict: 'A',
        link: function($scope, $element, $attrs, model) {
          $scope.$watch($attrs.gt, function(newValue) {
            model.$setViewValue(model.$viewValue);
            return $element.trigger('change');
          });
          return model.$parsers.push(function(viewValue) {
            var newValue, otherValue;
            otherValue = $scope.$eval($attrs.gt);
            newValue = model.$modelValue;
            if (viewValue > otherValue) {
              model.$setValidity('gt', true);
              newValue = viewValue;
            } else {
              model.$setValidity('gt', false);
            }
            return newValue;
          });
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=gt.js.map
