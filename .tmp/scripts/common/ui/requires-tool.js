(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('requiresTool', [
    'Auth', function(Auth) {
      return {
        restrict: 'A',
        scope: true,
        link: function($scope, $element, $attrs) {
          var toolId;
          toolId = $attrs.requiresTool;
          return $scope.$on('auth:updated', function() {
            return $element.toggleClass('ng-hide', !Auth.hasTool(toolId));
          });
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=requires-tool.js.map
