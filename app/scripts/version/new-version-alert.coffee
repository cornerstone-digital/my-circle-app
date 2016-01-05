'use strict'

angular.module('versionPoll')
  .directive('newVersionAlert', ['$route', '$timeout', 'versionCheckService', ($route, $timeout, versionCheckService) ->
    replace: true
    restrict: 'E'
    scope: true
    template: '''<button class="btn btn-success new-version-alert"
                           data-ng-show="changeDetected"
                           data-ng-click="reload()"
                           type="button">!</button>'''
    link: ($scope, $element) ->
      $scope.changeDetected = false

      $scope.reload = ->
        window.location.reload()

      $scope.$on 'version:changed', ->
        $scope.changeDetected = true
        $element.tooltip
          placement: 'bottom'
          html: true
          title: '<h3>Updates available</h3><p>Click to reload.</p>'
          trigger: 'click'
          container: 'body'

        $timeout ->
          $element.tooltip 'show'
          $timeout ->
            $element.tooltip 'hide'
          , 30 * 1000

      versionCheckService.startPolling()
  ])
