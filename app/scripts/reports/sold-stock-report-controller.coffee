'use strict'

angular.module('smartRegisterApp')
  .controller 'SoldStockReportCtrl', ['$scope', 'Report', 'report', ($scope, Report, report) ->

    $scope.report = report
    $scope.sort = 'total'
    $scope.reverse = true

    ###
    The update function that changes the date range for the report.
    ###
    $scope.$on 'report:update', (event, params) ->
      params.type = 'SOLD_STOCK'

      Report.get params, (report) ->
        $scope.report = report
]
