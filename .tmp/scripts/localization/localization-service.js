(function() {
  angular.module('smartRegisterApp').factory('LocalizationService', [
    '$rootScope', '$http', 'ResourceWithPaging', 'ResourceNoPaging', 'MessagingService', function($rootScope, $http, ResourceWithPaging, ResourceNoPaging, MessagingService) {
      return {
        getSupportedLanguages: function() {}
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=localization-service.js.map
