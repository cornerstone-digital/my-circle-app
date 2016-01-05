'use strict'

angular.module('smartRegisterApp')
  .filter 'duration', ['$filter', ($filter) ->
    (milliseconds, unit, fractionSize = 1) ->
      $filter('number') moment.duration(milliseconds).as(unit), fractionSize
  ]
