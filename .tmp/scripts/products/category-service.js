(function() {
  angular.module('smartRegisterApp').factory('CategoryService', [
    '$rootScope', 'ResourceNoPaging', function($rootScope, ResourceNoPaging) {
      return {
        getList: function(venueId, params) {
          var _ref, _ref1, _ref2, _ref3;
          venueId = venueId != null ? venueId : (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.venue) != null ? _ref1.id : void 0 : void 0;
          params = params != null ? params : {};
          return ResourceNoPaging.one("merchants", (_ref2 = $rootScope.credentials) != null ? (_ref3 = _ref2.merchant) != null ? _ref3.id : void 0 : void 0).one("venues", venueId).getList("categories", params);
        },
        getById: function(venueId, categoryId, params) {
          var _ref, _ref1;
          venueId = venueId != null ? venueId : (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.venue) != null ? _ref1.id : void 0 : void 0;
          params = params != null ? params : {};
          return ResourceNoPaging.one("merchants", $rootScope.credentials.merchant.id).one("venues", venueId).one("categories", categoryId).get(params);
        },
        save: function(venueId, category) {
          var _ref, _ref1;
          if (category.id) {
            category = ResourceNoPaging.copy(category);
            return category.save();
          } else {
            return ResourceNoPaging.one("merchants", (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.merchant) != null ? _ref1.id : void 0 : void 0).one("venues", venueId).post("categories", category);
          }
        },
        remove: function(category) {
          category = ResourceNoPaging.copy(category);
          return category.remove();
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=category-service.js.map
