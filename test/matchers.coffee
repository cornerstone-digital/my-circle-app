beforeEach ->
  @addMatchers

    ###
    asserts that an angular.element exists
    ###
    toExist: ->
      @message = ->
        "Expected '#{@actual.selector}' #{if @isNot then 'not ' else ''}to exist"
      @actual.length > 0

    ###
    asserts that an array is equal to another regardless of order. i.e. they contain the exact same elements
    ###
    toBeEqualSet: (expected) ->
      @message = ->
        "Expected '#{@actual}' #{if @isNot then 'not ' else ''}to contain the same elements as #{expected}"
      angular.equals @actual.slice(0).sort(), expected.slice(0).sort()

    ###
    asserts that an angular.element is a particular tag. e.g. `expect(element).toBeA('div')`.
    ###
    toBeA: (expected) ->
      actualTag = @actual[0].tagName.toLowerCase()
      @message = ->
        "Expected '#{angular.mock.dump(@actual)}' #{if @isNot then 'not ' else ''}to be a <#{expected}>"
      actualTag is expected

    ###
    asserts that an angular.element has a particular class. e.g. `expect(element).toHaveClass('funky')`
    ###
    toHaveClass: (expected) ->
      @message = ->
        "Expected element '#{angular.mock.dump(@actual)}' #{if @isNot then 'not ' else ''}to have the class '#{expected}'"
      @actual.hasClass expected

    ###
    asserts that an angular.element is disabled.
    ###
    toBeDisabled: ->
      @message = ->
        "Expected element '#{angular.mock.dump(@actual)}' #{if @isNot then 'not ' else ''}to be disabled"
      @actual.prop('disabled') or @actual.attr('ng-disabled') is 'true' or @actual.attr('data-ng-disabled') is 'true'

    ###
    asserts that an angular.element is visible.
    ###
    toBeVisible: ->
      @message = ->
        "Expected element '#{angular.mock.dump(@actual)}' #{if @isNot then 'not ' else ''}to be visible"
      @actual.is ':visible'

    ###
    asserts that an angular.element is hidden using `ng-hide` or `ng-show`.
    ###
    toBeHidden: ->
      @message = ->
        "Expected element '#{angular.mock.dump(@actual)}' #{if @isNot then 'not ' else ''}to be hidden"
      @actual.hasClass('ng-hide') or @actual.closest('.ng-hide').length > 0

    ###
    asserts that an angular.element or array is empty.
    ###
    toBeEmpty: ->
      @message = ->
        "Expected '#{@actual}' #{if @isNot then 'not ' else ''}to be empty"
      @actual.length is 0

    ###
    asserts that two moments represent the same instant.
    ###
    toBeSameMoment: (expected) ->
      @message = ->
        "Expected #{@actual.toISOString()} #{if @isNot then 'not ' else ''} to be the same moment as #{expected.toISOString()}"
      @actual.isSame(expected)

    ###
    asserts that an angular.element matches a CSS selector.
    ###
    toMatchSelector: (selector) ->
      @message = ->
        "Expected #{@actual} #{if @isNot then 'not ' else ''} to match CSS selector #{selector}"
      @actual.is(selector)
