(function() {
  'use strict';
  angular.module('smartRegisterApp').factory('Tool', [
    '$resource', 'Config', 'Auth', function($resource, Config, Auth) {
      return $resource("api://api/merchants/:merchantId/venues/:venueId/tools/:id", {
        id: "@id",
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
          method: 'PUT',
          transformRequest: function(resource, headers) {
            return JSON.stringify(_.omit(resource, 'appId'));
          }
        }
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=tool-resource.js.map
