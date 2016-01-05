(function() {
  'use strict';
  angular.module('API', ['restangular']).config(function(RestangularProvider) {
    RestangularProvider.setBaseUrl("api://api");
  });

  angular.module('API').factory('ResourceWithPaging', [
    'Restangular', function(Restangular) {
      var resource;
      resource = Restangular.withConfig(function(RestangularProvider) {
        return RestangularProvider.setResponseExtractor(function(response, operation) {
          var newResponse, _ref, _ref1, _ref2;
          if (operation === "getList") {
            newResponse = (_ref = response.content) != null ? _ref : [];
            newResponse.page = (_ref1 = response.page) != null ? _ref1 : {};
            newResponse.links = (_ref2 = response.links) != null ? _ref2 : {};
            return newResponse;
          } else {
            return response;
          }
        });
      });
      return resource;
    }
  ]);

  angular.module('API').factory('ResourceNoPaging', [
    '$rootScope', 'Restangular', function($rootScope, Restangular) {
      var resource;
      resource = Restangular.withConfig(function(RestangularProvider) {
        return RestangularProvider.setResponseExtractor(function(response, operation) {
          var newResponse;
          if (operation === "getList") {
            if (angular.isObject(response)) {
              newResponse = [];
              angular.forEach(response, function(value, index) {
                return newResponse.push(value);
              });
              return newResponse;
            }
            return response;
          } else {
            return response;
          }
        });
      });
      return resource;
    }
  ]);

}).call(this);

//# sourceMappingURL=API.js.map
