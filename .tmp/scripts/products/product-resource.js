(function() {
  'use strict';
  angular.module('smartRegisterApp').factory('Product', [
    '$resource', 'Config', 'Auth', function($resource, Config, Auth) {
      return $resource("api://api/merchants/:merchantId/venues/:venueId/products/:id", {
        id: "@id",
        venueId: function() {
          var _ref;
          return (_ref = Auth.getVenue()) != null ? _ref.id : void 0;
        },
        merchantId: function() {
          var _ref;
          return (_ref = Auth.getMerchant()) != null ? _ref.id : void 0;
        }
      }, {
        update: {
          method: 'PUT'
        }
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=product-resource.js.map
