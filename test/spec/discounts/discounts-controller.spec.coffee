'use strict'

describe 'Controller: Discounts', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp'

  $scope = null
  $httpBackend = null
  Discount = null
  Config = null

  beforeEach inject ($rootScope, $controller, _Discount_, _$httpBackend_, _Config_, Auth) ->
    $scope = $rootScope.$new()
    $httpBackend = _$httpBackend_
    Discount = _Discount_
    Config = _Config_

    spyOn(Auth, 'getMerchant').andCallFake -> id: 'the-merchant-id'
    spyOn(Auth, 'getVenue').andCallFake -> id: 'the-venue-id'

    $controller 'DiscountsCtrl',
      $scope: $scope
      discounts: [
        id: 1
        name: 'student'
        value: 0.1
        groups: [
          name: 'MERCHANT_EMPLOYEE'
        ,
          name: 'VENUE_ADMINISTRATORS'
        ]
      ,
        id: 2
        name: 'staff'
        value: 0.25
        groups: [
          name: 'VENUE_ADMINISTRATORS'
        ]
      ].map (it) -> new Discount(it)

    $scope.discountForm =
      $setPristine: jasmine.createSpy()

  describe 'creating a discount', ->

    beforeEach ->
      $scope.create()

    describe 'saving the new discount', ->

      beforeEach ->
        $httpBackend.expectPOST "#{Config.baseURL()}/api/merchants/the-merchant-id/venues/the-venue-id/discounts",
            name: 'five finger'
            value: 1
            groups: [
              name: 'MERCHANT_EMPLOYEE'
            ]
          .respond 201,
            id: 3
            name: 'five finger'
            value: 1
            groups = [
              id: 1
              name: 'MERCHANT_EMPLOYEE'
            ]

        $scope.discount.name = 'five finger'
        $scope.discount.value = 1
        $scope.discount.groups = [
          name: 'MERCHANT_EMPLOYEE'
        ]

        $scope.discountForm.$valid = true
        $scope.save()

      afterEach ->
        $httpBackend.verifyNoOutstandingExpectation()
        $httpBackend.verifyNoOutstandingRequest()

    describe 'updating a discount', ->

      beforeEach ->
        $httpBackend.expectPUT "#{Config.baseURL()}/api/merchants/the-merchant-id/venues/the-venue-id/discounts/2",
            id: 2
            name: 'employee'
            value: 0.2
            groups: [
              name: 'VENUE_ADMINISTRATORS'
            ,
              name: 'MERCHANT_EMPLOYEE'
            ]
          .respond 200

        $scope.discount.name = 'employee'
        $scope.discount.value = 0.2
        $scope.discount.groups.push
          name: 'MERCHANT_EMPLOYEE'

        $scope.discountForm.$valid = true
        $scope.save()

      afterEach ->
        $httpBackend.verifyNoOutstandingExpectation()
        $httpBackend.verifyNoOutstandingRequest()

        $httpBackend.flush()

        expect($scope.discounts[1].name).toBe 'employee'
        expect($scope.discounts[1].value).toBe 0.2
        expect(_.pluck $scope.discounts[1].groups, 'name').toContain 'VENUE_ADMINISTRATORS'
        expect(_.pluck $scope.discounts[1].groups, 'name').toContain 'MERCHANT_EMPLOYEE'


  describe 'deleting a discount', ->

    beforeEach ->
      $httpBackend.expectDELETE("#{Config.baseURL()}/api/merchants/the-merchant-id/venues/the-venue-id/discounts/2").respond 200

      $scope.delete $scope.discounts[1]

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()
