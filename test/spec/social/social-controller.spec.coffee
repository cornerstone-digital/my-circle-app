'use strict'

describe 'Controller: Social', ->

  tools = null
  venues = null
  $scope = null
  Tool = null
  Venue = null

  beforeEach module 'mockEnvironment', 'smartRegisterApp'

  beforeEach inject ($rootScope, _Tool_, _Venue_) ->
    Tool = _Tool_
    Venue = _Venue_

    $scope = $rootScope.$new()
    $rootScope.credentials = [
      venue: {}
    ]

    tools = [
      new Tool
        id: "OpccZg0"
        appId: "com.mycircleinc.smarttools.register"
        availableTo: [0..3]
        displayIndex: 0
    ,
      new Tool
        id: "MUgLV5z"
        appId: "com.mycircleinc.smarttools.orderHistory"
        availableTo: [0..3]
        displayIndex: 1
    ,
      new Tool
        id: "PDLKqiR"
        appId: "com.mycircleinc.smarttools.smartReports"
        availableTo: [0..3]
        displayIndex: 2
    ]

    venues = [
      new Venue
        name: "Test Name"
    ]

  for provider in ['foursquare', 'facebook']
    ((provider) ->
      describe 'displaying the page', ->

        describe "when no #{provider} tool settings exist", ->

          beforeEach inject ($controller) ->
            $controller 'SocialCtrl',
              $scope: $scope
              SettingsService: null
              tools: tools
              venues: venues

          it 'does not do anything', ->
            expect($scope.toolFor(provider)).toBeUndefined()

        describe "when a #{provider} tool exists", ->

          beforeEach inject ($controller) ->
            tools.push
              id: 'abc123'
              appId: "com.mycircleinc.smarttools.social.#{provider}"
              availableTo: [0..3]
              displayIndex: 5

            $controller 'SocialCtrl',
              $scope: $scope
              SettingsService: null
              tools: tools
              venues: venues

          it 'returns it from the scope function', ->
            expect($scope.toolFor(provider)).toBe tools[3]

      describe "authenticating with #{provider}", ->

        beforeEach inject ($controller) ->
          $controller 'SocialCtrl',
            $scope: $scope
            SettingsService: null
            tools: tools
            venues: venues

          spyOn(OAuth, 'redirect')

          $scope.connect(provider)

        it "redirects the user to OAuth page", ->
          expect(OAuth.redirect).toHaveBeenCalledWith provider, '/'

      describe "disconnecting from #{provider}", ->

        beforeEach inject ($controller) ->
          tools.push new Tool
            id: 'abc123'
            appId: "com.mycircleinc.smarttools.social.#{provider}"
            availableTo: [0..3]
            displayIndex: 5
            properties:
              token: 'the-oauth-token'
              foo: 'bar'

          $controller 'SocialCtrl',
            $scope: $scope
            SettingsService: null
            tools: tools
            venues: venues

          spyOn(tools[3], '$update')

          $scope.disconnect(provider)

        it 'removes the tool properties and updates', ->
          expect(tools[3].properties.token).toBeUndefined()
          expect(tools[3].properties.foo).toBeUndefined()
          expect(tools[3].$update).toHaveBeenCalled()

    )(provider)
