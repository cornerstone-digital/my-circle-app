'use strict'

describe 'Directive: btnLogout', ->
  beforeEach module 'mockEnvironment', 'smartRegisterApp'

  $scope = null
  $element = null

  beforeEach inject ($compile, $rootScope) ->
    $scope = $rootScope.$new()

    $element = angular.element '<button class="btn-logout" ng-show="isLoggedIn()"></button>'
    $element = $compile($element) $scope

  describe 'button visibility', ->

    Auth = null

    beforeEach inject (_Auth_) ->
      Auth = _Auth_

    describe 'when a user is logged in', ->
      beforeEach ->
        spyOn(Auth, 'isLoggedIn').andCallFake -> true
        $scope.$digest()

      it 'should display the button', ->
        expect($element).not.toBeHidden()

    describe 'when no user is logged in', ->
      beforeEach ->
        spyOn(Auth, 'isLoggedIn').andCallFake -> false
        $scope.$digest()

      it 'should hide the button if no user is logged in', ->
        expect($element).toBeHidden()

  describe 'clicking the button', ->

    Auth = null
    $location = null

    beforeEach inject (_Auth_, _$location_) ->
      Auth = _Auth_
      spyOn Auth, 'logout'

      $location = _$location_
      spyOn $location, 'path'

      $element.click()

    it 'should log the user out', ->
      expect(Auth.logout).toHaveBeenCalled()

    it 'should redirect the user to the login page', ->
      expect($location.path).toHaveBeenCalledWith '/login'
