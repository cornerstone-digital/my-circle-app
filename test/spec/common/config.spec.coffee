'use strict'

describe 'Service: Config', ->

  beforeEach module 'smartRegisterApp'

  Config = null
  environments = null
  $rootScope = null
  $location = null

  beforeEach inject (_Config_, _environments_, _$rootScope_, _$location_) ->
    Config = _Config_
    environments = _environments_
    $rootScope = _$rootScope_
    $location = _$location_

  describe 'baseURL', ->

    describe 'when there is an environment in the root scope', ->

      describe 'but it is not a valid environment name', ->

        beforeEach ->
          spyOn $location, 'path'

          $rootScope.env = 'foo'
          Config.baseURL()

        it 'should not set a root scope value', ->
          expect($rootScope.env).toBeUndefined()

        it 'should redirect the user to an error page', ->
          expect($location.path).toHaveBeenCalledWith '/invalid-env'

      describe 'and it is a valid environment name', ->

        beforeEach ->
          $rootScope.env = 'demo'

        it 'should use the root scope environment', ->
          expect(Config.baseURL()).toBe environments.demo.baseURL

    describe 'when an environment exists as a URL parameter', ->

      describe 'and it is a valid environment name', ->

        beforeEach ->
          $location.search 'env', 'demo'

        it 'should get stored in root scope', ->
          Config.baseURL()
          expect($rootScope.env).toBe 'demo'

        it 'should use the environment from the URL parameter', ->
          expect(Config.baseURL()).toBe environments.demo.baseURL

      describe 'and it is an invalid environment name', ->

        beforeEach ->
          spyOn $location, 'path'

          $location.search 'env', 'foo'
          Config.baseURL()

        it 'should not set a root scope value', ->
          expect($rootScope.env).toBeUndefined()

        it 'should redirect the user to an error page', ->
          expect($location.path).toHaveBeenCalledWith '/invalid-env'

    describe 'when a baseURL exists as a URL parameter', ->

      describe 'and it corresponds to one of the environments', ->

        beforeEach ->
          $location.search 'baseURL', environments.demo.baseURL

        it 'should get stored in root scope', ->
          Config.baseURL()
          expect($rootScope.env).toBe 'demo'

        it 'should use the environment from the URL parameter', ->
          expect(Config.baseURL()).toBe environments.demo.baseURL

      describe 'and it is an invalid environment name', ->

        beforeEach ->
          spyOn $location, 'path'

          $location.search 'baseURL', 'http://icanhascheezburger.com'
          Config.baseURL()

        it 'should not set a root scope value', ->
          expect($rootScope.env).toBeUndefined()

        it 'should redirect the user to an error page', ->
          expect($location.path).toHaveBeenCalledWith '/invalid-env'

    describe 'when no environment is on the root scope or the query string', ->

      describe 'when the host is localhost', ->

        beforeEach ->
          spyOn($location, 'host').andCallFake -> 'localhost'

        it 'defaults to the test environment', ->
          expect(Config.baseURL()).toBe environments.test.baseURL

      describe 'when the host is the live host', ->

        beforeEach ->
          spyOn($location, 'host').andCallFake -> 'merchant.mycircleinc.com'

        it 'defaults to the test environment', ->
          expect(Config.baseURL()).toBe environments.live.baseURL

      describe 'when the host has an environment name in it', ->

        beforeEach ->
          spyOn($location, 'host').andCallFake -> 'merchant-demo.mycircleinc.com'

        it 'uses the environment from the host', ->
          expect(Config.baseURL()).toBe environments.demo.baseURL

      describe 'when the host does not have an environment name in it', ->

        beforeEach ->
          spyOn $location, 'path'
          spyOn($location, 'host').andCallFake -> 'whatever.mycircleinc.com'

          Config.baseURL()

        it 'should not set a root scope value', ->
          expect($rootScope.env).toBeUndefined()

        it 'should redirect the user to an error page', ->
          expect($location.path).toHaveBeenCalledWith '/invalid-env'
