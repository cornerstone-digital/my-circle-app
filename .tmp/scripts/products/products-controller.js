(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('ProductsCtrl', [
    '$route', '$scope', '$rootScope', '$location', '$timeout', 'venue', 'venues', 'merchant', 'categories', 'products', 'sections', 'VenueService', 'ProductService', 'Catalog', 'catalogTemplate', 'CategoryService', 'SettingsService', function($route, $scope, $rootScope, $location, $timeout, venue, venues, merchant, categories, products, sections, VenueService, ProductService, Catalog, catalogTemplate, CategoryService, SettingsService) {
      $scope.categories = categories;
      $scope.selectedCategory = [];
      $scope.selectedCategory.category = $scope.categories[0];
      $scope.selectedCategory.favorites = false;
      $scope.products = products;
      $scope.openMenu = null;
      $scope.venue = venue != null ? venue : $rootScope.credentials.venue;
      $scope.merchant = merchant;
      $scope.venues = venues;
      $scope.productsForCategory = $scope.products;
      $scope.populateCatalog = function() {
        return Catalog.populate($scope.merchant, $scope.venue, catalogTemplate.categories, function() {
          return $scope.$emit("catalog:populated");
        });
      };
      $scope.canAddVenue = function() {
        return VenueService.canAddVenue();
      };
      $scope.switchVenue = function(venue) {
        return $scope.$broadcast('venue:switch', venue);
      };
      $scope.create = function() {
        return $location.path("/venues/" + $scope.venue.id + "/products/category/" + $scope.selectedCategory.category.id + "/add");
      };
      $scope.copy = function(product) {
        return $scope.$broadcast('product:create', product);
      };
      $scope.edit = function(product) {
        return $location.path("/venues/" + $scope.venue.id + "/products/edit/" + product.id);
      };
      $scope["delete"] = function(product) {
        $scope.$broadcast("delete:pending", product);
        return ProductService.remove(product).then(function() {
          $scope.products = _.reject($scope.products, function(it) {
            return it.id === product.id;
          });
          return $scope.productsForCategory = _.reject($scope.productsForCategory, function(it) {
            return it.id === product.id;
          });
        }, function() {
          console.error("could not delete", product);
          return $scope.$broadcast("delete:failed", product);
        });
      };
      $scope.removeFromFavorites = function(product) {
        product.favourite = false;
        return ProductService.save($rootScope.credentials.venue.id, product).then(function(response) {}, function(response) {
          console.error('update failed');
          return $scope.locked = false;
        });
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
      $scope.hasProducts = function() {
        if ($scope.products.length) {
          return true;
        } else {
          return false;
        }
      };
      $scope.hasCategories = function() {
        if (angular.isArray($scope.categories) && $scope.categories.length) {
          return true;
        } else {
          return false;
        }
      };
      $scope.canDeleteCategory = function() {
        return true;
      };
      $scope.deleteCategory = function() {
        var category;
        if ($scope.canDeleteCategory()) {
          category = $scope.selectedCategory.category;
          return CategoryService.remove(category).then(function(response) {
            $scope.categories = _.reject($scope.categories, function(it) {
              return it.id === category.id;
            });
            return $scope.selectedCategory.category = $scope.categories[0];
          });
        }
      };
      $scope.toggleMenu = function(product) {
        return $scope.openMenu = $scope.isMenuOpen(product) ? null : product;
      };
      $scope.closeMenus = function() {
        return $scope.openMenu = null;
      };
      $scope.isMenuOpen = function(product) {
        return $scope.openMenu === product;
      };
      $scope.confirmedDelete = function(product) {
        return $scope.productToDelete = product;
      };
      $scope.closeConfirm = function() {
        return delete $scope.productToDelete;
      };
      $scope.confirmYes = function() {
        $scope["delete"]($scope.productToDelete);
        return $scope.closeConfirm();
      };
      $scope.indexProperty = function() {
        var _ref;
        if ((_ref = $scope.selectedCategory) != null ? _ref.favorites : void 0) {
          return 'favouriteIndex';
        } else {
          return 'index';
        }
      };
      $scope.$on('catalog:populated', function(event) {
        return $route.reload();
      });
      $scope.$on('delete:requested', function(event, product) {
        return $scope["delete"](product);
      });
      $scope.$on('product:created', function(event, product) {
        $scope.products.push(product);
        return $scope.productsForCategory.push(product);
      });
      $scope.$on('product:updated', function(event, product) {
        var index, _i, _j, _ref, _ref1, _results;
        for (index = _i = 0, _ref = $scope.products.length; 0 <= _ref ? _i < _ref : _i > _ref; index = 0 <= _ref ? ++_i : --_i) {
          if ($scope.products[index].id === product.id) {
            $scope.products[index] = angular.copy(product);
          }
        }
        _results = [];
        for (index = _j = 0, _ref1 = $scope.productsForCategory.length; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; index = 0 <= _ref1 ? ++_j : --_j) {
          if ($scope.productsForCategory[index].id === product.id) {
            _results.push($scope.productsForCategory[index] = angular.copy(product));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      });
      $scope.sortableOptions = {
        update: function(e, ui) {
          var product;
          product = ui.item.scope().product;
          product.oldIndex = ui.item.scope().product.index;
          product.newIndex = ui.item.index();
          return $scope.$emit("products:sortupdate", product);
        }
      };
      $scope.$on('products:sortupdate', function(event, product) {
        return angular.forEach($scope.productsForCategory, function(value, index) {
          var changed, thisProduct;
          changed = false;
          thisProduct = value;
          if (thisProduct.id === product.id) {
            changed = true;
            thisProduct.index = product.newIndex;
          } else if (thisProduct.index >= product.newIndex) {
            changed = true;
            thisProduct.index = index + 1;
          }
          if (changed) {
            return ProductService.save($rootScope.credentials.venue.id, thisProduct).then(function(response) {});
          }
        });
      });
      $scope.$on('merchant:switch', function(event, venue) {
        return venue.getList("products").then(function(response) {
          return $scope.products = response;
        });
      });
      $scope.$on('venue:switch', function(event, venue) {
        $rootScope.credentials.venue = venue;
        return $route.reload();
      });
      return $scope.$watch('selectedCategory', function(newSelectedCategory) {
        var _ref;
        if ((newSelectedCategory != null ? newSelectedCategory.favorites : void 0)) {
          return VenueService.getVenueProducts(venue.id, {
            favourite: newSelectedCategory != null ? newSelectedCategory.favorites : void 0
          }).then(function(products) {
            $scope.productsForCategory = products;
            return $scope.productsForCategory = _.sortBy($scope.productsForCategory, $scope.indexProperty());
          });
        } else {
          if (angular.isDefined(newSelectedCategory != null ? (_ref = newSelectedCategory.category) != null ? _ref.id : void 0 : void 0)) {
            return VenueService.getVenueProductsByCategory(venue.id, newSelectedCategory != null ? newSelectedCategory.category.id : void 0).then(function(products) {
              $scope.productsForCategory = products;
              return $scope.productsForCategory = _.sortBy($scope.productsForCategory, $scope.indexProperty());
            });
          }
        }
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=products-controller.js.map
