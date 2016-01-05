'use strict'

describe 'Resource: Order', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'testFixtures', 'views/faq.html', 'views/login.html'

  Order = null
  Config = null
  $httpBackend = null
  merchantId = 'the-merchant-id'
  venueId = 'the-venue-id'
  fixtures = {}

  beforeEach inject (_Config_, _Order_, Auth, _$httpBackend_, simpleOrder, refundedOrder, fullRefundOrder) ->
    Config = _Config_
    Order = _Order_
    $httpBackend = _$httpBackend_
    fixtures.simpleOrder = simpleOrder
    fixtures.refundedOrder = refundedOrder
    fixtures.fullRefundOrder = fullRefundOrder

    spyOn(Auth, 'getMerchant').andCallFake -> id: merchantId
    spyOn(Auth, 'getVenue').andCallFake -> id: venueId

  afterEach ->
    localStorage.clear()

    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  describe 'REST API', ->
    describe 'retrieving data', ->
      it 'should retrieve a list of orders', ->
        $httpBackend.expectGET("#{Config.baseURL()}/api/merchants/#{merchantId}/venues/#{venueId}/orders?sort=created,desc").respond JSON.stringify content: [fixtures.simpleOrder]

        orders = Order.query()
        $httpBackend.flush()

        expect(orders.length).toBe 1
        expect(_.pluck orders, 'orderId').toEqual [fixtures.simpleOrder.orderId]

      it 'should search for orders', ->
        $httpBackend.expectGET("#{Config.baseURL()}/api/merchants/#{merchantId}/venues/#{venueId}/orders?orderId=#{fixtures.simpleOrder.orderId}&sort=created,desc").respond JSON.stringify content: [fixtures.simpleOrder]

        orders = Order.query orderId: fixtures.simpleOrder.orderId
        $httpBackend.flush()

        expect(orders.length).toBe 1
        expect(_.pluck orders, 'orderId').toEqual [fixtures.simpleOrder.orderId]

    describe 'refunding an order', ->
      order = null

      beforeEach ->
        $httpBackend.whenGET("#{Config.baseURL()}/api/merchants/#{merchantId}/venues/#{venueId}/orders/#{fixtures.simpleOrder.id}").respond fixtures.simpleOrder
        order = Order.get id: fixtures.simpleOrder.id
        $httpBackend.flush()

      describe 'if no items are specified in the PUT body', ->
        it 'should refund all items', ->
          $httpBackend.expectPUT "#{Config.baseURL()}/api/merchants/#{merchantId}/venues/#{venueId}/orders/#{fixtures.simpleOrder.id}",
            items: []
          .respond fixtures.fullRefundOrder

          order.$refund
            id: fixtures.simpleOrder.id
          $httpBackend.flush()

          expect(order.status).toBe "REFUNDED"

      describe 'if an item is specified in the PUT body', ->
        it 'should refund only that item', ->
          $httpBackend.expectPUT "#{Config.baseURL()}/api/merchants/#{merchantId}/venues/#{venueId}/orders/#{fixtures.simpleOrder.id}",
            items: [order.basket.items[2].id]
          .respond fixtures.refundedOrder

          order.basket.items[2].toRefund = true
          order.$refund
            id: fixtures.simpleOrder.id
          $httpBackend.flush()

          expect(_.pluck order.basket.items, 'state').toEqual ["PAID", "PAID", "REFUNDED"]
