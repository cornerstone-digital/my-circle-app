(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('requiresPermission', [
    'Auth', function(Auth) {
      return {
        restrict: 'A',
        scope: true,
        controller: [
          '$scope', 'Auth', function($scope, Auth) {
            return $scope.toggleClass = function(permission, element) {
              return element.toggleClass('ng-hide', !Auth.hasRole(permission));
            };
          }
        ],
        link: function($scope, $element, $attrs) {
          var permission;
          permission = $attrs.requiresPermission;
          $scope.toggleClass(permission, $element);
          return $scope.$on('auth:updated', function() {
            return $scope.toggleClass(permission, $element);
          });
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=requires-permission.js.map
