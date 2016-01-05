'use strict'

angular.module('smartRegisterApp')
  .constant('apiPollFrequency', 10000)
  .directive 'offlineNotification', ['$rootScope', '$timeout', '$http', 'Config', 'apiPollFrequency', ($rootScope, $timeout, $http, Config, apiPollFrequency) ->
    replace: true
    restrict: 'E'
    template: '''
      <div class="offline-notification modal fade bs-modal-sm">
        <div class="modal-dialog modal-sm">
          <div class="modal-content">
            <div class="modal-header">
              <h4>Offline</h4>
            </div>
            <div class="modal-body">
              <p>Unable to contact the myCircle API. Please check your network connection.</p>
            </div>
          </div>
        </div>
      </div>
    '''
    link: ($scope, $element) ->
      $element.modal
        backdrop: 'static'
        keyboard: false
        show: false

      $scope.$on 'apiConnectionError', ->
        $element.modal 'show'

        $timeout ->
          $http.get("api://api/ping").success ->
            $scope.$broadcast 'apiConnectionSuccess'
        , apiPollFrequency

      $scope.$on 'apiConnectionSuccess', ->
        $element.modal 'hide'

      $rootScope.fail = ->
        $http.get "api://api/ping/503"
  ]
