(function() {
  'use strict';

  /*
  An input that accepts percentage values but is backed by a float. e.g. 10 == 0.1
   */
  angular.module('smartRegisterApp').directive('percentageInput', [
    function() {
      return {
        require: '?ngModel',
        link: function(scope, element, attrs, controller) {
          controller.$formatters.push(function(value) {
            if (value) {
              return value * 100;
            } else {
              return null;
            }
          });
          return controller.$parsers.push(function(value) {
            if (value) {
              return parseInt(value) / 100;
            } else {
              return null;
            }
          });
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=percentage-input.js.map
