'use strict'

describe 'Resource: Shift', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'views/faq.html', 'views/login.html'

  $httpBackend = null
  Shift = null

  beforeEach inject (_$httpBackend_, _Shift_) ->
    $httpBackend = _$httpBackend_
    Shift = _Shift_

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  describe 'getting the shift date', ->

    shift = null

    beforeEach ->
      shift = new Shift
        started: '2013-11-29T09:00:00.000Z'

    it 'treats the started time as the date for the shift', ->
      expect(shift.getDate()).toBe '2013-11-29'
