'use strict'

describe 'Controller: OrdersCtrl', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'testFixtures', 'views/faq.html', 'views/login.html'

  OrdersCtrl = null
  scope = null
  Order = null
  httpBackend = null
  fixtures = {}
  venueId = 'the-venue-id'

  beforeEach inject ($controller, $rootScope, _Order_, $httpBackend, Auth, simpleOrder) ->
    scope = $rootScope.$new()
    Order = _Order_
    httpBackend = $httpBackend
    OrdersCtrl = $controller 'OrdersCtrl',
      $scope: scope
      Order: Order
      orders: []

    fixtures.simpleOrder = simpleOrder

    spyOn(Auth, 'getVenue').andCallFake ->
      id: venueId

  afterEach ->
    localStorage.clear()

    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'searching for orders', ->
    describe 'when the search is triggered', ->
      beforeEach ->
        spyOn Order, 'query'

      it 'should execute an order search based on the input', ->
        scope.orderId = fixtures.simpleOrder.orderId
        scope.search()

        expect(Order.query).toHaveBeenCalled()
        expect(Order.query.mostRecentCall.args[0]).toEqual
          orderId: scope.orderId
          from: '1970-01-01T00:00'

      describe 'when there are search results already displayed', ->
        beforeEach ->
          scope.orders = [fixtures.simpleOrder]
          scope.orderId = fixtures.simpleOrder.orderId
          scope.search()

        it 'should clear the existing search results', ->
          expect(scope.orders.length).toBe 0

    describe 'when the search succeeds', ->
      beforeEach ->
        spyOn(Order, 'query').andCallFake (parameters, successCallback, failureCallback) ->
          successCallback [fixtures.simpleOrder]
        scope.orderId = fixtures.simpleOrder.orderId
        scope.search()

      it 'should attach the search results to the scope', ->
        expect(scope.orders.length).toBe 1
        expect(_.pluck scope.orders, 'id').toEqual [fixtures.simpleOrder.id]

    describe 'when an order is updated', ->

      updatedOrder = null

      beforeEach ->
        scope.orders.push fixtures.simpleOrder

        updatedOrder = angular.copy fixtures.simpleOrder
        updatedOrder.status = 'REFUNDED'
        updatedOrder.updated = moment().toISOString()

        scope.$emit 'order:updated', updatedOrder

      it 'should replace the updated order in scope', ->
        expect(scope.orders.length).toBe 1
        expect(_.pluck scope.orders, 'status').toEqual ['REFUNDED']
