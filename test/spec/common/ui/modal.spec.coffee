'use strict'

describe 'Directive: modal', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp'

  $scope = null
  $element = null
  callbacks = null

  beforeEach inject ($rootScope) ->
    $scope = $rootScope.$new()

    $scope.cancel = jasmine.createSpy()

    callbacks =
      show: jasmine.createSpy 'show'
      hide: jasmine.createSpy 'hide'
      bind: ($element) ->
        $element.on 'show.bs.modal', callbacks.show
        $element.on 'hide.bs.modal', callbacks.hide

  describe 'an element with no onCancel attribute', ->

    beforeEach inject ($compile) ->
      $element = angular.element '<div class="modal" data-trigger="wotsit"></div>'
      $compile($element) $scope

    describe 'when the trigger value is undefined', ->
      beforeEach ->
        $scope.wotsit = `undefined`
        $scope.$digest()

        callbacks.bind $element

      it 'the modal should show when the trigger value changes to an object', ->
        $scope.wotsit = {}
        $scope.$digest()

        expect(callbacks.show).toHaveBeenCalled()
        expect(callbacks.hide).not.toHaveBeenCalled()

      it 'should do nothing when the trigger value changes to null', ->
        $scope.wotsit = null
        $scope.$digest()

        expect(callbacks.show).not.toHaveBeenCalled()
        expect(callbacks.hide).not.toHaveBeenCalled()

    describe 'when the trigger value is an object', ->
      beforeEach ->
        $scope.wotsit = {}
        $scope.$digest()

        callbacks.bind $element

      it 'the modal should hide when the tigger value changes to undefined', ->
        delete $scope.wotsit
        $scope.$digest()

        expect(callbacks.show).not.toHaveBeenCalled()
        expect(callbacks.hide).toHaveBeenCalled()

      it 'the modal should hide when the tigger value changes to null', ->
        $scope.wotsit = null
        $scope.$digest()

        expect(callbacks.show).not.toHaveBeenCalled()
        expect(callbacks.hide).toHaveBeenCalled()

      it 'should do nothing when the trigger value changes to another object', ->
        $scope.wotsit = "foo"
        $scope.$digest()

        expect(callbacks.show).not.toHaveBeenCalled()
        expect(callbacks.hide).not.toHaveBeenCalled()

    describe 'when the modal is closed', ->
      beforeEach ->
        $element.modal 'show'

      it 'should call the cancel function in the scope when the modal is hidden', ->
        $element.modal 'hide'

        expect($scope.cancel).toHaveBeenCalled()

  describe 'an element with an onCancel attribute', ->

    beforeEach inject ($compile) ->
      $scope.cthulhu = jasmine.createSpy()

      $element = angular.element '<div class="modal" data-trigger="wotsit" data-on-cancel="cthulhu"></div>'
      $compile($element) $scope

    describe 'when the modal is closed', ->
      beforeEach ->
        $element.modal 'show'

      it 'should call the specified function in the scope when the modal is hidden', ->
        $element.modal 'hide'

        expect($scope.cthulhu).toHaveBeenCalled()

      it 'should not call the cancel function in the scope when the modal is hidden', ->
        $element.modal 'hide'

        expect($scope.cancel).not.toHaveBeenCalled()
