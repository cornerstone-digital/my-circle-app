(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('ToolsCtrl', [
    '$route', '$rootScope', '$scope', 'SettingsService', 'tools', 'venues', function($route, $rootScope, $scope, SettingsService, tools, venues) {
      $scope.venues = venues;
      $scope.venue = $rootScope.credentials.venue;
      $scope.tools = _.filter(tools, function(it) {
        return it.appId.indexOf('.social.') === -1;
      });
      _.each($scope.tools, function(tool) {
        if (tool.groups == null) {
          return tool.groups = [];
        }
      });
      $scope.save = function(tool) {
        console.log(tool);
        return tool.$update();
      };
      $scope.hasModuleEnabled = function(moduleName) {
        return SettingsService.hasModuleEnabled(moduleName);
      };
      $scope.hasMultipleVenues = function() {
        if ($scope.venues.length > 1) {
          return true;
        } else {
          return false;
        }
      };
      $scope.switchVenue = function(venue) {
        return $scope.$broadcast('venue:switch', venue);
      };
      return $scope.$on('venue:switch', function(event, venue) {
        $rootScope.credentials.venue = venue;
        return $route.reload();
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=tools-controller.js.map
