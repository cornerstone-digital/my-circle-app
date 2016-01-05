(function() {
  'use strict';
  angular.module('smartRegisterApp').factory('Event', [
    '$resource', 'Config', 'Auth', function($resource, Config, Auth) {
      return $resource("api://api/merchants/:merchantId/venues/:venueId/events/:id", {
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
        query: {
          method: 'GET',
          isArray: true,
          transformResponse: function(data) {
            if (typeof data === 'string') {
              data = JSON.parse(data);
            }
            return data.content;
          }
        }
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=event-resource.js.map
