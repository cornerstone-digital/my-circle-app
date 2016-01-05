(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('time', [
    function() {
      return {
        replace: false,
        restrict: 'E',
        scope: {
          moment: '='
        },
        link: function($scope, $element, $attrs) {
          var format, update, _ref;
          format = (_ref = $attrs.format) != null ? _ref : 'ddd Do MMM YYYY';
          update = function(value) {
            var m;
            if (value != null) {
              m = moment(value);
              $element.attr('datetime', m.toISOString());
              return $element.text(m.format(format));
            }
          };
          return $scope.$watch('moment', update);
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=time.js.map
