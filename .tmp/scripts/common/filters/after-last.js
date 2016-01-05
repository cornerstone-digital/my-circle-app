(function() {
  'use strict';
  angular.module('smartRegisterApp').filter('afterLast', [
    function() {
      return function(it, delimiter) {
        return it.substring(it.lastIndexOf(delimiter) + 1);
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=after-last.js.map
