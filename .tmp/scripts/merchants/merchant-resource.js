(function() {
  'use strict';
  angular.module('smartRegisterApp').factory('Merchant', [
    '$resource', 'Config', function($resource, Config) {
      return $resource("api://api/merchants/:id", {
        id: "@id"
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
      }, {
        update: {
          method: 'PUT'
        }
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=merchant-resource.js.map
