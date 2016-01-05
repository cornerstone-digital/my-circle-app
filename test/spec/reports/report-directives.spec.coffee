'use strict'

describe 'Directive: reportsDirective', ->
  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'views/partials/reports/ad-hoc-payments.html'

  $scope = null
  $isolateScope = null
  $element = null

  beforeEach inject ($rootScope, $compile) ->
    $scope = $rootScope.$new()
    $scope.report = {}
    $scope.paymentLineItems = [
      description:"Window cleaner"
      type:"SUPPLIER"
      paymentType:"CASH"
      paymentDirection:"OUT"
      subTotal:30.00
      taxRate:0.00
      taxTotal:0.00
      total:30.00
    ,
      description:"Loan Payment"
      type:"SUPPLIER"
      paymentType:"CASH"
      paymentDirection:"IN"
      subTotal:30.00
      taxRate:0.00
      taxTotal:0.00
      total:30.00
    ]


    $element = angular.element '<span class="ad-hoc-payments-report" data-report="report" data-payment-line-items="paymentLineItems"></span>'
    $element = $compile($element) $scope

    $scope.$digest()
    $isolateScope = $element.isolateScope()

  it 'paymentsFor should return an array of paymentLineItems filtered by type, paymentType and direction', ->

    expect(_.pluck $isolateScope.paymentsFor('CASH', 'IN', 'SUPPLIER'), 'description').toEqual ['Loan Payment']

