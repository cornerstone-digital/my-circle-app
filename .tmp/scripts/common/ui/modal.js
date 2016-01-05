(function() {
  'use strict';

  /*
  Manages a Bootstrap modal by watching a scope value.
  
  The modal is shown when the value becomes non-null/undefined hidden when it
  becomes null/undefined.
  
  In addition if the modal is closed directly (i.e. with the escape key or by
  clicking on the background overlay) then a scope function is called. By default
  the directive tries to call a function called `cancel` but that can be
  overridden by specifying an `on-cancel` attribute.
   */
  angular.module('smartRegisterApp').directive('modal', [
    '$timeout', function($timeout) {
      return {
        restrict: 'C',
        link: function($scope, $element, $attrs) {
          if ($attrs.trigger != null) {
            $scope.$watch($attrs.trigger, function(newValue, oldValue) {
              if ((newValue != null) && (oldValue == null)) {
                $element.modal('show');
              }
              if ((oldValue != null) && (newValue == null)) {
                return $element.modal('hide');
              }
            });
            return $element.on('hide.bs.modal', function() {
              var onHide, _ref;
              onHide = $scope[(_ref = $attrs.onCancel) != null ? _ref : 'cancel'];
              onHide();
              return $timeout(function() {
                return $scope.$digest();
              });
            });
          }
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=modal.js.map
