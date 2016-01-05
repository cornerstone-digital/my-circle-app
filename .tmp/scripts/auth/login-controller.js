(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('LoginCtrl', [
    '$rootScope', '$scope', '$location', 'Auth', function($rootScope, $scope, $location, Auth) {
      if (Auth.isLoggedIn()) {
        $location.path('/');
      }
      return $scope.login = function() {
        return Auth.login({
          email: $scope.email,
          password: $scope.password
        }, function(credentials) {
          return $location.path(($rootScope.retryPath != null) && $rootScope.retryPath !== '/login' ? $rootScope.retryPath : '/');
        }, function(message) {
          return $rootScope.error = message;
        });
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=login-controller.js.map
