(function() {
  'use strict';
  angular.module('smartRegisterApp').factory('Catalog', [
    'catalogTemplate', '$http', '$timeout', 'Config', 'VenueService', function(catalogTemplate, $http, $timeout, Config, VenueService) {
      return {
        populate: function(merchant, venue, categories, completeCallback) {
          var createNextCategory, createNextProduct;
          createNextProduct = function(categoryId, products, completeCallback) {
            var product;
            product = products.pop();
            product.category = categoryId;
            return $http.post("api://api/merchants/" + merchant.id + "/venues/" + venue.id + "/products", product).success(function(response) {
              if (products.length) {
                return createNextProduct(categoryId, products, completeCallback);
              } else {
                return completeCallback();
              }
            });
          };
          createNextCategory = function(categories, completeCallback) {
            var category, products;
            category = categories.pop();
            products = category.products;
            delete category.products;
            return $http.post("api://api/merchants/" + merchant.id + "/venues/" + venue.id + "/categories", category).success(function(response) {
              return createNextProduct(response.id, products, function() {
                if (categories.length) {
                  return createNextCategory(categories, completeCallback);
                } else {
                  return completeCallback();
                }
              });
            });
          };
          return createNextCategory(categories, completeCallback);
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=catalog-service.js.map
