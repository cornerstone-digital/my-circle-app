'use strict'

describe 'Directive: foursquareUser', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'views/faq.html', 'views/login.html'

  $scope = null
  $httpBackend = null
  element = null

  beforeEach inject ($rootScope, _$httpBackend_, $compile) ->
    $httpBackend = _$httpBackend_

    $scope = $rootScope.$new()
    element = angular.element '<div><foursquare-user tool="tool"></foursquare-user></div>'
    element = $compile(element) $scope

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  describe 'when there is no foursquare account', ->

    beforeEach ->
      $scope.$apply ->
        $scope.tool = null

    it 'should not display anything', ->
      expect(element.children()).toBeEmpty()

  describe 'when there is a foursquare account', ->

    beforeEach ->
      $httpBackend.expectGET("https://api.foursquare.com/v2/users/self?oauth_token=the-oauth-token&v=#{moment().format('YYYYMMDD')}").respond 200,
        meta:
          code: 200
        response:
          user:
            id: "70509732"
            firstName: "F"
            lastName: "Zlem"
            gender: "none"
            relationship: "self"
            photo:
              prefix: "https://irs0.4sqi.net/img/user/"
              suffix: "/FHJKDNYFQOGUSMLU.jpg"
            createdAt: 1383150800
            referralId: "u-70509732"

      $scope.$apply ->
        $scope.tool =
          properties:
            token: 'the-oauth-token'

      $httpBackend.flush()

    it 'replaces the element', ->
      expect(element.children().eq(0)).toBeA 'figure'

    it 'should retrieve the user data from foursquare', ->
      expect(element.find('img').attr('src')).toBe 'https://irs0.4sqi.net/img/user/64x64/FHJKDNYFQOGUSMLU.jpg'
      expect(element.find('figcaption .name').text()).toBe 'F Zlem'
