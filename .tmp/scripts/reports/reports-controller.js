(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('SmartReportCtrl', [
    '$scope', '$location', '$filter', 'Report', 'report', 'Payments', 'payments', function($scope, $location, $filter, Report, report, Payments, payments) {
      var _ref, _ref1, _ref2;
      $scope.reports = [report];
      $scope.paymentLineItems = payments;
      $scope.openingTotal = parseFloat((_ref = localStorage.getItem('openingTotal')) != null ? _ref : 0);
      $scope.partialPayments = {
        CASH: parseFloat((_ref1 = $location.search().cash) != null ? _ref1 : 0),
        CARD: parseFloat((_ref2 = $location.search().card) != null ? _ref2 : 0)
      };
      $scope.byCategory = function() {
        return $scope.reports.map(function(it) {
          return it.byCategory();
        });
      };
      $scope.topByProduct = function() {
        return $scope.reports.map(function(it) {
          return it.topByProduct();
        });
      };
      $scope.$watch('openingTotal', function(value) {
        return localStorage.setItem('openingTotal', value);
      });

      /*
      The update function that changes the date range for the report.
       */
      $scope.$on('report:update', function(event, params) {
        Report.get(params, function(report) {
          return $scope.reports = [report];
        });
        return Payments.query(params, function(payments) {
          return $scope.paymentLineItems = payments;
        });
      });
      $scope.paymentTypeTotal = function(report, paymentType, transactionType) {
        var total, _ref3, _ref4;
        total = (_ref3 = (_ref4 = report.byPaymentType(paymentType, transactionType)) != null ? _ref4.total : void 0) != null ? _ref3 : 0;
        if (transactionType === 'PAYMENT') {
          total += $scope.partialPayments[paymentType];
        }
        return total;
      };
      if (!!$location.search().from && !!$location.search().to) {
        return $scope.update();
      }
    }
  ]).controller('ComparisonReportCtrl', [
    '$scope', '$filter', 'Report', 'report1', 'report2', function($scope, $filter, Report, report1, report2) {
      $scope.reports = [report1, report2];
      $scope.date = moment(report2.dateRange.from).format('YYYY-MM-DD');
      $scope.compare = 'day';
      $scope.byCategory = function() {
        return $scope.reports.map(function(it) {
          return it.byCategory();
        });
      };
      $scope.topByProduct = function() {
        return $scope.reports.map(function(it) {
          return it.topByProduct();
        });
      };
      $scope.reportPeriods = function() {
        return $scope.reports.map(function(report) {
          var end, start;
          start = moment(report.dateRange.from);
          end = moment(report.dateRange.to);
          if (Math.abs(start.diff(end, 'weeks')) > 1) {
            return start.format('MMM YYYY');
          } else if (Math.abs(start.diff(end, 'days')) >= 6) {
            return "w/c " + (start.format('Do MMM YYYY'));
          } else {
            return start.format('Do MMM YYYY');
          }
        });
      };

      /*
      The update function that changes the date range for the report.
       */
      return $scope.update = function() {
        var requestedDate;
        report1 = {};
        report2 = {};
        requestedDate = moment($scope.date);
        if ($scope.compare === 'day') {
          report1.from = requestedDate.clone().subtract('days', 7);
          report1.to = requestedDate.clone().subtract('days', 6);
          report2.from = requestedDate.clone().startOf('day');
          report2.to = requestedDate.clone().add('days', 1);
        }
        if ($scope.compare === 'week') {
          report1.from = requestedDate.clone().subtract('days', 7);
          report1.to = requestedDate.clone();
          report2.from = requestedDate.clone();
          report2.to = requestedDate.clone().add('days', 7);
        }
        if ($scope.compare === 'month') {
          report1.from = requestedDate.clone().subtract('months', 1).startOf('month');
          report1.to = requestedDate.clone().startOf('month');
          report2.from = requestedDate.clone().startOf('month');
          report2.to = requestedDate.clone().add('months', 1).startOf('month');
        }
        if ($scope.compare === 'year') {
          report1.from = requestedDate.clone().subtract('years', 1).startOf('month');
          report1.to = requestedDate.clone().subtract('years', 1).add('months', 1).startOf('month');
          report2.from = requestedDate.clone().startOf('month');
          report2.to = requestedDate.clone().add('months', 1).startOf('month');
        }
        Report.get({
          from: report1.from.format('YYYY-MM-DDTHH:mm'),
          to: report1.to.format('YYYY-MM-DDTHH:mm')
        }, function(report) {
          return $scope.reports[0] = report;
        });
        return Report.get({
          from: report2.from.format('YYYY-MM-DDTHH:mm'),
          to: report2.to.format('YYYY-MM-DDTHH:mm')
        }, function(report) {
          return $scope.reports[1] = report;
        });
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=reports-controller.js.map
