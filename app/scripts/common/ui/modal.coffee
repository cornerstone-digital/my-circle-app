'use strict'

###
Manages a Bootstrap modal by watching a scope value.

The modal is shown when the value becomes non-null/undefined hidden when it
becomes null/undefined.

In addition if the modal is closed directly (i.e. with the escape key or by
clicking on the background overlay) then a scope function is called. By default
the directive tries to call a function called `cancel` but that can be
overridden by specifying an `on-cancel` attribute.
###
angular.module('smartRegisterApp')
  .directive('modal', ['$timeout', ($timeout) ->
    restrict: 'C'
    link: ($scope, $element, $attrs) ->
      if $attrs.trigger?
        $scope.$watch $attrs.trigger, (newValue, oldValue) ->
          $element.modal 'show' if newValue? and not oldValue?
          $element.modal 'hide' if oldValue? and not newValue?

        $element.on 'hide.bs.modal', ->
          onHide = $scope[$attrs.onCancel ? 'cancel']
          onHide()
          # if this function is called directly - i.e. the user hits esc or
          # clicks the background we need to notify the scope of changes but
          # using $scope.$apply results in an infinite loop.
          $timeout ->
            $scope.$digest()
  ])
