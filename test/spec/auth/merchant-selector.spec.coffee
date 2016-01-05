'use strict'

describe 'Directive: merchantSelector', ->

  $scope = null
  $element = null
  $route = null
  merchants = null
  Merchant = null
  Auth = null
  MerchantService = null

  beforeEach ->
    $route =
      reload: jasmine.createSpy()

  beforeEach module 'mockEnvironment', 'smartRegisterApp'

  # this overrides the $route service used by the application as otherwise
  # the interceptor ends up getting triggered and forcing load of login.html
  beforeEach module ($provide) ->
    $provide.value '$route', $route
    null

  beforeEach inject ($rootScope, $httpBackend, _Merchant_, _Auth_, _MerchantService_, _Config_) ->
    Auth = _Auth_
    Merchant = _Merchant_
    MerchantService = _MerchantService_
    Config = _Config_

    $scope = $rootScope.$new()

    merchants = [
      id: '1', name: 'Merchant 1', enabled: true
    ,
      id: '2', name: 'Merchant 2', enabled: true
    ,
      id: '3', name: 'Merchant 3', enabled: true
    ,
      id: '4', name: 'Merchant 4', enabled: false
    ]

    $rootScope.merchants = merchants

    spyOn(MerchantService, 'getList').andCallFake()

    spyOn(Auth, 'getMerchant').andCallFake ->
      id: '2'

    $scope.merchant = merchants[1]

    $element = angular.element '<div class="merchant-selector"></div>'

    $httpBackend.expectGET("#{Config.baseURL()}/api/merchants/list")
      .respond merchants

  describe 'when a non-global admin is logged in', ->

    beforeEach inject ($compile) ->

      spyOn(Auth, 'hasRole').andCallFake (permission) -> permission isnt 'PERM_PLATFORM_ADMINISTRATOR'

      $element = $compile($element) $scope
      $scope.$digest()

    it 'does not render the merchant selector', ->
#      expect($element.find('select')).not.toExist()


  describe 'when a global admin is logged in', ->

    beforeEach inject ($compile) ->
#      spyOn(Auth, 'hasRole').andCallFake (permission) -> true

      $element = $compile($element) $scope
      $scope.$digest()

    it 'renders the merchant selector', ->
      expect($element.find('select')).toExist()

    it 'contains an option for each active merchant', ->
      options = $element.find('option')

      angular.forEach merchants, (value, index) ->
        expect(options.eq(index).text()).toBe value.name
        expect(options.eq(index).attr('value')).toBe value.id

    it 'selects the option for the logged in merchant', ->
      expect($element.find('option:selected').attr('value')).toBe '2'

    describe 'when the user selects a merchant', ->

      beforeEach ->
        spyOn(Auth, 'impersonateMerchant').andCallFake (merchant, callback) ->

        $element.find('option').last().prop('selected', true).closest('select').trigger('change')

      it 'should impersonate the merchant', ->
        expect(Auth.impersonateMerchant).toHaveBeenCalled()
        expect(Auth.impersonateMerchant.mostRecentCall.args[0].id).toBe merchants[3].id

    describe 'when a new merchant is created', ->

      originalLength = null

      beforeEach ->
        originalLength = $element.find('option').length

      describe 'that is enabled', ->

        beforeEach ->
          $scope.$root.$broadcast 'merchant:created',
            id: '5'
            name: 'Merchant 5'
            enabled: true
          $scope.$digest()

        it 'should add the new merchant to the selector', ->
          expect($element.find('option').length).toBe originalLength + 1
          expect(_.map $element.find('option'), (it) -> $(it).attr('value')).toContain '5'

      describe 'that is not enabled', ->

        beforeEach ->
          $scope.$root.$broadcast 'merchant:created',
            id: '5'
            name: 'Merchant 5'
            enabled: false
          $scope.$digest()

        it 'should not add the new merchant to the selector', ->
          expect($element.find('option').length).toBe originalLength
          expect(_.map $element.find('option'), (it) -> $(it).attr('value')).not.toContain '5'
