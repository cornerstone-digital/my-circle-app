'use strict'

angular.module('smartRegisterApp')
.directive 'venueSelector', [ ->
  restrict: 'C'
  scope: true
  template: '''
    <select class="form-control input-sm"
            data-ng-if="canSwitchVenue()"
            data-ng-show="venues.length"
            data-ng-model="venue"
            data-ng-options="venue.name for venue in venues track by venue.id"
            data-ng-change="switchVenue(venue)"
            required>
    </select>'''
  controller: ['$rootScope', '$scope', '$route', 'Auth', 'Venue', ($rootScope, $scope, $route, Auth, Venue) ->
    if angular.isDefined $rootScope.credentials.merchant
      $scope.venues = $rootScope.credentials.merchant.venues

    $scope.switchVenue = (venue) ->
      Auth.switchVenue venue, ->
        $route.reload()
        $scope.$apply
        $scope.selectedVenue = venue

    $scope.canSwitchVenue = ->
      Auth.hasRole 'PERM_MERCHANT_ADMINISTRATOR'



  ]
]


