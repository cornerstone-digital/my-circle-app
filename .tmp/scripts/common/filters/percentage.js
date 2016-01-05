(function() {
  'use strict';
  angular.module('smartRegisterApp').filter('percentage', [
    function() {
      return function(value) {
        return "" + (value * 100) + "%";
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=percentage.js.map
