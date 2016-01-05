(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('btnLogout', [
    '$location', 'Auth', function($location, Auth) {
      return {
        restrict: 'C',
        link: function(scope, element) {
          element.on('click', function() {
            Auth.logout();
            return $location.path('/login');
          });
          return scope.isLoggedIn = function() {
            return Auth.isLoggedIn();
          };
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=logout-button.js.map
