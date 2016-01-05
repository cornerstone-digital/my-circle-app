(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('loggedInAs', function() {
    return {
      replace: true,
      restrict: 'C',
      scope: true,
      template: '<span data-ng-show="username()">{{username()}}</span>',
      controller: [
        '$scope', 'Auth', function($scope, Auth) {
          return $scope.username = function() {
            var _ref;
            return (_ref = Auth.getCredentials()) != null ? _ref.username : void 0;
          };
        }
      ]
    };
  });

}).call(this);

//# sourceMappingURL=logged-in-as.js.map
