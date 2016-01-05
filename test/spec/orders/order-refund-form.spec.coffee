'use strict'

describe 'Directive: orderRefundForm', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'testFixtures', 'views/partials/orders/order-refund-form.html', 'views/faq.html', 'views/login.html'

  $scope = null
  element = null
  refundButton = null

  beforeEach inject ($compile, $rootScope, Order, simpleOrder) ->
    $rootScope.order = new Order(angular.copy(simpleOrder))

    element = angular.element '<order-refund-form order="order"/>'
    element = $compile(element) $rootScope
    $rootScope.$digest()

    $scope = element.isolateScope()

    refundButton = element.find('button')

  describe 'displaying the form', ->
    inputs = null

    beforeEach ->
      inputs = element.find('input')

    it 'should have a checkbox for each item in the basket', ->
      expect(inputs.length).toBe $scope.order.basket.items.length
      expect(input.getAttribute('type')).toBe('checkbox') for input in inputs

    describe 'when some but not all items have been refunded', ->
      beforeEach ->
        $scope.order.basket.items[0].state = 'REFUNDED'
        $scope.$digest()

      it 'should disable checkboxes for items that have been refunded', ->
        expect(inputs.eq(0)).toBeDisabled()
        expect(inputs.eq(1)).not.toBeDisabled()

      it 'should enable the button', ->
        expect(refundButton).not.toBeDisabled()

    describe 'when all items have been refunded', ->
      beforeEach ->
        item.state = 'REFUNDED' for item in $scope.order.basket.items
        $scope.$digest()

      it 'should disable the button', ->
        expect(refundButton).toBeDisabled()

  describe 'calculating refund value', ->
    it 'should be the sum of all items in the basket if none are refunded or selected', ->
      expect($scope.refundValue()).toBe 7.75

    it 'should be the sum of all non-refunded items if some have been refunded already', ->
      $scope.order.basket.items[0].state = 'REFUNDED'

      expect($scope.refundValue()).toBe ($scope.order.basket.items[1].total + $scope.order.basket.items[1].adjustment) + ($scope.order.basket.items[2].total + $scope.order.basket.items[2].adjustment)

    it 'should be the sum of all selected items if there are any', ->
      $scope.order.basket.items[0].toRefund = true
      $scope.order.basket.items[2].toRefund = true

      expect($scope.refundValue()).toBe ($scope.order.basket.items[0].total + $scope.order.basket.items[0].adjustment) + ($scope.order.basket.items[2].total + $scope.order.basket.items[2].adjustment)

  describe 'submitting a refund', ->
    startingCallback = null
    completedCallback = null

    beforeEach ->
      startingCallback = jasmine.createSpy()
      completedCallback = jasmine.createSpy()

      $scope.$on 'refund:starting', startingCallback
      $scope.$on 'refund:complete', completedCallback

      spyOn window, 'alert'

    describe 'when a refund is requested', ->
      beforeEach ->
        spyOn $scope.order, '$refund'

        $scope.refund()

      it 'should request a refund of the specified items', ->
        expect($scope.order.$refund).toHaveBeenCalled()
        expect($scope.order.$refund.mostRecentCall.args[0]).toEqual id: $scope.order.id

      it 'should broadcast an event', ->
        expect(startingCallback).toHaveBeenCalled()
        expect(completedCallback).not.toHaveBeenCalled()

    describe 'when a refund succeeds', ->
      beforeEach ->
        spyOn($scope.order, '$refund').andCallFake (params, successCallback, errorCallback) ->
          successCallback $scope.order

        $scope.order.basket.items[0].toRefund = true
        $scope.order.basket.items[1].toRefund = true

        $scope.refund()

      it 'should broadcast an event', ->
        expect(startingCallback).toHaveBeenCalled()
        expect(completedCallback).toHaveBeenCalled()

      it 'should display an alert', ->
        expect(window.alert).toHaveBeenCalledWith "Items with a value of £4.75 refunded"

    describe 'when a refund fails', ->
      beforeEach ->
        spyOn($scope.order, '$refund').andCallFake (params, successCallback, errorCallback) ->
          errorCallback $scope.order

        $scope.refund()

      it 'should broadcast an event', ->
        expect(startingCallback).toHaveBeenCalled()
        expect(completedCallback).toHaveBeenCalled()

      it 'should display an alert', ->
        expect(window.alert).toHaveBeenCalledWith 'Refund failed'
