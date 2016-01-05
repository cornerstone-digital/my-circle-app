'use strict'

describe 'Controller: SmartReportCtrl', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'testFixtures', 'views/faq.html', 'views/login.html'

  Report = null
  Payments = null
  $scope = null

  beforeEach inject ($rootScope, _Report_, _Payments_) ->
    $scope = $rootScope.$new()
    Report = _Report_
    Payments = _Payments_

  afterEach ->
    localStorage.clear()

  describe 'with no POS data', ->

    beforeEach inject ($controller, smartReport) ->
      $controller 'SmartReportCtrl',
        $scope: $scope
        Report: Report
        report: smartReport
        Payment: Payments
        payments: []

    it 'should attach the report data to the scope', ->
      expect($scope.reports.length).toBe 1
      expect($scope.reports[0]).toBe
      expect($scope.reports[0].categoryReport.categories.length).toBe 12
      expect($scope.reports[0].productReport.products.length).toBe 141
      expect($scope.reports[0].zReport.summary.length).toBe 4


    describe 'changing the report date range', ->
      beforeEach ->
        spyOn Report, 'get'

      describe 'with only a from date', ->

        beforeEach ->
          $scope.$broadcast 'report:update',
            from: '2013-08-30T00:00'

        it 'should request data for the entered date', ->
          expect(Report.get).toHaveBeenCalled()
          expect(Report.get.mostRecentCall.args[0]).toEqual
            from: '2013-08-30T00:00'

      describe 'with a from and to date', ->

        beforeEach ->
          $scope.$broadcast 'report:update',
            from: '2013-08-30T00:00'
            to: '2013-09-30T00:00'

        it 'should request data for the entered date', ->
          expect(Report.get).toHaveBeenCalled()
          expect(Report.get.mostRecentCall.args[0]).toEqual
            from: '2013-08-30T00:00'
            to: '2013-09-30T00:00'

      describe 'changing the opening total', ->

        it 'should save the openingTotal in localStorage', ->
          $scope.$apply -> $scope.openingTotal = 123.45

          expect(parseFloat(localStorage.getItem 'openingTotal')).toEqual(123.45)

  describe 'persisting the openingTotal', ->

    beforeEach inject ($controller, smartReport) ->
      localStorage.setItem 'openingTotal', 43.21

      $controller 'SmartReportCtrl',
        $scope: $scope
        Report: Report
        report: smartReport
        Payment: Payments
        payments: []

    it 'should attach the openingTotal from localStorage if present', ->
      localStorage.setItem 'openingTotal', 43.21
      expect($scope.openingTotal).toEqual(43.21)
