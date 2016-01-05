'use strict'

angular.module('smartRegisterApp')
.controller('ProductReportCtrl', ['$scope', 'Report', 'report', ($scope, Report, report) ->

  $scope.report = report

  $scope.byProduct = -> $scope.reports.map (it) -> it.byProduct()

  ###
  The update function that changes the date range for the report.
  ###
  $scope.$on 'report:update', (event, params) ->
    Report.get params, (report) ->
      $scope.report = report

  $scope.csvFilename = ->
    from = moment($scope.report.dateRange.from).startOf('day')
    to = moment($scope.report.dateRange.to).startOf('day')
    name = 'products_'
    name += from.format('YYYY-MM-DD')
    unless from.isSame(to)
      name += '_'
      name += to.format('YYYY-MM-DD')
    name += '.csv'
    return name
])

