(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('venueEditForm', [
    '$filter', 'VenueService', function($filter, VenueService) {
      return {
        templateUrl: 'views/partials/venues/venue-edit-form.html',
        replace: true,
        restrict: 'E',
        scope: true,
        controller: [
          '$scope', '$element', '$attrs', 'Venue', function($scope, $element, $attrs, Venue) {
            $scope.$on('venue:create', function(event) {
              $scope.venue = {
                address: {
                  country: {
                    numericCode: 826
                  },
                  isAddressFor: 'ALL'
                },
                contacts: [
                  {
                    type: 'PHONE'
                  }
                ]
              };
              return $scope.contact = $scope.venue.contacts[0];
            });
            $scope.$on('venue:edit', function(event, venue) {
              $scope.venue = angular.copy(venue);
              if (!$scope.venue.contacts) {
                $scope.venue.contacts = [];
              }
              $scope.contact = _.find($scope.venue.contacts, function(it) {
                return it.type === 'PHONE';
              });
              if ($scope.contact == null) {
                $scope.contact = {
                  type: 'PHONE'
                };
                return $scope.venue.contacts.push($scope.contact);
              }
            });
            return $scope.save = function() {
              if ($scope.venueForm.$valid) {
                $scope.locked = true;
                return VenueService.save($scope.venue).then(function(response) {
                  $scope.$emit('venue:saved', response);
                  return $scope.locked = false;
                }, function(response) {
                  console.error('update failed');
                  return $scope.locked = false;
                });
              }
            };
          }
        ]
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=venue-edit-form.js.map
