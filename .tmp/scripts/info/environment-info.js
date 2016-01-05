(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('environmentInfo', [
    '$rootScope', 'Config', 'Auth', 'versionCheckService', 'MessagingService', function($rootScope, Config, Auth, versionCheckService, MessagingService) {
      return {
        replace: true,
        restrict: 'E',
        scope: true,
        template: '<div class="navbar navbar-inverse navbar-fixed-bottom environment-info" data-ng-if="shouldDisplay()">\n  <div class="container-fluid" data-ng-show="serverInformation">\n    <div class="pull-left">\n      <p class="navbar-text">Dashboard: <span style="text-transform: uppercase">{{dashboardVersion()}}</span> ({{gitHash()}})</p>\n      <form class="navbar-form navbar-left" data-requires-permission="PERM_PLATFORM_ADMINISTRATOR">\n        <div class="form-group merchant-selector"></div>\n      </form>\n    </div>\n    <div class="navbar-right">\n      <p class="navbar-text">Server: {{serverInformation().version}} ({{serverInformation().commitId}})</p>\n      <p class="navbar-text">API: {{serverInformation().apiVersion}}</p>\n      <p class="navbar-text">Build date: {{serverInformation().buildDate}}</p>\n      <p class="navbar-text">Environment: {{serverInformation().environment}}</p>\n    </div>\n  </div>\n</div>',
        link: function($scope) {
          versionCheckService.startPolling();
          $scope.hasRole = function(roleName) {
            return Auth.hasRole(roleName);
          };
          $scope.shouldDisplay = function() {
            return Config.mode() === 'browser';
          };
          $scope.dashboardVersion = function() {
            return versionCheckService.currentVersion();
          };
          $scope.serverInformation = function() {
            return versionCheckService.serverInformation();
          };
          $scope.gitHash = function() {
            return versionCheckService.getHash();
          };
          return $scope.$on('posversion:changed', function(event, serverInformation) {
            var message;
            message = "There is a new version of the iOS App available. You currently have version " + $rootScope.posVersion + ". Version " + serverInformation.latestPosVersion + " is now available.";
            toastr.options = {
              "closeButton": true,
              "debug": false,
              "positionClass": "toast-top-full-width",
              "onclick": null,
              "showDuration": "1000",
              "hideDuration": "1000",
              "timeOut": "0",
              "extendedTimeOut": "1000",
              "showEasing": "swing",
              "hideEasing": "linear",
              "showMethod": "fadeIn",
              "hideMethod": "fadeOut"
            };
            toastr.clear();
            return toastr.info(message);
          });
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=environment-info.js.map
