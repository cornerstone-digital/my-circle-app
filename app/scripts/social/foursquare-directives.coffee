'use strict'

angular.module('smartRegisterApp')
  .directive('foursquareUser', ['$http', ($http) ->
    replace: true
    restrict: 'E'
    scope:
      tool: '='
    template: '<figure data-ng-if="user" class="media"><img data-ng-src="{{user.photo.prefix}}64x64{{user.photo.suffix}}" class="img-rounded media-object pull-left"><figcaption class="media-body">Connected as&hellip;<br><span class="name">{{user.firstName}} {{user.lastName}}</span></figcaption></figure>'
    link: ($scope, $element, $attrs) ->
      $scope.$watch 'tool.properties.token', (token) ->
        if token?
          $http.get("https://api.foursquare.com/v2/users/self?oauth_token=#{token}&v=#{moment().format('YYYYMMDD')}")
            .success (response) ->
              $scope.user = response.response.user
            .error (response, status) ->
              console.error 'could not get user details from Foursquare', status, response
        else
          delete $scope.user
  ])
  .directive('foursquareVenue', ['$http', ($http) ->
    replace: true
    restrict: 'E'
    scope:
      tool: '='
    template: '''\
      <div class="alert" data-ng-class="{'alert-success': venue, 'alert-danger': error}">
        <div data-ng-if="venue"><strong>{{venue.name}}</strong><br>{{venue.location.address}}, {{venue.location.city}} {{venue.location.postalCode}}</div>
        <div data-ng-if="error"><strong>Error</strong><br>{{error}}</div>
      </div>
    '''
    link: ($scope, $element, $attrs) ->
      $scope.$watch 'tool.properties.venueId', (venueId) ->
        if venueId?
          $http.get("https://api.foursquare.com/v2/venues/#{venueId}?oauth_token=#{$scope.tool.properties.token}&v=#{moment().format('YYYYMMDD')}")
          .success (response) ->
            $scope.venue = response.response.venue
            delete $scope.error
          .error (response, status) ->
            delete $scope.venue
            $scope.error = response.meta.errorDetail
        else
          delete $scope.venue
          delete $scope.error
  ])
