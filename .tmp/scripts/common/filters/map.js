(function() {
  'use strict';

  /*
  Transforms an array of objects into an array of a particular property of each object.
   */
  angular.module('smartRegisterApp').filter('map', [
    function() {
      return function(input, property) {
        return _.pluck(input, property);
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=map.js.map
