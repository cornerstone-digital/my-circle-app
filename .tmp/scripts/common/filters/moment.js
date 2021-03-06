(function() {
  'use strict';
  angular.module('smartRegisterApp').filter('moment', [
    function() {
      return function(date, format) {
        return moment(date).format(format);
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=moment.js.map
