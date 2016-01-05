'use strict'

describe 'Filter: join', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp'

  join = {}
  beforeEach inject ($filter) ->
    join = $filter 'join'

  describe 'joining arrays', ->
    array = ['angularjs', 'grunt', 'karma']

    it 'should return the input array as a comma-separated string', ->
      expect(join array).toBe 'angularjs, grunt, karma'

    it 'can specify a different delimiter', ->
      expect(join array, '|').toBe 'angularjs|grunt|karma'

  describe 'joining comma-separated strings', ->
    string = 'angularjs,grunt,karma'

    it 'should split and re-join the string', ->
      expect(join string).toBe 'angularjs, grunt, karma'
