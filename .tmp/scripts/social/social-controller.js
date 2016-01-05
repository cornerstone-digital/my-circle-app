(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('SocialCtrl', [
    '$route', '$rootScope', '$scope', 'SettingsService', 'MessagingService', 'tools', 'venues', function($route, $rootScope, $scope, SettingsService, MessagingService, tools, venues) {
      $scope.tools = tools;
      $scope.venues = venues;
      $scope.venue = $rootScope.credentials.venue;
      $scope.connect = function(provider) {
        return OAuth.redirect(provider, '/');
      };
      $scope.disconnect = function(provider) {
        var key, tool;
        tool = $scope.toolFor(provider);
        for (key in tool.properties) {
          delete tool.properties[key];
        }
        return tool.$update();
      };
      $scope.isConnected = function(provider) {
        var _ref, _ref1;
        return ((_ref = $scope.toolFor(provider)) != null ? (_ref1 = _ref.properties) != null ? _ref1.token : void 0 : void 0) != null;
      };
      $scope.toolFor = function(provider) {
        return _.find($scope.tools, function(it) {
          return it.appId === ("com.mycircleinc.smarttools.social." + provider);
        });
      };
      $scope.save = function(tool) {
        var message;
        tool.$update();
        MessagingService.resetMessages();
        message = MessagingService.createMessage("success", "Your " + tool.name + " settings have been saved", 'Twitter');
        MessagingService.addMessage(message);
        return MessagingService.hasMessages('Social');
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

//# sourceMappingURL=social-controller.js.map
