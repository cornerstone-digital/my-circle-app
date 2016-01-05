(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('SoldStockReportCtrl', [
    '$scope', 'Report', 'report', function($scope, Report, report) {
      $scope.report = report;
      $scope.sort = 'total';
      $scope.reverse = true;

      /*
      The update function that changes the date range for the report.
       */
      return $scope.$on('report:update', function(event, params) {
        params.type = 'SOLD_STOCK';
        return Report.get(params, function(report) {
          return $scope.report = report;
        });
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=sold-stock-report-controller.js.map
