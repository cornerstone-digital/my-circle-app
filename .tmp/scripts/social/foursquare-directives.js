(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('foursquareUser', [
    '$http', function($http) {
      return {
        replace: true,
        restrict: 'E',
        scope: {
          tool: '='
        },
        template: '<figure data-ng-if="user" class="media"><img data-ng-src="{{user.photo.prefix}}64x64{{user.photo.suffix}}" class="img-rounded media-object pull-left"><figcaption class="media-body">Connected as&hellip;<br><span class="name">{{user.firstName}} {{user.lastName}}</span></figcaption></figure>',
        link: function($scope, $element, $attrs) {
          return $scope.$watch('tool.properties.token', function(token) {
            if (token != null) {
              return $http.get("https://api.foursquare.com/v2/users/self?oauth_token=" + token + "&v=" + (moment().format('YYYYMMDD'))).success(function(response) {
                return $scope.user = response.response.user;
              }).error(function(response, status) {
                return console.error('could not get user details from Foursquare', status, response);
              });
            } else {
              return delete $scope.user;
            }
          });
        }
      };
    }
  ]).directive('foursquareVenue', [
    '$http', function($http) {
      return {
        replace: true,
        restrict: 'E',
        scope: {
          tool: '='
        },
        template: '<div class="alert" data-ng-class="{\'alert-success\': venue, \'alert-danger\': error}">\n  <div data-ng-if="venue"><strong>{{venue.name}}</strong><br>{{venue.location.address}}, {{venue.location.city}} {{venue.location.postalCode}}</div>\n  <div data-ng-if="error"><strong>Error</strong><br>{{error}}</div>\n</div>',
        link: function($scope, $element, $attrs) {
          return $scope.$watch('tool.properties.venueId', function(venueId) {
            if (venueId != null) {
              return $http.get("https://api.foursquare.com/v2/venues/" + venueId + "?oauth_token=" + $scope.tool.properties.token + "&v=" + (moment().format('YYYYMMDD'))).success(function(response) {
                $scope.venue = response.response.venue;
                return delete $scope.error;
              }).error(function(response, status) {
                delete $scope.venue;
                return $scope.error = response.meta.errorDetail;
              });
            } else {
              delete $scope.venue;
              return delete $scope.error;
            }
          });
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=foursquare-directives.js.map
