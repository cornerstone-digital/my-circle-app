'use strict'

angular.module('smartRegisterApp')
  .controller 'SocialCtrl', ['$route', '$rootScope', '$scope', 'SettingsService', 'MessagingService', 'tools', 'venues', ($route, $rootScope, $scope, SettingsService, MessagingService, tools, venues ) ->
    
    $scope.tools = tools
    $scope.venues = venues
    $scope.venue = $rootScope.credentials.venue

    $scope.connect = (provider) ->
      OAuth.redirect provider, '/'

    $scope.disconnect = (provider) ->
      tool = $scope.toolFor(provider)
      delete tool.properties[key] for key of tool.properties
      tool.$update()

    $scope.isConnected = (provider) ->
      $scope.toolFor(provider)?.properties?.token?

    $scope.toolFor = (provider) ->
      _.find $scope.tools, (it) -> it.appId is "com.mycircleinc.smarttools.social.#{provider}"

    $scope.save = (tool) ->
      tool.$update()

      MessagingService.resetMessages()
      message = MessagingService.createMessage("success", "Your #{tool.name} settings have been saved", 'Twitter')
      MessagingService.addMessage(message)
      MessagingService.hasMessages('Social')

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
