'use strict'

describe 'Controller: OAuth', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp'

  $httpBackend = null
  $routeParams = null
  $location = null
  Config = null
  Tool = null

  beforeEach inject ($controller, _$httpBackend_, _$routeParams_, _$location_, _Config_, Auth, _Tool_) ->
    $httpBackend = _$httpBackend_
    $routeParams = _$routeParams_
    $location = _$location_
    Config = _Config_
    Tool = _Tool_

    spyOn(Auth, 'getMerchant').andCallFake -> id: 'the-merchant-id'
    spyOn(Auth, 'getVenue').andCallFake -> id: 'the-venue-id'

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  describe "returning from Foursquare's OAuth flow", ->

    beforeEach ->
      spyOn $location, 'path'
      $routeParams.provider = 'foursquare'
      $routeParams.token = 'the-oauth-token'

    describe 'when no Foursquare tool exists', ->

      beforeEach inject ($controller) ->
        $httpBackend.expectPOST("#{Config.baseURL()}/api/merchants/the-merchant-id/venues/the-venue-id/tools",
          appId: 'com.mycircleinc.smarttools.social.foursquare'
          availableTo: [0..3]
          displayIndex: 5
          properties:
            token: 'the-oauth-token'
        ).respond 201

        $controller 'OAuthCtrl',
          tools: []

        $httpBackend.flush()

#      it 'should redirect the user to the social page after saving', ->
#        $httpBackend.flush()
#        expect($location.path).toHaveBeenCalledWith '/social'

    describe 'when a Foursquare tool exists already', ->

      beforeEach inject ($controller) ->
        foursquareTool = new Tool
          id: 'abc123'
          appId: 'com.mycircleinc.smarttools.social.foursquare'
          availableTo: [0..3]
          displayIndex: 5

        $httpBackend.expectPUT("#{Config.baseURL()}/api/merchants/the-merchant-id/venues/the-venue-id/tools/#{foursquareTool.id}",
          id: foursquareTool.id
          availableTo: [0..3]
          displayIndex: 5
          properties:
            token: 'the-oauth-token'
        ).respond 201

        $controller 'OAuthCtrl',
          tools: [foursquareTool]

#      it 'should redirect the user to the social page after updating', ->
#        $httpBackend.flush()
#        expect($location.path).toHaveBeenCalledWith '/social'
