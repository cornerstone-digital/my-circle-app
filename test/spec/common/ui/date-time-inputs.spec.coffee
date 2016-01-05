'use strict'

describe 'Directive: datetimeLocal', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'views/faq.html', 'views/login.html'

  $scope = null
  $element = null

  beforeEach inject ($rootScope, $compile) ->
    $scope = $rootScope.$new()
    $element = angular.element '<input type="datetime-local" datetime-local ng-model="model">'
    $compile($element) $scope

  it 'should convert an ISO date/time string into the correct format for display', ->
    $scope.$apply ->
      $scope.model = '2013-11-29T14:33:00.000Z'

    expect($element.val()).toBe '2013-11-29T14:33'

  it 'should convert the input string into an ISO date/time string', ->
    $element.val('2013-11-29T14:33').trigger 'input'

    expect($scope.model).toBeSameMoment moment('2013-11-29T14:33:00.000Z')

  it 'should convert the scope value to a local date/time allowing for DST', ->
    $scope.$apply ->
      $scope.model = '2013-06-30T07:00:00.000Z'

    expect($element.val()).toBe '2013-06-30T08:00'

  it 'should interpret the input value as a local date/time allowing for DST', ->
    $element.val('2013-06-30T08:00').trigger 'input'

    expect($scope.model).toBeSameMoment moment('2013-06-30T07:00:00.000Z')
