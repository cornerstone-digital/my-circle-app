'use strict'

angular.module('smartRegisterApp')
  .controller 'ToolsCtrl', ['$route', '$rootScope', '$scope', 'SettingsService', 'tools', 'venues', ($route, $rootScope, $scope, SettingsService, tools, venues) ->

    $scope.venues = venues
    $scope.venue = $rootScope.credentials.venue

    $scope.tools = _.filter tools, (it) ->
      it.appId.indexOf('.social.') == -1

    _.each $scope.tools, (tool) ->
      tool.groups = [] unless tool.groups?

    $scope.save = (tool) ->
      console.log tool
      tool.$update()

    $scope.hasModuleEnabled = (moduleName) ->
      SettingsService.hasModuleEnabled moduleName
      
    $scope.hasMultipleVenues = ->
      if($scope.venues.length > 1)
        return true
      else
        return false

    $scope.switchVenue = (venue) ->
      $scope.$broadcast 'venue:switch', venue

    $scope.$on 'venue:switch', (event, venue) ->
        $rootScope.credentials.venue = venue
        $route.reload()

  ]
