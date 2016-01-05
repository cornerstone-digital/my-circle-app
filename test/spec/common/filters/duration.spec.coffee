'use strict'

describe 'Filter: duration', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp'

  duration = null

  beforeEach inject ($filter) ->
    duration = $filter 'duration'

  it 'should format the duration by the specified unit', ->
    expect(duration 150 * 60 * 1000, 'hours').toEqual '2.5'

  it 'should accept an optional decimal places argument', ->
    expect(duration 150 * 60 * 1000, 'hours', 2).toEqual '2.50'
