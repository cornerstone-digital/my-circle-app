'use strict'

describe 'Controller: ProductReportCtrl', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'testFixtures'

  $scope = null

  beforeEach inject ($rootScope, $controller, Report, smartReport) ->
    $scope = $rootScope.$new()

    $controller 'ProductReportCtrl',
      $scope: $scope
      Report: Report
      report: angular.copy(smartReport)

  describe 'CSV file generation', ->

    describe 'download filename', ->

      describe 'when the start and end dates of the report are the same', ->

        beforeEach ->
          $scope.report.dateRange.to = $scope.report.dateRange.from

        it 'should generate the filename based on the report range', ->
          expect($scope.csvFilename()).toBe "products_#{$scope.report.dateRange.from.substr(0, 10)}.csv"

      describe 'when the start and end dates of the report are different', ->

        it 'should generate the filename based on the report range', ->
          expect($scope.csvFilename()).toBe "products_#{$scope.report.dateRange.from.substr(0, 10)}_#{$scope.report.dateRange.to.substr(0, 10)}.csv"
