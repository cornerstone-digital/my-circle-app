(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('FoursquareCtrl', [
    '$scope', '$http', 'MessagingService', function($scope, $http, MessagingService) {
      $scope.tool = $scope.toolFor('foursquare');
      $scope.save = function() {
        var message;
        $scope.tool.$update();
        MessagingService.resetMessages();
        message = MessagingService.createMessage("success", "Your Foursquare settings have been saved", 'Foursquare');
        MessagingService.addMessage(message);
        return MessagingService.hasMessages('Social');
      };
      $scope.deleteVenue = function() {
        delete $scope.tool.properties.venueId;
        return $scope.tool.$update();
      };
      return $scope.isValidVenue = function() {
        var _ref;
        return ((_ref = $scope.tool.properties) != null ? _ref.venueId : void 0) != null;
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=foursquare-controller.js.map
