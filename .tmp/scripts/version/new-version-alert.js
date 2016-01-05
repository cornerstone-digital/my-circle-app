(function() {
  'use strict';
  angular.module('versionPoll').directive('newVersionAlert', [
    '$route', '$timeout', 'versionCheckService', function($route, $timeout, versionCheckService) {
      return {
        replace: true,
        restrict: 'E',
        scope: true,
        template: '<button class="btn btn-success new-version-alert"\ndata-ng-show="changeDetected"\ndata-ng-click="reload()"\ntype="button">!</button>',
        link: function($scope, $element) {
          $scope.changeDetected = false;
          $scope.reload = function() {
            return window.location.reload();
          };
          $scope.$on('version:changed', function() {
            $scope.changeDetected = true;
            $element.tooltip({
              placement: 'bottom',
              html: true,
              title: '<h3>Updates available</h3><p>Click to reload.</p>',
              trigger: 'click',
              container: 'body'
            });
            return $timeout(function() {
              $element.tooltip('show');
              return $timeout(function() {
                return $element.tooltip('hide');
              }, 30 * 1000);
            });
          });
          return versionCheckService.startPolling();
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=new-version-alert.js.map
