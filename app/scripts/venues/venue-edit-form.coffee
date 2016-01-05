'use strict'

angular.module('smartRegisterApp')
  .directive('venueEditForm', ['$filter','VenueService', ($filter, VenueService) ->
    templateUrl: 'views/partials/venues/venue-edit-form.html'
    replace: true
    restrict: 'E'
    scope: true
    controller: ['$scope', '$element', '$attrs', 'Venue', ($scope, $element, $attrs, Venue) ->

      $scope.$on 'venue:create', (event) ->
        $scope.venue = {
          address:
            country:
              numericCode: 826
            isAddressFor: 'ALL'
          contacts: [
            type: 'PHONE'
          ]
        }

        $scope.contact = $scope.venue.contacts[0]

      $scope.$on 'venue:edit', (event, venue) ->
        $scope.venue = angular.copy(venue)
        $scope.venue.contacts = [] unless $scope.venue.contacts
        $scope.contact = _.find $scope.venue.contacts, (it) -> it.type is 'PHONE'

        unless $scope.contact?
          $scope.contact =
            type: 'PHONE'
          $scope.venue.contacts.push $scope.contact

#      $scope.cancel = ->
#        delete $scope.venue
#        $scope.venueForm.$setPristine()
#
#      $scope.$on 'venue:created', $scope.cancel
#      $scope.$on 'venue:updated', $scope.cancel
#      $scope.$on 'venue:saved', $scope.cancel


      $scope.save = ->

        if $scope.venueForm.$valid

          $scope.locked = true

          VenueService.save($scope.venue).then((response) ->
            $scope.$emit 'venue:saved', response
            $scope.locked = false
          , (response) ->
            console.error 'update failed'
            $scope.locked = false
          )
    ]
  ])


