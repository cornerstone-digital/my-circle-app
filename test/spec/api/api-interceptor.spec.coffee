'use strict'

describe 'Service: apiInterceptor', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp'

  $rootScope = null
  Config = null
  apiInterceptor = null

  beforeEach inject (_$rootScope_, _Config_, _apiInterceptor_) ->
    $rootScope = _$rootScope_
    Config = _Config_
    apiInterceptor = _apiInterceptor_

  describe 'intercepting HTTP requests', ->

    afterEach ->
      localStorage.clear()

    describe 'with an API URL', ->

       it 'converts the URL to the correct API call', ->
        config = apiInterceptor.request
          url: 'api://api/foo/bar/baz'

        $rootScope.currentVersion = '2.1.0'

        expect(config.url).toBe "#{Config.baseURL()}/api/foo/bar/baz"

    describe 'with a regular HTTP URL', ->

      it 'does not change the URL', ->
        config = apiInterceptor.request
          url: 'http://energizedwork.com/api/foo/bar/baz'

        expect(config.url).toBe "http://energizedwork.com/api/foo/bar/baz"

    describe 'when a user has not logged in', ->

      it 'does not append an Authorization header', ->
        config = apiInterceptor.request
          url: "api://api/foo/bar/baz"
          headers: {}

        expect(Object.keys(config.headers).length).toBe 1

    describe 'when a user has logged in', ->

      beforeEach ->
        credentials =
          token: 'e9be6699-be1d-4528-bae7-7c03dd464cfa'
          email: 'user@mycircleinc.com'
        localStorage.setItem 'credentials', JSON.stringify(credentials)

      it 'adds an Authorization header', ->
        config = apiInterceptor.request
          url: "api://api/foo/bar/baz"
          headers: {}

        expect(config.headers['Authorization']).toMatch /Token .+=/

      it 'encrypts the Authorization header correctly', ->
        config = apiInterceptor.request
          url: "api://api/foo/bar/baz"
          headers: {}

        expect(config.headers['Authorization']).toBe 'Token Bnp/UdOqxRSV+eiXTxveEBCepRxt2JLu4xsPe0zveko='

      it 'does not add an Authorization header if one exists already', ->
        config = apiInterceptor.request
          url: "api://api/foo/bar/baz"
          headers:
            Authorization: 'Basic user/pass'

        expect(config.headers['Authorization']).toBe "Basic user/pass"

    describe 'when a user is impersonating a merchant', ->

      beforeEach ->
        credentials =
          token: 'the-auth-token'
          impersonated:
            merchant:
              id: 'the-merchant-id'
        localStorage.setItem 'credentials', JSON.stringify(credentials)

      it 'does not add any headers to a request that is not aimed at the myCircle API', ->
        config = apiInterceptor.request
          url: 'http://energizedwork.com/foo/bar/baz'
          headers: {}

        expect(Object.keys(config.headers).length).toBe 1

  describe 'intercepting HTTP error responses', ->

    $location = null
    $q = null

    beforeEach inject (_$location_, _$q_) ->
      $location = _$location_
      $q = _$q_

      spyOn $q, 'reject'
      $location.path '/foo'

    describe 'a 401 response from the API', ->

      beforeEach ->
        $rootScope.credentials =
          token: 'an-invalid-token'

        apiInterceptor.responseError
          config:
            url: "#{Config.baseURL()}/api/foo/bar/baz"
            isApiCall: true
          status: 401

      it 'rejects the promise', ->
        expect($q.reject).toHaveBeenCalled()

      it 'redirects the user to the login page', ->
        expect($location.path()).toBe '/login'

      it 'stores the original path', ->
        expect($rootScope.retryPath).toBe '/foo'

      it 'deletes their credentials', ->
        expect($rootScope.credentials).toBeNull()

    describe 'a 403 response from the API', ->

      beforeEach ->
        apiInterceptor.responseError
          config:
            url: "#{Config.baseURL()}/api/foo/bar/baz"
            isApiCall: true
          status: 403

      it 'rejects the promise', ->
        expect($q.reject).toHaveBeenCalled()

    describe 'another error from the API', ->

      beforeEach ->
        apiInterceptor.responseError
          config:
            url: "#{Config.baseURL()}/api/foo/bar/baz"
            isApiCall: true
          status: 422

      it 'rejects the promise', ->
        expect($q.reject).toHaveBeenCalled()

      it 'does not redirect the user', ->
        expect($location.path()).toBe '/foo'

    for status in [401, 403]
      ((status) ->
        describe "a #{status} response from somewhere else", ->

          beforeEach ->
            apiInterceptor.responseError
              config:
                url: "https://energizedwork.com/foo/bar/baz"
              status: status

          it 'rejects the promise', ->
            expect($q.reject).toHaveBeenCalled()

          it 'does not redirect the user', ->
            expect($location.path()).toBe '/foo'

          it 'does not store the original path', ->
            expect($rootScope.retryPath).toBeUndefined()
      )(status)

    describe 'a 503 when the API is down', ->

      apiConnectionErrorCallback = null

      beforeEach ->
        apiConnectionErrorCallback = jasmine.createSpy()
        $rootScope.$on 'apiConnectionError', apiConnectionErrorCallback

        apiInterceptor.responseError
          config:
            url: "#{Config.baseURL()}/api/foo/bar/baz"
            isApiCall: true
          status: 503

      it 'rejects the promise', ->
        expect($q.reject).toHaveBeenCalled()

      it 'does not redirect the user', ->
        expect($location.path()).toBe '/foo'

      it 'broadcasts an event', ->
        expect(apiConnectionErrorCallback).toHaveBeenCalled()
