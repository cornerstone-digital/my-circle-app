'use strict'

###
Directives supporting date/time input types. Values are converted between
appropriately formatted strings and moment.js objects.
###
angular.module('smartRegisterApp')

  .constant('datetimeLocalFormat', 'YYYY-MM-DDTHH:mm')
  .constant('dateFormat', 'YYYY-MM-DD')

  .directive('datetimeLocal', ['datetimeLocalFormat', (format) ->
    require: '?ngModel'
    restrict: 'A'
    link: (scope, element, attrs, controller) ->
      controller.$formatters.push (value) ->
        moment(value).local().format(format)
      controller.$parsers.push (value) ->
        moment(value, format).local()
  ])

  .directive('date', ['dateFormat', (format) ->
    require: '?ngModel'
    restrict: 'A'
    link: (scope, element, attrs, controller) ->
      controller.$formatters.push (value) ->
        moment(value).local().format(format)
      controller.$parsers.push (value) ->
        moment(value, format).local()
  ])
