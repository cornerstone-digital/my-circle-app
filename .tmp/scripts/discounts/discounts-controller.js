(function() {
  angular.module('smartRegisterApp').controller('DiscountsCtrl', [
    '$route', '$scope', '$rootScope', '$location', 'venues', 'discounts', 'SettingsService', 'DiscountService', 'venues', function($route, $scope, $rootScope, $location, venues, discounts, SettingsService, DiscountService) {
      $scope.discounts = discounts;
      $scope.venues = venues;
      $scope.venue = $rootScope.credentials.venue;
      $scope.create = function() {
        return $location.path("/discounts/add/");
      };
      $scope.edit = function(discount) {
        return $location.path("/discounts/edit/" + discount.id);
      };
      $scope.save = function() {
        var discount;
        discount = $scope.discount;
        if ($scope.discountForm.$valid) {
          if (discount.id != null) {
            return discount.$update(function() {
              var index, _i, _ref;
              for (index = _i = 0, _ref = $scope.discounts.length; 0 <= _ref ? _i < _ref : _i > _ref; index = 0 <= _ref ? ++_i : --_i) {
                if ($scope.discounts[index].id === discount.id) {
                  $scope.discounts[index] = discount;
                }
              }
              return $scope.cancel();
            });
          } else {
            return discount.$save(function() {
              $scope.discounts.push(discount);
              return $scope.cancel();
            });
          }
        }
      };
      $scope.remove = function(discount) {
        return DiscountService.remove(discount).then(function() {
          var index;
          index = $scope.discounts.indexOf(discount);
          return $scope.discounts.splice(index, 1);
        }, function() {
          console.error("could not delete", discount);
          return $scope.$broadcast("delete:failed", discount);
        });
      };
      $scope.toggleAvailableTo = function(role) {
        var idx;
        idx = $scope.discount.availableTo.indexOf(role);
        if (idx > -1) {
          return $scope.discount.availableTo.splice(idx, 1);
        } else {
          return $scope.discount.availableTo.push(role);
        }
      };
      $scope.canAddDiscount = function() {
        return $scope.discounts.length < 3;
      };
      $scope.hasModuleEnabled = function(moduleName) {
        return SettingsService.hasModuleEnabled(moduleName);
      };
      $scope.hasMultipleVenues = function() {
        if ($scope.venues.length > 1) {
          return true;
        } else {
          return false;
        }
      };
      $scope.switchVenue = function(venue) {
        return $scope.$broadcast('venue:switch', venue);
      };
      return $scope.$on('venue:switch', function(event, venue) {
        $rootScope.credentials.venue = venue;
        return $route.reload();
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=discounts-controller.js.map
