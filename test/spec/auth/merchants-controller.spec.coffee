# TODO: Update merchants-controller.spec
#'use strict'
#
#describe 'Controller: Merchants', ->
#
#  beforeEach module 'mockEnvironment', 'smartRegisterApp'
#
#  $scope = null
#
#  beforeEach inject ($rootScope, $controller) ->
#    $scope = $rootScope.$new()
#
#    MerchantsCtrl = $controller 'MerchantsCtrl',
#      $scope: $scope
#      merchants: []
#
#    $scope.merchantForm =
#      $valid: true
#
#  describe 'creating a new merchant', ->
#
#    beforeEach ->
#      $scope.create()
#
#    it 'should default the merchant to be active', ->
#      expect($scope.merchant.enabled).toBe true
#
#    it 'should add an empty venue to the scope', ->
#      expect($scope.venue).not.toBeUndefined()
#      expect($scope.venue).toBe $scope.merchant.venues[0]
#
#    it 'should add an empty contact to the venue', ->
#      expect($scope.venue.contacts[0]).not.toBeUndefined()
#      expect($scope.venue.contacts[0].type).toBe 'PHONE'
#
#    it 'should add an empty employee to the scope', ->
#      expect($scope.employee).not.toBeUndefined()
#      expect($scope.employee).toBe $scope.merchant.employees[0]
#
#    it 'should add an empty credential to the scope', ->
#      expect($scope.employee.credentials[0]).not.toBeUndefined()
#      expect($scope.employee.credentials[0].type).toBe 'EMAIL'
#
#    describe 'saving', ->
#
#      $httpBackend = null
#
#      beforeEach inject (Config, _$httpBackend_) ->
#        $httpBackend = _$httpBackend_
#
#        $httpBackend.expectPOST "#{Config.baseURL()}/api/merchants", (data) ->
#          angular.equals JSON.parse(data),
#            name: 'Lucky Dragon'
#            enabled: true
#            venues: [
#              name: 'Lucky Dragon 1'
#              address:
#                line1: 'Winchester House'
#                line2: ''
#                city: 'Marylebone'
#                county: 'London'
#                postCode: 'NW1 5RA'
#              contacts: [
#                type: 'PHONE'
#                value: '02075551337'
#              ]
#              legalName: 'Lucky Dragon Corp'
#              vatNumber: '123456789'
#            ]
#            employees: [
#              firstname: 'Berry'
#              lastname: 'Rydell'
#              email: 'rydell@luckydragon.co.kr'
#              enabled: true
#              credentials: [
#                type: 'EMAIL'
#                uid: 'rydell@luckydragon.co.kr'
#                token: 'pa55w0rd'
#              ]
#              groups: [
#                name: 'MERCHANT_ADMINISTRATORS'
#              ]
#            ]
#        .respond 201,
#          id: 'the-merchant-id'
#          name: 'Lucky Dragon'
#          enabled: true
#
#        $scope.merchant.name = 'Lucky Dragon'
#        $scope.merchant.venues[0].name = 'Lucky Dragon 1'
#        $scope.merchant.venues[0].address =
#          line1: 'Winchester House'
#          line2: ''
#          city: 'Marylebone'
#          county: 'London'
#          postCode: 'NW1 5RA'
#        $scope.merchant.venues[0].contacts[0].value = '02075551337'
#        $scope.merchant.venues[0].legalName = 'Lucky Dragon Corp'
#        $scope.merchant.venues[0].vatNumber = '123456789'
#        $scope.merchant.employees[0].firstname = 'Berry'
#        $scope.merchant.employees[0].lastname = 'Rydell'
#        $scope.merchant.employees[0].email = 'rydell@luckydragon.co.kr'
#        $scope.merchant.employees[0].credentials[0].token = 'pa55w0rd'
#
#        $scope.save()
#
#      afterEach ->
#        $httpBackend.verifyNoOutstandingExpectation()
#        $httpBackend.verifyNoOutstandingRequest()
#
#      describe 'when the API call completes', ->
#
#        beforeEach ->
#          $httpBackend.flush()
#
#        it 'closes the form', ->
#          expect($scope.merchant).toBeUndefined()
#          expect($scope.venue).toBeUndefined()
#          expect($scope.employee).toBeUndefined()
#
#        it 'adds the new merchant to the list', ->
#          expect(_.pluck $scope.merchants, 'name').toContain 'Lucky Dragon'
#
#      describe 'closing the modal before the API call returns', ->
#
#        beforeEach ->
#          $scope.close()
#          $httpBackend.flush()
#
#        it 'closes the form', ->
#          expect($scope.merchant).toBeUndefined()
#          expect($scope.venue).toBeUndefined()
#          expect($scope.employee).toBeUndefined()
#
#        it 'adds the new merchant to the list', ->
#          expect(_.pluck $scope.merchants, 'name').toContain 'Lucky Dragon'
#
#  describe 'editing an existing merchant', ->
#
#    merchant = null
#
#    beforeEach inject (Merchant) ->
#      merchant = new Merchant
#        id: '1'
#        name: 'Lucky Dragon'
#        enabled: true
#      $scope.edit merchant
#
#    it 'should work on a copy of the merchant', ->
#      expect($scope.merchant).not.toBe merchant
#      expect($scope.merchant.id).toBe merchant.id
#      expect($scope.merchant.name).toBe merchant.name
#      expect($scope.merchant.enabled).toBe merchant.enabled
#
#    it 'should not add subsidiary entities to the merchant', ->
#      expect($scope.venue).toBeUndefined()
#      expect($scope.employee).toBeUndefined()
