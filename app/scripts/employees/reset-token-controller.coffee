'use strict'

angular.module('smartRegisterApp')
.controller 'ResetTokenCtrl', ['$rootScope','$scope', '$timeout', '$location', 'EmployeeService', 'MessagingService', 'ValidationService', 'Auth', 'token', ($rootScope, $scope, $timeout, $location, EmployeeService, MessagingService, ValidationService, Auth, token) ->
  if angular.isDefined(token)
    $scope.token = token
  else
    message = MessagingService.createMessage('error', 'A valid token is required to be passed in the URL.', 'ResetToken', '/login', 'Go to login page')
    MessagingService.addMessage(message)
    MessagingService.hasMessages('ResetToken')

  $scope.resetToken = ->
    MessagingService.resetMessages()
    ValidationService.reset()
    ValidationService.validate()

    if(!MessagingService.hasMessages('ResetToken').length)
      EmployeeService.resetToken($scope.token, $scope.new_password)

      message = MessagingService.createMessage('success', 'Your password has been successfully reset.', 'ResetToken', '/login', 'Go to login screen')
      MessagingService.addMessage(message)
      MessagingService.hasMessages('ResetToken')
]
