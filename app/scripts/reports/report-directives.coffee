'use strict'

angular.module('smartRegisterApp')

  .directive('cashTransactions', [ ->
    restrict: 'C'
    templateUrl: 'views/partials/reports/cash-transactions.html'
  ])

  .directive('paymentTypesReport', [ ->
    controller: ['$scope', ($scope) ->
      $scope.paymentTypes = [
        paymentType: 'CASH'
        transactionType: 'PAYMENT'
      ,
        paymentType: 'CARD'
        transactionType: 'PAYMENT'
      ,
        paymentType: 'CASH'
        transactionType: 'REFUND'
      ,
        paymentType: 'CARD'
        transactionType: 'REFUND'
      ]
    ]
    restrict: 'C'
    templateUrl: 'views/partials/reports/payment-types-report.html'
  ])

  .directive('categoryReport', [ ->
    replace: true
    restrict: 'E'
    scope:
      report: '='
    templateUrl: 'views/partials/reports/category-report.html'
  ])

  .directive('productReport', [ ->
    replace: true
    restrict: 'E'
    scope:
      report: '='
    templateUrl: 'views/partials/reports/product-report.html'
  ])

  .directive('adHocPaymentsReport', [ ->
    controller: ['$scope', ($scope) ->
      $scope.adHocPaymentsComparator = (it) ->
        n = 0
        n += 4 if it.type is 'EMPLOYEE'
        n += 2 if it.type is 'OUT'
        n += 1 if it.paymentType is 'CARD'
        n
      $scope.paymentsFor = (paymentType, direction, type) ->
        _.filter $scope.paymentLineItems, (lineItem) ->
          lineItem.paymentType is paymentType and lineItem.paymentDirection is direction and lineItem.type is type

    ]
    restrict: 'C'
    scope:
      report: '='
      paymentLineItems: '='
    templateUrl: 'views/partials/reports/ad-hoc-payments.html'
  ])

  .directive('vatBreakdown', [ ->
    link: ($scope) ->
      $scope.$watch 'report', (report) ->
        tax = {}
        _.forEach report.vatReport.vatSummary, (vatSummary) ->
          _.forEach vatSummary.vatSummaryDetails, (it) ->
            current = tax[it.taxRate] ? 0
            tax[it.taxRate] = current + if it.type is 'PAYMENT' then it.total else -it.total
        tax = _.pairs(tax)
        $scope.taxBreakdown = tax
    restrict: 'C'
    scope:
      report: '='
    template: '''
      <h3>VAT breakdown</h3>
      <table class="table table-condensed report-table">
        <tbody>
          <tr data-ng-repeat="row in taxBreakdown">
            <th>{{row[0] | percentage}}</th>
            <td class="currency">{{row[1] | currency:"£"}}</td>
          </tr>
        </tbody>
      </table>
    '''
  ])

  .filter 'array', [->
    (input) ->
      if typeof input is 'array' then input else [input]
  ]
