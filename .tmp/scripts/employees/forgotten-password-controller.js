(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('ForgottenPasswordCtrl', [
    '$rootScope', '$scope', 'EmployeeService', 'MessagingService', function($rootScope, $scope, EmployeeService, MessagingService) {
      return $scope.requestPasswordReset = function() {
        MessagingService.resetMessages();
        $rootScope.$broadcast('validate-data:validate');
        if (!MessagingService.hasMessages('ForgottenPassword').length) {
          return EmployeeService.requestPasswordReset($scope.email).then(function(response) {
            var message;
            message = MessagingService.createMessage('success', 'An email has been sent to ' + $scope.email + ' with password reset instructions.', 'ForgottenPassword', '/login', 'Go to login screen');
            MessagingService.addMessage(message);
            return MessagingService.hasMessages('ForgottenPassword');
          });
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=forgotten-password-controller.js.map
