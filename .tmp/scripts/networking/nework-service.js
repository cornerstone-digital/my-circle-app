(function() {
  angular.module('smartRegisterApp').factory('NetworkService', [
    '$rootScope', 'MessagingService', function($rootScope, MessagingService) {
      return {
        isOnline: function() {
          console.log($rootScope.online);
          return $rootScope.online;
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=nework-service.js.map
