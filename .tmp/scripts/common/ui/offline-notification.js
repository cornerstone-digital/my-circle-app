(function() {
  'use strict';
  angular.module('smartRegisterApp').constant('apiPollFrequency', 10000).directive('offlineNotification', [
    '$rootScope', '$timeout', '$http', 'Config', 'apiPollFrequency', function($rootScope, $timeout, $http, Config, apiPollFrequency) {
      return {
        replace: true,
        restrict: 'E',
        template: '<div class="offline-notification modal fade bs-modal-sm">\n  <div class="modal-dialog modal-sm">\n    <div class="modal-content">\n      <div class="modal-header">\n        <h4>Offline</h4>\n      </div>\n      <div class="modal-body">\n        <p>Unable to contact the myCircle API. Please check your network connection.</p>\n      </div>\n    </div>\n  </div>\n</div>',
        link: function($scope, $element) {
          $element.modal({
            backdrop: 'static',
            keyboard: false,
            show: false
          });
          $scope.$on('apiConnectionError', function() {
            $element.modal('show');
            return $timeout(function() {
              return $http.get("api://api/ping").success(function() {
                return $scope.$broadcast('apiConnectionSuccess');
              });
            }, apiPollFrequency);
          });
          $scope.$on('apiConnectionSuccess', function() {
            return $element.modal('hide');
          });
          return $rootScope.fail = function() {
            return $http.get("api://api/ping/503");
          };
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=offline-notification.js.map
