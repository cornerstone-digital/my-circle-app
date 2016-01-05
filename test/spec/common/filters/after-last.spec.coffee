'use strict'

describe 'String filters', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp'

  describe 'after last filter', ->

    filter = null

    beforeEach inject ($filter) ->
      filter = $filter('afterLast')

    it 'should return a string unmodified if the delimiter is not present', ->
      expect(filter('string', ' ')).toBe 'string'

    it 'should return the last portion of the string if the delimiter is present', ->
      expect(filter('this is a string', ' ')).toBe 'string'
