(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('venueSelector', [
    function() {
      return {
        restrict: 'C',
        scope: true,
        template: '<select class="form-control input-sm"\n        data-ng-if="canSwitchVenue()"\n        data-ng-show="venues.length"\n        data-ng-model="venue"\n        data-ng-options="venue.name for venue in venues track by venue.id"\n        data-ng-change="switchVenue(venue)"\n        required>\n</select>',
        controller: [
          '$rootScope', '$scope', '$route', 'Auth', 'Venue', function($rootScope, $scope, $route, Auth, Venue) {
            if (angular.isDefined($rootScope.credentials.merchant)) {
              $scope.venues = $rootScope.credentials.merchant.venues;
            }
            $scope.switchVenue = function(venue) {
              return Auth.switchVenue(venue, function() {
                $route.reload();
                $scope.$apply;
                return $scope.selectedVenue = venue;
              });
            };
            return $scope.canSwitchVenue = function() {
              return Auth.hasRole('PERM_MERCHANT_ADMINISTRATOR');
            };
          }
        ]
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=venue-selector.js.map
