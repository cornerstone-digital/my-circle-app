(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('dateRange', [
    function() {
      return {
        replace: false,
        require: '^form',
        restrict: 'A',
        scope: {
          dateRange: '=',
          disabled: '='
        },
        template: '<select data-ng-model="range" class="form-control input-lg" data-ng-disabled="disabled">\n  <option value="today">Today</option>\n  <option value="yesterday">Yesterday</option>\n  <option value="this-week">This week</option>\n  <option value="last-week">Last week</option>\n  <option value="this-month">This month</option>\n  <option value="last-month">Last month</option>\n  <option value="this-year">This year</option>\n  <option value="custom">Custom date</option>\n</select>\n<span data-ng-hide="range != \'custom\'">\n  <input name="dateRangeFrom" type="datetime-local" data-datetime-local data-ng-model="dateRange.from" data-ng-readonly="range != \'custom\'" data-ng-disabled="disabled" class="form-control input-lg">\n  <label>to</label>\n  <input name="dateRangeTo" type="datetime-local" data-datetime-local data-ng-model="dateRange.to" data-ng-readonly="range != \'custom\'" data-ng-disabled="disabled" class="form-control input-lg">\n</span>\n<p class="error">Invalid date range</p>',
        link: function($scope, $element, $attrs, formController) {
          var validateRange;
          validateRange = function(from, to) {
            if ($scope.range === 'custom' && ((from == null) || (to == null))) {
              return formController.dateRangeTo.$setValidity('range', false);
            } else if (to != null ? to.isBefore(from) : void 0) {
              return formController.dateRangeTo.$setValidity('range', false);
            } else {
              return formController.dateRangeTo.$setValidity('range', true);
            }
          };
          $scope.$watch('dateRange.from', function(value) {
            return validateRange(value, $scope.dateRange.to);
          });
          $scope.$watch('dateRange.to', function(value) {
            return validateRange($scope.dateRange.from, value);
          });
          $scope.$watch('range', function(value) {
            switch (value) {
              case 'custom':
                $scope.dateRange.from = moment().local().startOf('day');
                return $scope.dateRange.to = moment().endOf('day');
              case 'today':
                $scope.dateRange.from = moment().local().startOf('day');
                return $scope.dateRange.to = null;
              case 'yesterday':
                $scope.dateRange.from = moment().local().subtract('days', 1).startOf('day');
                return $scope.dateRange.to = moment().local().startOf('day');
              case 'this-week':
                $scope.dateRange.from = moment().local().startOf('week');
                return $scope.dateRange.to = moment().local().endOf('week');
              case 'last-week':
                $scope.dateRange.from = moment().local().subtract('weeks', 1).startOf('week');
                return $scope.dateRange.to = moment().local().subtract('weeks', 1).endOf('week');
              case 'this-month':
                $scope.dateRange.from = moment().local().startOf('month');
                return $scope.dateRange.to = moment().local().endOf('month');
              case 'last-month':
                $scope.dateRange.from = moment().local().subtract('months', 1).startOf('month');
                return $scope.dateRange.to = moment().local().subtract('months', 1).endOf('month');
              case 'this-year':
                $scope.dateRange.from = moment().local().startOf('year');
                return $scope.dateRange.to = moment().local().endOf('year');
            }
          });
          if ($scope.range == null) {
            return $scope.range = 'today';
          }
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=date-range.js.map
