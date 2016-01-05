'use strict'

angular.module('smartRegisterApp')
.controller 'ForgottenPasswordCtrl', ['$rootScope','$scope', 'EmployeeService','MessagingService', ($rootScope, $scope, EmployeeService, MessagingService) ->
  $scope.requestPasswordReset = ->
    MessagingService.resetMessages()
    $rootScope.$broadcast 'validate-data:validate'

    if(!MessagingService.hasMessages('ForgottenPassword').length)
      EmployeeService.requestPasswordReset($scope.email).then((response) ->
        message = MessagingService.createMessage('success', 'An email has been sent to ' + $scope.email + ' with password reset instructions.', 'ForgottenPassword', '/login', 'Go to login screen')
        MessagingService.addMessage(message)
        MessagingService.hasMessages('ForgottenPassword')
      )
]





