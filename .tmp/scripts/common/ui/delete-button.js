(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('deleteButton', [
    function() {
      return {
        scope: {
          resource: '='
        },
        restrict: 'A',
        controller: [
          '$scope', '$element', '$attrs', function($scope, $element, $attrs) {
            var disableButton, enableButton;
            disableButton = function() {
              return $element.prop('disabled', true);
            };
            enableButton = function() {
              return $element.prop('disabled', false);
            };
            $element.on('click', function() {
              return $scope.$emit('delete:requested', $scope.resource);
            });
            $scope.$on('delete:pending', function(event, entity) {
              if (entity.id === $scope.resource.id) {
                return disableButton();
              }
            });
            $scope.$on('delete:succeeded', function(event, entity) {
              if (entity.id === $scope.resource.id) {
                return enableButton();
              }
            });
            return $scope.$on('delete:failed', function(event, entity) {
              if (entity.id === $scope.resource.id) {
                return enableButton();
              }
            });
          }
        ]
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=delete-button.js.map
