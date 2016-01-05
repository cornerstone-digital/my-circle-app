(function() {
  'use strict';
  angular.module('smartRegisterApp').factory('SettingsService', [
    '$rootScope', function($rootScope) {
      return {
        getModules: function() {
          return {
            multivenue: {
              enabledEnv: {
                development: true,
                test: true,
                staging: true,
                demo: true,
                trial: false,
                live: true
              }
            }
          };
        },
        hasModuleEnabled: function(moduleName) {
          return this.getModules()[moduleName].enabledEnv[$rootScope.env];
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=settings-service.js.map
