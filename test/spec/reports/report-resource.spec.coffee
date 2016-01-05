'use strict'

describe 'Resource: Report', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'testFixtures', 'views/faq.html', 'views/login.html'

  Report = null
  Config = null
  httpBackend = null
  merchantId = 'the-merchant-id'
  venueId = 'the-venue-id'

  beforeEach inject (_Report_, _Config_, $httpBackend, Auth) ->
    Report = _Report_
    Config = _Config_
    httpBackend = $httpBackend

    spyOn(Auth, 'getMerchant').andCallFake -> id: merchantId
    spyOn(Auth, 'getVenue').andCallFake -> id: venueId

  afterEach ->
    localStorage.clear()

    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'query', ->
    beforeEach ->
      httpBackend.expectGET("#{Config.baseURL()}/api/merchants/#{merchantId}/venues/#{venueId}/reports").respond 200, {},
        Date: 'Wed, 05 Feb 2014 16:59:27 GMT'

    it 'should use the venue id', ->
      Report.get()
      httpBackend.flush()

    it 'should parse the date header', ->
      report = Report.get()
      httpBackend.flush()

      expect(report.created).toEqual moment('2014-02-05T16:59:27').toDate()

  describe 'custom methods', ->

    report = null

    beforeEach inject (smartReport) ->
      report = new Report(smartReport)

    it 'total tax is the sum of PAYMENT VAT less the sum of REFUND VAT', ->
      expect(report.totalTax()).toBe 126.53

    it 'total gross is the sum of PAYMENT totals less the sum of REFUND totals', ->
      expect(report.totalGross()).toBe 2035.58

    it 'total sales is the sum of PAYMENT totals', ->
      expect(report.totalSales()).toBe 2036.78

    it 'total refunds is the sum of REFUND totals', ->
      expect(report.totalRefunds()).toBe 1.2

    it 'refund count is the total number of refund transactions', ->
      expect(report.refundCount()).toBe 1

    it 'cash in is the sum of CASH PAYMENT totals and CASH IN payments', ->
      expect(report.cashIn()).toBe 1623.6

    it 'cash out is the sum of CASH REFUND totals and CASH OUT payments', ->
      expect(report.cashOut()).toBe 1.2

    it 'closing total is the sum of opening total plus cash in minus cash out', ->
      expect(report.closingTotal()).toBe 1622.3999999999999

    describe 'collated reports', ->
      describe 'byCategory', ->
        it 'should collate PAYMENT and REFUND data for each category', ->
          expect(report.byCategory().length).toBe 11
          expect(_.pluck report.byCategory(), 'category').toContain paymentType for paymentType in ['Cakes/Pastries', 'Ice cream', 'Chocolate animal', 'Sandwiches', 'Toasties', 'Rolls', 'Breakfast Menu', 'Cold Drinks', 'Salads', 'Hot Drinks']

          product = report.byCategory().filter((it) -> it.category is 'Hot Drinks')[0]
          expect(product.payment.total).toBe 826.3
          expect(product.refund.total).toBe 1.2
          expect(product.payment.count).toBe 542
          expect(product.refund.count).toBe 1
          expect(product.net).toBe 825.0999999999999

      describe 'byProduct', ->
        it 'should collate PAYMENT and REFUND data for each product', ->
          product = report.byProduct().filter((it) -> it.title is 'Americano')[0]
          expect(product.payment.total).toBe 211.5
          expect(product.refund.total).toBe 1.2
          expect(product.payment.count).toBe 141
          expect(product.refund.count).toBe 1
          expect(product.net).toBe 210.3

        it 'should fill in blanks with zero values', ->
          product = report.byProduct().filter((it) -> it.title is 'soup')[0]
          expect(product.payment.total).toBe 154.5
          expect(product.payment.count).toBe 36
          expect(product.refund.total).toBe 0
          expect(product.refund.count).toBe 0

        it 'should order by highest grossing product', ->
          actualTotals = report.byProduct().map((it) -> it.payment.total)
          sortedTotals = report.byProduct().map((it) -> it.payment.total).sort((a, b) -> a - b).reverse()
          expect(actualTotals).toEqual sortedTotals

      describe 'topByProduct', ->
        it 'should contain at most 10 products', ->
          expect(report.productReport.products.length).toBeGreaterThan 10
          expect(report.topByProduct().length).toBe 10

