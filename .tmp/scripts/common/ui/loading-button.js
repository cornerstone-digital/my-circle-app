(function() {
  'use strict';

  /*
  A button that goes into a loading state when clicked or the containing form
  (if any) is submitted & comes out of it automatically when all pending $http
  requests are completed.
  
  The directive is aware of any ng-disabled directive that exists on the same
  button.
   */
  angular.module('smartRegisterApp').directive('loadingButton', [
    '$http', function($http) {
      return {
        require: ['^?form', '?ngDisabled'],
        restrict: 'A',
        scope: true,
        link: function($scope, $element, $attrs, controllers) {
          var $form, activateLoadingState, deactivateLoadingState, formController, loadingText, originalText;
          formController = controllers[0];
          originalText = $element.html();
          loadingText = $attrs.loadingButton;
          if (!loadingText) {
            loadingText = 'Loading\u2026';
          }
          $form = $element.closest('form');
          activateLoadingState = function() {
            if ((formController == null) || formController.$valid) {
              return $element.prop('disabled', true).html(loadingText);
            }
          };
          deactivateLoadingState = function() {
            $element.html(originalText);
            return $element.prop('disabled', $attrs.ngDisabled ? $scope.$eval($attrs.ngDisabled) : false);
          };
          $form.on('submit', activateLoadingState);
          if (!($form.length > 0)) {
            $element.on('click', activateLoadingState);
          }
          $scope.activeRequests = function() {
            return $http.pendingRequests.length;
          };
          return $scope.$watch('activeRequests()', function(value) {
            if (value === 0) {
              return deactivateLoadingState();
            }
          });
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=loading-button.js.map
