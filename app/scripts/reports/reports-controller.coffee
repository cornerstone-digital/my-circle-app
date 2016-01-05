'use strict'

angular.module('smartRegisterApp')
  .controller('SmartReportCtrl', ['$scope', '$location', '$filter', 'Report', 'report','Payments', 'payments', ($scope, $location, $filter, Report, report, Payments, payments) ->

    $scope.reports = [report]
    $scope.paymentLineItems = payments
    $scope.openingTotal = parseFloat(localStorage.getItem('openingTotal') ? 0)

    $scope.partialPayments =
      CASH: parseFloat($location.search().cash ? 0)
      CARD: parseFloat($location.search().card ? 0)

    $scope.byCategory = -> $scope.reports.map (it) -> it.byCategory()
    $scope.topByProduct = -> $scope.reports.map (it) -> it.topByProduct()

    $scope.$watch 'openingTotal', (value) ->
      localStorage.setItem 'openingTotal', value

    ###
    The update function that changes the date range for the report.
    ###
    $scope.$on 'report:update', (event, params) ->
      Report.get params, (report) ->
        $scope.reports = [report]

      Payments.query params, (payments) ->
        $scope.paymentLineItems = payments

    $scope.paymentTypeTotal = (report, paymentType, transactionType) ->
      total = report.byPaymentType(paymentType, transactionType)?.total ? 0
      total += $scope.partialPayments[paymentType] if (transactionType is 'PAYMENT')
      total

    # nasty hack to support over-riding to and from date for new year sales!
    if !!$location.search().from && !!$location.search().to
      $scope.update()
  ])

  .controller('ComparisonReportCtrl', ['$scope', '$filter', 'Report', 'report1', 'report2', ($scope, $filter, Report, report1, report2) ->
    $scope.reports = [report1, report2]
    $scope.date = moment(report2.dateRange.from).format('YYYY-MM-DD')
    $scope.compare = 'day'

    $scope.byCategory = -> $scope.reports.map (it) -> it.byCategory()
    $scope.topByProduct = -> $scope.reports.map (it) -> it.topByProduct()

    $scope.reportPeriods = ->
      $scope.reports.map (report) ->
        start = moment(report.dateRange.from)
        end = moment(report.dateRange.to)
        if Math.abs(start.diff(end, 'weeks')) > 1 then start.format 'MMM YYYY'
        else if Math.abs(start.diff(end, 'days')) >= 6 then "w/c #{start.format 'Do MMM YYYY'}"
        else start.format 'Do MMM YYYY'

    ###
    The update function that changes the date range for the report.
    ###
    $scope.update = ->
      report1 = {}
      report2 = {}

      requestedDate = moment($scope.date)

      if $scope.compare is 'day'
        report1.from = requestedDate.clone().subtract('days', 7)
        report1.to = requestedDate.clone().subtract('days', 6)
        report2.from = requestedDate.clone().startOf('day')
        report2.to = requestedDate.clone().add('days', 1)

      if $scope.compare is 'week'
        report1.from = requestedDate.clone().subtract('days', 7)
        report1.to = requestedDate.clone()
        report2.from = requestedDate.clone()
        report2.to = requestedDate.clone().add('days', 7)

      if $scope.compare is 'month'
        report1.from = requestedDate.clone().subtract('months', 1).startOf('month')
        report1.to = requestedDate.clone().startOf('month')
        report2.from = requestedDate.clone().startOf('month')
        report2.to = requestedDate.clone().add('months', 1).startOf('month')

      if $scope.compare is 'year'
        report1.from = requestedDate.clone().subtract('years', 1).startOf('month')
        report1.to = requestedDate.clone().subtract('years', 1).add('months', 1).startOf('month')
        report2.from = requestedDate.clone().startOf('month')
        report2.to = requestedDate.clone().add('months', 1).startOf('month')

      Report.get
        from: report1.from.format('YYYY-MM-DDTHH:mm')
        to: report1.to.format('YYYY-MM-DDTHH:mm')
      , (report) ->
        $scope.reports[0] = report

      Report.get
        from: report2.from.format('YYYY-MM-DDTHH:mm')
        to: report2.to.format('YYYY-MM-DDTHH:mm')
      , (report) ->
        $scope.reports[1] = report
  ])
