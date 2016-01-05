(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('FacebookCtrl', [
    '$scope', '$http', 'MessagingService', function($scope, $http, MessagingService) {
      $scope.tool = $scope.toolFor('facebook');
      $scope.save = function() {
        var message;
        $scope.tool.$update();
        MessagingService.resetMessages();
        message = MessagingService.createMessage("success", "Your Facebook settings have been saved", 'Facebook');
        MessagingService.addMessage(message);
        return MessagingService.hasMessages('Social');
      };
      $scope.$watch('page', function(page) {
        if (page != null) {
          $scope.tool.properties.pageId = page.id;
          $scope.tool.properties.pageName = page.name;
          return $scope.tool.properties.pageToken = page.access_token;
        }
      });
      return $scope.$watch('tool.properties.token', function(token) {
        if (token != null) {
          if (angular.isDefined($scope.tool.properties.token)) {
            return $http.get("https://graph.facebook.com/me?fields=accounts.fields(name,access_token)&format=json&access_token=" + token).success(function(user) {
              $scope.pages = user.accounts.data;
              return $scope.page = _.find($scope.pages, function(it) {
                return it.id === $scope.tool.properties.pageId;
              });
            }).error(function(response, status) {
              return console.error('could not get pages for user from Facebook', status, response);
            });
          }
        }
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=facebook-controller.js.map
