(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('actionButton', [
    function() {
      return {
        restrict: 'A',
        link: function($scope, $element, $attrs) {
          var loadingText, originalText, _ref;
          originalText = $element.html();
          loadingText = (_ref = $attrs.loadingText) != null ? _ref : 'Loading\u2026';
          $scope.$on("" + $attrs.action + ":starting", function() {
            return $element.prop('disabled', true).html(loadingText);
          });
          return $scope.$on("" + $attrs.action + ":complete", function() {
            return $element.prop('disabled', false).html(originalText);
          });
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=action-button.js.map
