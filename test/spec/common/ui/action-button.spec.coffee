'use strict'

describe 'Directive: actionButton', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp'

  $rootScope = null
  $scope = null
  $button = null
  $timeout = null

  beforeEach inject (_$rootScope_, _$timeout_) ->
    $rootScope = _$rootScope_
    $timeout = _$timeout_

    $scope = $rootScope.$new()

  describe 'with specified loading text', ->

    beforeEach inject ($compile) ->
      $button = angular.element '<button action-button loading-text="Drinking&hellip;" action="drink"><i class="glyphicon glyphicon-glass"></i> Drink!</button>'
      $button = $compile($button) $scope

    describe 'initially', ->
      it 'the button should display the initial button text', ->
        expect($button.html()).toBe '<i class="glyphicon glyphicon-glass"></i> Drink!'

      it 'the button should be enabled', ->
        expect($button.prop('disabled')).toBe false

    describe 'when an action starts', ->
      beforeEach ->
        $rootScope.$broadcast 'drink:starting'

      it 'the button should display the loading text', ->
        expect($button.html()).toBe 'Drinking…'

      it 'the button should be disabled', ->
        expect($button.prop('disabled')).toBe true

      describe 'when an action completes', ->
        beforeEach ->
          $rootScope.$broadcast 'drink:complete'

        it 'the button should display the initial text', ->
          expect($button.html()).toBe '<i class="glyphicon glyphicon-glass"></i> Drink!'

        it 'the button should be enabled', ->
          expect($button.prop('disabled')).toBe false

  describe 'with default loading text', ->

    beforeEach inject ($compile) ->
      $button = angular.element '<button action-button action="drink"><i class="glyphicon glyphicon-glass"></i> Drink!</button>'
      $button = $compile($button) $scope

    describe 'when an action starts', ->
      beforeEach ->
        $rootScope.$broadcast 'drink:starting'

      it 'the button should display the default loading text', ->
        expect($button.html()).toBe 'Loading…'
