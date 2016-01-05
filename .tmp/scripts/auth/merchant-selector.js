(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('merchantSelector', [
    function() {
      return {
        restrict: 'C',
        scope: true,
        template: '<select class="form-control input-sm"\n        data-ng-show="merchants.length"\n        data-ng-model="merchant"\n        data-ng-options="merchant.name for merchant in merchants track by merchant.id"\n        data-ng-change="switchMerchant(merchant)"\n        data-requires-permission="PERM_PLATFORM_ADMINISTRATOR"\n        required>\n</select>',
        controller: [
          '$scope', '$rootScope', '$route', 'Auth', 'Merchant', 'MerchantService', function($scope, $rootScope, $route, Auth, Merchant, MerchantService) {
            $scope.switchMerchant = function(merchant) {
              return Auth.impersonateMerchant(merchant, function() {
                return $route.reload();
              });
            };
            $scope.canSwitchMerchant = function() {
              return Auth.hasRole('PERM_PLATFORM_ADMINISTRATOR');
            };
            if ($scope.canSwitchMerchant()) {
              $scope.merchant = Auth.getMerchant();
              $scope.venue = Auth.getVenue();
              MerchantService.getList().then(function(response) {
                $rootScope.merchants = response;
                return $rootScope.merchantCount = response.length;
              });
            }
            $scope.$on('auth:updated', function() {
              return $scope.merchant = Auth.getMerchant();
            });
            return $scope.$on('merchant:created', function(event, merchant) {
              if (merchant.enabled) {
                return $rootScope.merchants.push(merchant);
              }
            });
          }
        ]
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=merchant-selector.js.map
