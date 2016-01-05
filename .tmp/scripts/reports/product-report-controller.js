(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('ProductReportCtrl', [
    '$scope', 'Report', 'report', function($scope, Report, report) {
      $scope.report = report;
      $scope.byProduct = function() {
        return $scope.reports.map(function(it) {
          return it.byProduct();
        });
      };

      /*
      The update function that changes the date range for the report.
       */
      $scope.$on('report:update', function(event, params) {
        return Report.get(params, function(report) {
          return $scope.report = report;
        });
      });
      return $scope.csvFilename = function() {
        var from, name, to;
        from = moment($scope.report.dateRange.from).startOf('day');
        to = moment($scope.report.dateRange.to).startOf('day');
        name = 'products_';
        name += from.format('YYYY-MM-DD');
        if (!from.isSame(to)) {
          name += '_';
          name += to.format('YYYY-MM-DD');
        }
        name += '.csv';
        return name;
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=product-report-controller.js.map
