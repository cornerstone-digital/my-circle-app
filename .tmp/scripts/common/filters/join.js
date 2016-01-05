(function() {
  'use strict';

  /*
  Joins an array into a string using a delimiter which defaults to ", ".
  If given a comma-separated string instead of an array it will split and
  re-join it.
   */
  angular.module('smartRegisterApp').filter('join', [
    function() {
      return function(input, delimiter) {
        if (delimiter == null) {
          delimiter = ', ';
        }
        if (typeof input === "string") {
          input = input.split(',');
        }
        return input.join(delimiter);
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=join.js.map
