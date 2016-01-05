angular.module('smartRegisterApp')
.directive "ngTab", ->
  (scope, element, attrs) ->
    element.bind "keydown keypress", (event) ->

      if event.which == 9
        scope.$apply ->
          scope.$eval attrs.ngTab
          return

        event.preventDefault()
      return

    return
