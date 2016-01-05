(function() {
  'use strict';
  angular.module('smartRegisterApp').factory('Discount', [
    '$resource', 'Config', 'Auth', function($resource, Config, Auth) {
      return $resource("api://api/merchants/:merchantId/venues/:venueId/discounts/:id", {
        id: '@id',
        merchantId: function() {
          var _ref;
          return (_ref = Auth.getMerchant()) != null ? _ref.id : void 0;
        },
        venueId: function() {
          var _ref;
          return (_ref = Auth.getVenue()) != null ? _ref.id : void 0;
        }
      }, {
        update: {
          method: 'PUT'
        }
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=discounts-resource.js.map
