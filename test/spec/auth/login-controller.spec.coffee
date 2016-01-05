'use strict'

describe 'Controller: Login', ->

  # load the controller's module
  beforeEach module 'mockEnvironment', 'smartRegisterApp'

  rootScope = null
  scope = null
  Auth = null
  location = null

  # Initialize the controller and a mock scope
  beforeEach inject ($rootScope, $location, _Auth_) ->
    scope = $rootScope.$new()
    rootScope = $rootScope
    location = $location
    Auth = _Auth_
    rootScope.unsecured = ['forgottenPassword', 'resetToken']

    spyOn location, 'path'

  afterEach ->
    localStorage.clear()

  describe 'when already logged in', ->

    beforeEach inject ($controller) ->
      spyOn(Auth, 'isLoggedIn').andCallFake -> true

      $controller 'LoginCtrl',
        $scope: scope
        $rootScope: rootScope
        Auth: Auth

    it 'immediately redirects the user', ->
      console.log location

#      expect(location.path).toHaveBeenCalledWith '/'

  describe 'when not previously logged in', ->

    beforeEach inject ($controller) ->
      $controller 'LoginCtrl',
        $scope: scope
        $rootScope: rootScope
        Auth: Auth

    describe 'a merchant successfully logs in', ->
      beforeEach ->
        # given the auth service will accept the credentials
        spyOn(Auth, 'login').andCallFake (params, success, error) ->
          success
            username: params.username
            token: 'the-login-token'
            venue:
              id: '1'

      describe 'logs in', ->
        beforeEach ->
          scope.login()

        it 'should route to home', ->
          expect(location.path).toHaveBeenCalledWith('/')

      describe 'logs in after being redirected', ->
        beforeEach ->
          rootScope.retryPath = '/foo'
          scope.login()

        it 'should route to the original path', ->
          expect(location.path).toHaveBeenCalledWith('/foo')

      describe 'logs in after going direct to the login page', ->
        beforeEach ->
          rootScope.retryPath = '/login'
          scope.login()

        it 'should route to home', ->
          expect(location.path).toHaveBeenCalledWith('/')

    describe 'failed login', ->
      beforeEach ->
        # given the auth service will not accept the credentials
        spyOn(Auth, 'login').andCallFake (params, successCallback, errorCallback) ->
          errorCallback 'Incorrect username or password'

        scope.login()

      it 'should display an error message', ->
        expect(scope.error).toBe 'Incorrect username or password'

      it 'shoud remain on the login page', ->
        expect(location.path).not.toHaveBeenCalled()
