(function() {
  'use strict';

  /*
  Converts a camel-case string to dash-case.
   */
  angular.module('smartRegisterApp').filter('dashCase', [
    function() {
      return function(str) {
        var s;
        s = str.replace(/([A-Z])/g, function($1) {
          return "-" + ($1.toLowerCase());
        });
        if (s.charAt(0) === '-') {
          return s.substr(1);
        } else {
          return s;
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=dash-case.js.map
