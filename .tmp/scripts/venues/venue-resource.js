(function() {
  'use strict';
  angular.module('smartRegisterApp').factory('Venue', [
    '$location', '$resource', 'Config', '$rootScope', function($location, $resource, Config, $rootScope) {
      return $resource("api://api/merchants/:merchantId/venues/:id", {
        id: "@id",
        merchantId: function() {
          var _ref, _ref1;
          return (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.merchant) != null ? _ref1.id : void 0 : void 0;
        }
      }, {
        query: {
          method: 'GET',
          isArray: true,
          params: {
            full: true
          }
        }
      }, {
        update: {
          method: 'PUT',
          params: {
            id: '@id'
          }
        }
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=venue-resource.js.map
