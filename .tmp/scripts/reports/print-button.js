(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('reportPrintButton', [
    '$location', function($location) {
      return {
        replace: true,
        restrict: 'E',
        template: '<div class="btn-group app-only">\n   <a href="/printreport" class="btn btn-default btn-lg" data-ng-click="print(\'small\')">Print</a>\n</div>',
        link: function($scope, $element) {
          return $scope.print = function(size) {
            var $body, s, _i, _len, _ref;
            $body = $element.parents('body');
            _ref = ['small', 'medium', 'large'];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              s = _ref[_i];
              $body.removeClass("print-" + s);
            }
            $body.addClass("print-" + size);
            return true;
          };
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=print-button.js.map
