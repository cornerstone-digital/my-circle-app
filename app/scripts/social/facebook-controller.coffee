'use strict'

angular.module('smartRegisterApp')
  .controller 'FacebookCtrl', ['$scope', '$http', 'MessagingService', ($scope, $http, MessagingService) ->

    $scope.tool = $scope.toolFor('facebook')

    $scope.save = ->
      $scope.tool.$update()

      MessagingService.resetMessages()
      message = MessagingService.createMessage("success", "Your Facebook settings have been saved", 'Facebook')
      MessagingService.addMessage(message)
      MessagingService.hasMessages('Social')

    $scope.$watch 'page', (page) ->
      if page?
        $scope.tool.properties.pageId = page.id
        $scope.tool.properties.pageName = page.name
        $scope.tool.properties.pageToken = page.access_token

    $scope.$watch 'tool.properties.token', (token) ->
      if token?
        if angular.isDefined $scope.tool.properties.token
          $http.get("https://graph.facebook.com/me?fields=accounts.fields(name,access_token)&format=json&access_token=#{token}")
            .success (user) ->
              $scope.pages = user.accounts.data
              $scope.page = _.find $scope.pages, (it) ->
                it.id is $scope.tool.properties.pageId
            .error (response, status) ->
              console.error 'could not get pages for user from Facebook', status, response
  ]
