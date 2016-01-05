(function() {
  'use strict';

  /*
  Directives supporting date/time input types. Values are converted between
  appropriately formatted strings and moment.js objects.
   */
  angular.module('smartRegisterApp').constant('datetimeLocalFormat', 'YYYY-MM-DDTHH:mm').constant('dateFormat', 'YYYY-MM-DD').directive('datetimeLocal', [
    'datetimeLocalFormat', function(format) {
      return {
        require: '?ngModel',
        restrict: 'A',
        link: function(scope, element, attrs, controller) {
          controller.$formatters.push(function(value) {
            return moment(value).local().format(format);
          });
          return controller.$parsers.push(function(value) {
            return moment(value, format).local();
          });
        }
      };
    }
  ]).directive('date', [
    'dateFormat', function(format) {
      return {
        require: '?ngModel',
        restrict: 'A',
        link: function(scope, element, attrs, controller) {
          controller.$formatters.push(function(value) {
            return moment(value).local().format(format);
          });
          return controller.$parsers.push(function(value) {
            return moment(value, format).local();
          });
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=date-time-inputs.js.map
