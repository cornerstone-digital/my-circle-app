(function() {
  'use strict';
  angular.module('smartRegisterApp').factory('Payments', [
    '$resource', 'Config', 'Auth', function($resource, Config, Auth) {
      return $resource("api://api/merchants/:merchantId/venues/:venueId/payments/:id", {
        id: "@id",
        venueId: function() {
          var _ref;
          return (_ref = Auth.getVenue()) != null ? _ref.id : void 0;
        },
        merchantId: function() {
          var _ref;
          return (_ref = Auth.getMerchant()) != null ? _ref.id : void 0;
        }
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=payments-resource.js.map
