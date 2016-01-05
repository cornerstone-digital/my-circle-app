(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('facebookUser', [
    '$http', function($http) {
      return {
        replace: true,
        restrict: 'E',
        scope: {
          tool: '='
        },
        template: '<figure data-ng-if="user" class="media"><img data-ng-src="{{picture()}}" class="img-rounded media-object pull-left"><figcaption class="media-body">Connected as&hellip;<br><span class="name">{{user.name}}</span></figcaption></figure>',
        link: function($scope, $element, $attrs) {
          $scope.picture = function() {
            if (angular.isDefined($scope.tool.properties.token)) {
              return "https://graph.facebook.com/me/picture?width=64&height=64&access_token=" + $scope.tool.properties.token;
            }
          };
          return $scope.$watch('tool.properties.token', function(token) {
            if (token != null) {
              if (angular.isDefined($scope.tool.properties.token)) {
                return $http.get("https://graph.facebook.com/me?format=json&access_token=" + $scope.tool.properties.token).success(function(user) {
                  return $scope.user = user;
                }).error(function(response, status) {
                  return console.error('could not get user details from Facebook', status, response);
                });
              }
            } else {
              return delete $scope.user;
            }
          });
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=facebook-directives.js.map
