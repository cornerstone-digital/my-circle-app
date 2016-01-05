'use strict'

describe 'Directive: deleteButton', ->
  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'testFixtures'

  element = {}
  parentScope = {}
  scope = {}
  resource =
    id: 'abc123'
  listener = {}

  beforeEach inject ($rootScope, $compile) ->
    listener = jasmine.createSpy()

    parentScope = $rootScope
    scope = $rootScope.$new()
    $rootScope.resourceInParentScope = resource
    $rootScope.$on event, listener for event in ['delete:start', 'delete:success', 'delete:fail']

    element = angular.element '<button delete-button resource="resourceInParentScope"></button>'
    element = $compile(element) scope

  describe 'responding to a click', ->
    listener = {}

    beforeEach ->
      listener = jasmine.createSpy()
      parentScope.$on 'delete:requested', listener

      element.triggerHandler 'click'

    it 'should request deletion of the resource', ->
      expect(listener).toHaveBeenCalled
      expect(listener.mostRecentCall.args[0].name).toBe 'delete:requested'
      expect(listener.mostRecentCall.args[1]).toBe resource

  describe 'responding to a different resource being deleted', ->
    it 'should do nothing', ->
      parentScope.$broadcast 'delete:pending',
        id: 'xyz456'

      expect(element.prop('disabled')).toBe false

  describe 'responding to the resource being deleted', ->
    describe 'when the delete is pending', ->
      beforeEach ->
        parentScope.$broadcast 'delete:pending', resource

      it 'should disable itself', ->
        expect(element.prop('disabled')).toBe true

      describe 'when the delete succeeds', ->
        beforeEach ->
          parentScope.$broadcast 'delete:succeeded', resource

        it 'should re-enable itself', ->
          expect(element.prop('disabled')).toBe false

      describe 'when the delete fails', ->
        beforeEach ->
          parentScope.$broadcast 'delete:failed', resource

        it 'should re-enable itself', ->
          expect(element.prop('disabled')).toBe false
