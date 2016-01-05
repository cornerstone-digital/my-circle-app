(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('MerchantsCtrl', [
    '$scope', '$http', '$location', 'Config', 'Merchant', 'Venue', 'Employee', 'merchants', 'merchantlist', 'MerchantService', 'SettingsService', function($scope, $http, $location, Config, Merchant, Venue, Employee, merchants, merchantlist, MerchantService, SettingsService) {
      var params, _ref, _ref1;
      if (angular.isDefined(merchantlist)) {
        $scope.merchantlist = merchantlist;
      }
      if (angular.isDefined(merchants)) {
        $scope.merchants = merchants;
      } else {
        params = {
          page: (_ref = $scope.currentPage - 1) != null ? _ref : null,
          size: (_ref1 = $scope.maxSize) != null ? _ref1 : null
        };
        MerchantService.getPagedList(params).then(function(response) {
          return $scope.merchants = response;
        });
      }
      if (angular.isDefined($scope.merchants.page)) {
        $scope.totalItems = $scope.merchants.page.totalElements;
        $scope.currentPage = $scope.merchants.page.number + 1;
        $scope.itemsPerPage = $scope.merchants.page.size;
        $scope.totalPages = $scope.merchants.page.totalPages;
      }
      $scope.setPage = function(pageNo) {
        return $scope.currentPage = pageNo;
      };
      $scope.pageChanged = function() {
        var _ref2, _ref3;
        params = {
          page: (_ref2 = $scope.currentPage - 1) != null ? _ref2 : null,
          size: (_ref3 = $scope.maxSize) != null ? _ref3 : null
        };
        return MerchantService.getPagedList(params).then(function(response) {
          return $scope.merchants = response;
        });
      };
      $scope.sort = 'name';
      $scope.reverse = false;
      $scope.create = function() {
        return $location.path('/merchants/add');
      };
      $scope["delete"] = function(merchant) {
        return MerchantService.getById(merchant.id).then(function(response) {
          merchant = response;
          return MerchantService.remove(merchant).then(function(response) {
            return $scope.merchants = _.reject($scope.merchants, function(it) {
              return it.id === merchant.id;
            });
          });
        });
      };
      $scope.edit = function(merchant) {
        return $location.path("/merchants/edit/" + merchant.id);
      };
      $scope.save = function() {
        var merchant, _ref2, _ref3;
        if ($scope.merchantForm.$valid) {
          merchant = $scope.merchant;
          $scope.locked = true;
          if (!(merchant != null ? merchant.id : void 0) && ((_ref2 = merchant.employees) != null ? (_ref3 = _ref2[0].credentials) != null ? _ref3[0] : void 0 : void 0)) {
            merchant.employees[0].credentials[0].uid = merchant.employees[0].email;
          }
          return MerchantService.save(merchant).then(function(response) {
            var index, newMerchant, _i, _ref4;
            newMerchant = response;
            if (merchant != null ? merchant.id : void 0) {
              for (index = _i = 0, _ref4 = $scope.merchants.length; 0 <= _ref4 ? _i < _ref4 : _i > _ref4; index = 0 <= _ref4 ? ++_i : --_i) {
                if ($scope.merchants[index].id === merchant.id) {
                  $scope.merchants[index] = angular.copy(merchant);
                }
              }
            } else {
              $scope.merchants.push(newMerchant);
              $scope.$root.$broadcast('merchant:created', newMerchant);
            }
            delete $scope.locked;
            return $scope.close();
          }, function(response) {
            console.error("failed to save credential");
            return delete $scope.locked;
          });
        }
      };
      $scope.close = function() {
        delete $scope.merchant;
        delete $scope.venue;
        return delete $scope.employee;
      };
      $scope.confirmedDelete = function(merchant) {
        return $scope.merchantToDelete = merchant;
      };
      $scope.closeConfirm = function() {
        return delete $scope.merchantToDelete;
      };
      $scope.confirmYes = function() {
        var index;
        $scope["delete"]($scope.merchantToDelete);
        index = $scope.merchants.indexOf($scope.merchantToDelete.id);
        $scope.merchants.splice(index, 1);
        return $scope.closeConfirm();
      };
      return $scope.hasModuleEnabled = function(moduleName) {
        return SettingsService.hasModuleEnabled(moduleName);
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=merchants-controller.js.map
