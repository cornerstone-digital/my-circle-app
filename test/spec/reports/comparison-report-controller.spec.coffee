'use strict'

describe 'Controller: ComparisonReportCtrl', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'testFixtures'

  Report = null
  scope = null

  beforeEach inject ($controller, $rootScope, _Report_, smartReport) ->
    scope = $rootScope.$new()
    Report = _Report_
    $controller 'ComparisonReportCtrl',
      $scope: scope
      Report: Report
      report1: new Report
        dateRange:
          from: "2014-01-21T00:00:00Z"
          to: "2014-01-22T00:00:00Z"
        categoryReport: {}
        productReport: {}
        paymentReport: {}
        vatReport:
          vat: [
            type: "PAYMENT"
            tax: 0.00
          ,
            type: "REFUND"
            tax: 0.00
          ]
        zReport:
          summary: [
            type: "REFUND"
            paymentType: "CASH"
            count: 0
            total: 0.00
            average: 0.00
            max: 0.00
            min: 0.00
          ,
            type: "REFUND"
            paymentType: "CARD"
            count: 0
            total: 0.00
            average: 0.00
            max: 0.00
            min: 0.00
          ,
            type: "PAYMENT"
            paymentType: "CARD"
            count: 0
            total: 0.00
            average: 0.00
            max: 0.00
            min: 0.00
          ,
            type: "PAYMENT"
            paymentType: "CASH"
            count: 0
            total: 0.00
            average: 0.00
            max: 0.00
            min: 0.00
          ]
      report2: new Report
        dateRange:
          from: "2014-01-28T00:00:00Z"
          to: "2014-01-29T00:00:00Z"
        categoryReport: {}
        productReport: {}
        paymentReport: {}
        vatReport:
          vat: [
            type: "PAYMENT"
            tax: 0.00
          ,
            type: "REFUND"
            tax: 0.00
          ]
        zReport:
          summary: [
            type: "REFUND"
            paymentType: "CASH"
            count: 0
            total: 0.00
            average: 0.00
            max: 0.00
            min: 0.00
          ,
            type: "REFUND"
            paymentType: "CARD"
            count: 0
            total: 0.00
            average: 0.00
            max: 0.00
            min: 0.00
          ,
            type: "PAYMENT"
            paymentType: "CARD"
            count: 0
            total: 0.00
            average: 0.00
            max: 0.00
            min: 0.00
          ,
            type: "PAYMENT"
            paymentType: "CASH"
            count: 0
            total: 0.00
            average: 0.00
            max: 0.00
            min: 0.00
          ]

  it 'should default the comparison type to "day"', ->
    expect(scope.compare).toBe 'day'

  it 'should set the report date to the start date of the later report', ->
    expect(scope.date).toBe '2014-01-28'

  it 'should attach multiple reports to the scope', ->
    expect(scope.reports.length).toBe 2

  it 'should extract the correct date labels from the reports', ->
    expect(scope.reportPeriods()).toEqual ['21st Jan 2014', '28th Jan 2014']

  describe 'displaying the date range', ->
    describe 'for a day comparison', ->
      it 'should describe the reports as dates', ->
        expect(scope.reportPeriods()[0]).toBe '21st Jan 2014'

    describe 'for a week comparison', ->
      beforeEach ->
        scope.reports[0].dateRange.from = '2014-01-14T00:00:00Z'

      it 'should describe the reports as day ranges', ->
        expect(scope.reportPeriods()[0]).toBe 'w/c 14th Jan 2014'

    describe 'for a month comparison', ->
      beforeEach ->
        scope.reports[0].dateRange.from = '2014-01-01T00:00:00Z'
        scope.reports[0].dateRange.to = '2014-02-01T00:00:00Z'

      it 'should describe the reports as months', ->
        expect(scope.reportPeriods()[0]).toBe 'Jan 2014'

  describe 'changing the report date', ->
    beforeEach ->
      spyOn Report, 'get'

    describe 'comparing with the same day in the previous week', ->
      beforeEach ->
        scope.compare = 'day'

        scope.date = '2013-08-30'
        scope.update()

      it 'should make 2 API calls', ->
        expect(Report.get.callCount).toBe 2

      it 'should request report for the requested date', ->
        expect(Report.get.argsForCall[1][0]).toEqual
          from: '2013-08-30T00:00'
          to: '2013-08-31T00:00'

      it 'should request report for the day one week before', ->
        expect(Report.get.argsForCall[0][0]).toEqual
          from: '2013-08-23T00:00'
          to: '2013-08-24T00:00'

    describe 'comparing with the previous week', ->
      beforeEach ->
        scope.compare = 'week'

        scope.date = '2013-09-18'
        scope.update()

      it 'should make 2 API calls', ->
        expect(Report.get.callCount).toBe 2

      it 'should request report for the week starting on the requested date', ->
        expect(Report.get.argsForCall[1][0]).toEqual
          from: '2013-09-18T00:00'
          to: '2013-09-25T00:00'

      it 'should request report for the previous week', ->
        expect(Report.get.argsForCall[0][0]).toEqual
          from: '2013-09-11T00:00'
          to: '2013-09-18T00:00'

    describe 'comparing with the previous month', ->
      beforeEach ->
        scope.compare = 'month'

        scope.date = '2013-09'
        scope.update()

      it 'should make 2 API calls', ->
        expect(Report.get.callCount).toBe 2

      it 'should request report for the requested month', ->
        expect(Report.get.argsForCall[1][0]).toEqual
          from: '2013-09-01T00:00'
          to: '2013-10-01T00:00'

      it 'should request report for the previous month', ->
        expect(Report.get.argsForCall[0][0]).toEqual
          from: '2013-08-01T00:00'
          to: '2013-09-01T00:00'

    describe 'comparing with the previous year', ->
      beforeEach ->
        scope.compare = 'year'

        scope.date = '2013-09'
        scope.update()

      it 'should make 2 API calls', ->
        expect(Report.get.callCount).toBe 2

      it 'should request report for the requested month', ->
        expect(Report.get.argsForCall[1][0]).toEqual
          from: '2013-09-01T00:00'
          to: '2013-10-01T00:00'

      it 'should request report for the same month the previous year', ->
        expect(Report.get.argsForCall[0][0]).toEqual
          from: '2012-09-01T00:00'
          to: '2012-10-01T00:00'
