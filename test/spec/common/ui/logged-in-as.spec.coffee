'use strict'

describe 'Directive: loggedInAs', ->
  beforeEach module 'mockEnvironment', 'smartRegisterApp'

  $scope = null
  $element = null

  beforeEach inject ($rootScope, $compile) ->
    $scope = $rootScope.$new()
    $element = angular.element '<span class="logged-in-as"></span>'
    $element = $compile($element) $scope

  describe 'when a user is logged in', ->

    beforeEach inject (Auth) ->
      spyOn(Auth, 'getCredentials').andCallFake ->
        username: 'F Zlem'
      $scope.$digest()

    it 'should be visible', ->
      expect($element).not.toBeHidden()

    it 'should display the logged in user', ->
      expect($element.text()).toBe 'F Zlem'

  describe 'when no user is logged in', ->

    beforeEach inject (Auth) ->
      spyOn(Auth, 'getCredentials').andCallFake -> null
      $scope.$digest()

    it 'should be hidden', ->
      expect($element).toBeHidden()
