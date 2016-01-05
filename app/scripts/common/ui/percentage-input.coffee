'use strict'

###
An input that accepts percentage values but is backed by a float. e.g. 10 == 0.1
###
angular.module('smartRegisterApp')
.directive 'percentageInput', [->
  require: '?ngModel'
  link: (scope, element, attrs, controller) ->
    controller.$formatters.push (value) ->
      if value then value * 100 else null
    controller.$parsers.push (value) ->
      if value then parseInt(value) / 100 else null
]
