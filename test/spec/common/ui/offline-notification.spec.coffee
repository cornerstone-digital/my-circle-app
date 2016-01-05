'use strict'

describe 'Directive: offlineNotification', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'views/faq.html', 'views/login.html'

  $rootScope = null
  $scope = null
  $element = null
  $timeout = null
  callbacks = null

  beforeEach inject (_$rootScope_, $compile, _$timeout_) ->
    $rootScope = _$rootScope_
    $scope = $rootScope.$new()
    $timeout = _$timeout_

    $element = $('<offline-notification/>')
    $element = $compile($element) $scope

    callbacks =
      show: jasmine.createSpy 'show'
      hide: jasmine.createSpy 'hide'

    $element.on 'show.bs.modal', callbacks.show
    $element.on 'hide.bs.modal', callbacks.hide

  it 'should start hidden', ->
    expect($element).not.toBeVisible()

  describe 'when the API goes down', ->

    beforeEach ->
      $rootScope.$broadcast 'apiConnectionError'

    it 'should display the notification', ->
      expect(callbacks.show).toHaveBeenCalled()

    describe 'after a few seconds', ->

      $httpBackend = null
      Config = null

      beforeEach inject (_$httpBackend_, _Config_) ->
        $httpBackend = _$httpBackend_
        Config = _Config_

      afterEach ->
        $httpBackend.verifyNoOutstandingExpectation()
        $httpBackend.verifyNoOutstandingRequest()

      it 'should start polling the API', ->
        $httpBackend.expectGET("#{Config.baseURL()}/api/ping").respond 503
        $timeout.flush()
        $httpBackend.flush()

      describe 'when the API becomes available again', ->

        beforeEach inject ($browser) ->
          $httpBackend.expectGET("#{Config.baseURL()}/api/ping").respond 200
          $timeout.flush()
          $httpBackend.flush()

        it 'should hide the notification', ->
          expect(callbacks.hide).toHaveBeenCalled()

  describe 'when the API becomes available', ->

    beforeEach ->
      $rootScope.$broadcast 'apiConnectionSuccess'

    it 'should hide the notification', ->
      expect(callbacks.hide).toHaveBeenCalled()
