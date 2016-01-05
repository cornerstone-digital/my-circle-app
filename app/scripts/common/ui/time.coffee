'use strict'

angular.module('smartRegisterApp')
.directive 'time', [ ->
  replace: false
  restrict: 'E'
  scope:
    moment: '='
  link: ($scope, $element, $attrs) ->
    format = $attrs.format ? 'ddd Do MMM YYYY'

    update = (value) ->
      if value?
        m = moment(value)
        $element.attr 'datetime', m.toISOString()
        $element.text m.format(format)

    $scope.$watch 'moment', update

]
