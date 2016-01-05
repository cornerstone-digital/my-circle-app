(function() {
  'use strict';
  angular.module('smartRegisterHelp', []).run([
    '$rootScope', function($rootScope) {
      $rootScope.mode = 'app';
      if (typeof Modernizr !== "undefined" && Modernizr !== null ? Modernizr.touch : void 0) {
        return $(function() {
          return FastClick.attach(document.body);
        });
      }
    }
  ]);

}).call(this);

//# sourceMappingURL=help-app.js.map
