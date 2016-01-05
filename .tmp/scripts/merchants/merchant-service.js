(function() {
  angular.module('smartRegisterApp').factory('MerchantService', [
    '$rootScope', 'ResourceWithPaging', 'ResourceNoPaging', '$route', function($rootScope, ResourceWithPaging, ResourceNoPaging, $route) {
      return {
        "new": function() {
          var merchant;
          merchant = ResourceNoPaging.one("merchants");
          merchant.enabled = true;
          merchant.venues = [
            {
              address: {
                country: {
                  numericCode: 826
                },
                isAddressFor: 'ALL'
              },
              contacts: [
                {
                  type: 'NAME',
                  value: ''
                }, {
                  type: 'PHONE',
                  value: ''
                }, {
                  type: 'EMAIL',
                  value: ''
                }
              ]
            }
          ];
          merchant.employees = [
            {
              enabled: true,
              credentials: [
                {
                  type: 'EMAIL'
                }
              ],
              groups: [
                {
                  name: 'MERCHANT_ADMINISTRATORS'
                }
              ]
            }
          ];
          return merchant;
        },
        getPagedList: function(params) {
          var _ref, _ref1, _ref2;
          if (!angular.isObject(params)) {
            params = {
              page: (_ref = $route.current.params.page) != null ? _ref : null,
              size: (_ref1 = $route.current.params.size) != null ? _ref1 : null,
              sort: (_ref2 = $route.current.params.sort) != null ? _ref2 : null
            };
          }
          return ResourceWithPaging.all("merchants").getList(params);
        },
        getList: function() {
          return ResourceNoPaging.all("merchants").all("list").getList();
        },
        getById: function(merchantId, params) {
          merchantId = merchantId != null ? merchantId : $rootScope.credentials.merchant.id;
          params = params != null ? params : {
            full: false
          };
          return ResourceNoPaging.one("merchants", merchantId).get(params);
        },
        save: function(merchant) {
          if (merchant.id) {
            return merchant.save();
          } else {
            return ResourceNoPaging.all("merchants").post(merchant);
          }
        },
        remove: function(merchant) {
          return merchant.remove();
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=merchant-service.js.map
