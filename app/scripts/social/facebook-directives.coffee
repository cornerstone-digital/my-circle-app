'use strict'

angular.module('smartRegisterApp')
  .directive('facebookUser', ['$http', ($http) ->
    replace: true
    restrict: 'E'
    scope:
      tool: '='
    template: '<figure data-ng-if="user" class="media"><img data-ng-src="{{picture()}}" class="img-rounded media-object pull-left"><figcaption class="media-body">Connected as&hellip;<br><span class="name">{{user.name}}</span></figcaption></figure>'
    link: ($scope, $element, $attrs) ->

      $scope.picture = ->
        if angular.isDefined $scope.tool.properties.token
          "https://graph.facebook.com/me/picture?width=64&height=64&access_token=#{$scope.tool.properties.token}"

      $scope.$watch 'tool.properties.token', (token) ->
        if token?
          if angular.isDefined $scope.tool.properties.token
            $http.get("https://graph.facebook.com/me?format=json&access_token=#{$scope.tool.properties.token}")
              .success (user) ->
                $scope.user = user
              .error (response, status) ->
                console.error 'could not get user details from Facebook', status, response
        else
          delete $scope.user
  ])
