(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('cashTransactions', [
    function() {
      return {
        restrict: 'C',
        templateUrl: 'views/partials/reports/cash-transactions.html'
      };
    }
  ]).directive('paymentTypesReport', [
    function() {
      return {
        controller: [
          '$scope', function($scope) {
            return $scope.paymentTypes = [
              {
                paymentType: 'CASH',
                transactionType: 'PAYMENT'
              }, {
                paymentType: 'CARD',
                transactionType: 'PAYMENT'
              }, {
                paymentType: 'CASH',
                transactionType: 'REFUND'
              }, {
                paymentType: 'CARD',
                transactionType: 'REFUND'
              }
            ];
          }
        ],
        restrict: 'C',
        templateUrl: 'views/partials/reports/payment-types-report.html'
      };
    }
  ]).directive('categoryReport', [
    function() {
      return {
        replace: true,
        restrict: 'E',
        scope: {
          report: '='
        },
        templateUrl: 'views/partials/reports/category-report.html'
      };
    }
  ]).directive('productReport', [
    function() {
      return {
        replace: true,
        restrict: 'E',
        scope: {
          report: '='
        },
        templateUrl: 'views/partials/reports/product-report.html'
      };
    }
  ]).directive('adHocPaymentsReport', [
    function() {
      return {
        controller: [
          '$scope', function($scope) {
            $scope.adHocPaymentsComparator = function(it) {
              var n;
              n = 0;
              if (it.type === 'EMPLOYEE') {
                n += 4;
              }
              if (it.type === 'OUT') {
                n += 2;
              }
              if (it.paymentType === 'CARD') {
                n += 1;
              }
              return n;
            };
            return $scope.paymentsFor = function(paymentType, direction, type) {
              return _.filter($scope.paymentLineItems, function(lineItem) {
                return lineItem.paymentType === paymentType && lineItem.paymentDirection === direction && lineItem.type === type;
              });
            };
          }
        ],
        restrict: 'C',
        scope: {
          report: '=',
          paymentLineItems: '='
        },
        templateUrl: 'views/partials/reports/ad-hoc-payments.html'
      };
    }
  ]).directive('vatBreakdown', [
    function() {
      return {
        link: function($scope) {
          return $scope.$watch('report', function(report) {
            var tax;
            tax = {};
            _.forEach(report.vatReport.vatSummary, function(vatSummary) {
              return _.forEach(vatSummary.vatSummaryDetails, function(it) {
                var current, _ref;
                current = (_ref = tax[it.taxRate]) != null ? _ref : 0;
                return tax[it.taxRate] = current + (it.type === 'PAYMENT' ? it.total : -it.total);
              });
            });
            tax = _.pairs(tax);
            return $scope.taxBreakdown = tax;
          });
        },
        restrict: 'C',
        scope: {
          report: '='
        },
        template: '<h3>VAT breakdown</h3>\n<table class="table table-condensed report-table">\n  <tbody>\n    <tr data-ng-repeat="row in taxBreakdown">\n      <th>{{row[0] | percentage}}</th>\n      <td class="currency">{{row[1] | currency:"£"}}</td>\n    </tr>\n  </tbody>\n</table>'
      };
    }
  ]).filter('array', [
    function() {
      return function(input) {
        if (typeof input === 'array') {
          return input;
        } else {
          return [input];
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=report-directives.js.map
