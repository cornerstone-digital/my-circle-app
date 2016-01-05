angular.module('smartRegisterApp')
.directive "currencyFormat", [
  "$filter"
  ($filter) ->
    return (
      require: "?ngModel"
      link: (scope, elem, attrs, ctrl) ->
        return  unless ctrl
        ctrl.$formatters.unshift (a) ->
          $filter(attrs.format) ctrl.$modelValue

        ctrl.$parsers.unshift (viewValue) ->
          elem.priceFormat
            prefix: ""
            centsSeparator: ","
            thousandsSeparator: "."

          elem[0].value

        return
    )
]