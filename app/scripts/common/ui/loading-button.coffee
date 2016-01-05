'use strict'

###
A button that goes into a loading state when clicked or the containing form
(if any) is submitted & comes out of it automatically when all pending $http
requests are completed.

The directive is aware of any ng-disabled directive that exists on the same
button.
###
angular.module('smartRegisterApp')
  .directive('loadingButton', ['$http', ($http) ->
    require: ['^?form', '?ngDisabled']
    restrict: 'A'
    scope: true
    link: ($scope, $element, $attrs, controllers) ->
      formController = controllers[0]
      originalText = $element.html()
      loadingText = $attrs.loadingButton
      loadingText = 'Loading\u2026' unless loadingText
      $form = $element.closest('form')

      activateLoadingState = ->
        if not formController? or formController.$valid
          $element.prop('disabled', true).html loadingText

      deactivateLoadingState = ->
        $element.html originalText
        $element.prop 'disabled', if $attrs.ngDisabled then $scope.$eval($attrs.ngDisabled) else false

      $form.on 'submit', activateLoadingState
      $element.on 'click', activateLoadingState unless $form.length > 0

      $scope.activeRequests = ->
        $http.pendingRequests.length

      $scope.$watch 'activeRequests()', (value) ->
        deactivateLoadingState() if value is 0
  ])
