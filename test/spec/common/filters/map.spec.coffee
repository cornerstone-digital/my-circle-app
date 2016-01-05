'use strict'

describe 'Filter: map', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp'

  map = {}
  beforeEach inject ($filter) ->
    map = $filter 'map'

  it 'should return the "name" property from each array element', ->
    array = [
      name: 'angularjs'
    ,
      name: 'grunt'
    ,
      name: 'karma'
    ]
    expect(map array, 'name').toEqual ['angularjs', 'grunt', 'karma']
