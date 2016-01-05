(function() {
  angular.module('smartRegisterApp').factory('ProductService', [
    '$rootScope', 'ResourceNoPaging', 'SettingsService', 'Auth', function($rootScope, ResourceNoPaging, SettingsService, Auth) {
      return {
        "new": function(venueId) {
          var product, _ref;
          product = ResourceNoPaging.one("merchants", (_ref = $rootScope.credentials.merchant) != null ? _ref.id : void 0).one("venues").one("venues", venueId).one("products");
          product.tax = 0.20;
          product.altTax = 0.20;
          product.modifiers = [];
          return product;
        },
        getListByCategory: function(venueId, categoryId, params) {
          var _ref, _ref1, _ref2, _ref3;
          venueId = venueId != null ? venueId : (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.venue) != null ? _ref1.id : void 0 : void 0;
          params = params != null ? params : {};
          return ResourceNoPaging.one("merchants", (_ref2 = $rootScope.credentials) != null ? (_ref3 = _ref2.merchant) != null ? _ref3.id : void 0 : void 0).one("venues", venueId).one("categories", categoryId).getList("products");
        },
        getById: function(venueId, productId, params) {
          var _ref, _ref1;
          venueId = venueId != null ? venueId : (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.venue) != null ? _ref1.id : void 0 : void 0;
          params = params != null ? params : {};
          return ResourceNoPaging.one("merchants", $rootScope.credentials.merchant.id).one("venues", venueId).one("products", productId).get(params);
        },
        save: function(venueId, product) {
          var _ref, _ref1;
          if (product.id) {
            return product.save();
          } else {
            return ResourceNoPaging.one("merchants", (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.merchant) != null ? _ref1.id : void 0 : void 0).one("venues", venueId).post("products", product);
          }
        },
        batchSave: function(venueId, products) {
          var _ref, _ref1;
          if (products.length) {
            return ResourceNoPaging.one("merchants", (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.merchant) != null ? _ref1.id : void 0 : void 0).one("venues", venueId).one("products").customPUT(products);
          }
        },
        remove: function(product) {
          var _ref, _ref1, _ref2, _ref3;
          return ResourceNoPaging.one("merchants", (_ref2 = $rootScope.credentials) != null ? (_ref3 = _ref2.merchant) != null ? _ref3.id : void 0 : void 0).one("venues", (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.venue) != null ? _ref1.id : void 0 : void 0).one("products", product.id).remove();
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=products-service.js.map
