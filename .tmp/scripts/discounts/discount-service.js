(function() {
  angular.module('smartRegisterApp').factory('DiscountService', [
    '$rootScope', '$http', 'ResourceWithPaging', 'ResourceNoPaging', 'MessagingService', function($rootScope, $http, ResourceWithPaging, ResourceNoPaging, MessagingService) {
      return {
        "new": function() {
          var discount, _ref, _ref1;
          discount = ResourceNoPaging.one("merchants", (_ref1 = $rootScope.credentials.merchant) != null ? _ref1.id : void 0).one("venues", (_ref = $rootScope.credentials.venue) != null ? _ref.id : void 0).one("discounts");
          discount.value = 0;
          discount.groups = [];
          return discount;
        },
        getList: function(venueId, params) {
          var merchantId, _ref, _ref1, _ref2, _ref3;
          merchantId = (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.merchant) != null ? _ref1.id : void 0 : void 0;
          venueId = venueId != null ? venueId : (_ref2 = $rootScope.credentials) != null ? (_ref3 = _ref2.venue) != null ? _ref3.id : void 0 : void 0;
          params = params != null ? params : {};
          return ResourceNoPaging.one("merchants", merchantId).one("venues", venueId).getList("discounts", params);
        },
        getById: function(discountId, params) {
          var _ref, _ref1, _ref2;
          params = params != null ? params : {
            full: true
          };
          return ResourceNoPaging.one("merchants", (_ref1 = $rootScope.credentials) != null ? (_ref2 = _ref1.merchant) != null ? _ref2.id : void 0 : void 0).one("venues", (_ref = $rootScope.credentials.venue) != null ? _ref.id : void 0).one("discounts", discountId).get().then(function(response) {
            var discount;
            discount = response;
            if (!response.groups) {
              discount.groups = [];
            }
            return discount;
          });
        },
        save: function(discount) {
          var _ref, _ref1, _ref2;
          if (discount.id) {
            discount = ResourceNoPaging.copy(discount);
            return discount.save();
          } else {
            return ResourceNoPaging.one("merchants", (_ref1 = $rootScope.credentials) != null ? (_ref2 = _ref1.merchant) != null ? _ref2.id : void 0 : void 0).one("venues", (_ref = $rootScope.credentials.venue) != null ? _ref.id : void 0).post("discounts", discount);
          }
        },
        remove: function(discount) {
          discount = ResourceNoPaging.copy(discount);
          return discount.remove();
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=discount-service.js.map
