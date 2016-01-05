(function() {
  'use strict';
  angular.module('smartRegisterApp').filter('duration', [
    '$filter', function($filter) {
      return function(milliseconds, unit, fractionSize) {
        if (fractionSize == null) {
          fractionSize = 1;
        }
        return $filter('number')(moment.duration(milliseconds).as(unit), fractionSize);
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=duration.js.map
