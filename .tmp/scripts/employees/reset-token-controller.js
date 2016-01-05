(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('ResetTokenCtrl', [
    '$rootScope', '$scope', '$timeout', '$location', 'EmployeeService', 'MessagingService', 'ValidationService', 'Auth', 'token', function($rootScope, $scope, $timeout, $location, EmployeeService, MessagingService, ValidationService, Auth, token) {
      var message;
      if (angular.isDefined(token)) {
        $scope.token = token;
      } else {
        message = MessagingService.createMessage('error', 'A valid token is required to be passed in the URL.', 'ResetToken', '/login', 'Go to login page');
        MessagingService.addMessage(message);
        MessagingService.hasMessages('ResetToken');
      }
      return $scope.resetToken = function() {
        MessagingService.resetMessages();
        ValidationService.reset();
        ValidationService.validate();
        if (!MessagingService.hasMessages('ResetToken').length) {
          EmployeeService.resetToken($scope.token, $scope.new_password);
          message = MessagingService.createMessage('success', 'Your password has been successfully reset.', 'ResetToken', '/login', 'Go to login screen');
          MessagingService.addMessage(message);
          return MessagingService.hasMessages('ResetToken');
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=reset-token-controller.js.map
