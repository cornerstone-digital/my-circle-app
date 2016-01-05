(function() {
  'use strict';
  angular.module('smartRegisterApp').factory('Order', [
    '$resource', 'Config', '$location', 'Auth', function($resource, Config, $location, Auth) {
      return $resource("api://api/merchants/:merchantId/venues/:venueId/orders/:id", {
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
          params: {
            sort: 'created,desc'
          },
          transformResponse: function(data) {
            if (typeof data === 'string') {
              data = JSON.parse(data);
            }
            return data.content;
          }
        },
        refund: {
          method: 'PUT',
          transformRequest: function(data) {
            return JSON.stringify({
              items: _.pluck(data.basket.items.filter(function(item) {
                return item.toRefund;
              }), 'id'),
              pos: $location.search()['pos.name']
            });
          }
        }
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=order-resource.js.map
