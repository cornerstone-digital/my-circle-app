(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('RootCtrl', [
    '$scope', '$rootScope', 'SettingsService', '$location', function($scope, $rootScope, SettingsService, $location) {
      $rootScope.hasModuleEnabled = function(moduleName) {
        return SettingsService.hasModuleEnabled(moduleName);
      };
      return $scope.safeApply = function(fn) {
        var phase;
        phase = this.$root.$$phase;
        if (phase === "$apply" || phase === "$digest") {
          if (fn && (typeof fn === "function")) {
            fn();
          }
        } else {
          this.$apply(fn);
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=root-controller.js.map
