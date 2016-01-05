'use strict'

angular.module('smartRegisterApp')
  .controller 'FoursquareCtrl', ['$scope', '$http', 'MessagingService', ($scope, $http, MessagingService) ->

    $scope.tool = $scope.toolFor('foursquare')

    $scope.save = ->
      $scope.tool.$update()

      MessagingService.resetMessages()
      message = MessagingService.createMessage("success", "Your Foursquare settings have been saved", 'Foursquare')
      MessagingService.addMessage(message)
      MessagingService.hasMessages('Social')

    $scope.deleteVenue = ->
      delete $scope.tool.properties.venueId
      $scope.tool.$update()

    $scope.isValidVenue = ->
      $scope.tool.properties?.venueId?
  ]
