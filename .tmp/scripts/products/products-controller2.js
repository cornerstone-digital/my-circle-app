(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('ProductsCtrl', [
    '$route', '$scope', '$rootScope', '$location', '$timeout', 'venue', 'venues', 'merchant', 'categories', 'products', 'sections', 'VenueService', 'ProductService', 'Catalog', 'catalogTemplate', 'CategoryService', 'SettingsService', 'MessagingService', function($route, $scope, $rootScope, $location, $timeout, venue, venues, merchant, categories, products, sections, VenueService, ProductService, Catalog, catalogTemplate, CategoryService, SettingsService, MessagingService) {
      var categoryId, updateCategorySorting, updateProductSorting, _ref;
      $scope.categories = categories;
      $scope.products = products;
      $scope.venues = venues;
      $scope.sections = sections;
      $scope.venue = venue != null ? venue : $rootScope.credentials.venue;
      $scope.merchant = merchant;
      $scope.productsSorted = false;
      $scope.lockedMode = false;
      $scope.lockedModeText = 'Unlocked';
      $scope.lockedClass = '';
      if (($route.current.params.categoryId != null) || $scope.products.length) {
        categoryId = (_ref = $route.current.params.categoryId) != null ? _ref : $scope.products[0].category;
      }
      if (categoryId != null) {
        $scope.category = _.find($scope.categories, function(it) {
          return it.id === Number(categoryId);
        });
        $scope.selectedCategory = [];
        $scope.selectedCategory.category = $scope.category;
        $scope.selectedCategory.favorites = false;
      }
      $scope.openMenu = null;
      $scope.$on('products:batchsave', function(evenut, productArr) {
        if (productArr.length) {
          return ProductService.batchSave($scope.venue.id, productArr);
        }
      });
      $scope.$on('products:persist', function(event, products) {
        if ($scope.productsSorted) {
          return updateProductSorting(products);
        }
      });
      $scope.redirectToCategory = function(venueId, categoryId) {
        return $location.path("/venues/" + venueId + "/products/category/" + categoryId);
      };
      if ($scope.selectedCategory != null) {
        $scope.redirectToCategory($scope.venue.id, $scope.selectedCategory.category.id);
      }
      $scope.toggleLockMode = function() {
        var button, listItems;
        button = $('button.lockToggle');
        listItems = $('#categoryList, #productList').find('li');
        if ($scope.lockedMode) {
          $scope.lockedMode = false;
          $scope.lockedModeText = 'Unlocked';
          $scope.lockedClass = '';
          button.removeClass('toggle-inactive-icon').addClass('toggle-active-icon');
          listItems.removeClass('disabled');
        } else {
          $scope.lockedMode = true;
          $scope.lockedModeText = 'Locked';
          $scope.lockedClass = 'disabled';
          button.removeClass('toggle-active-icon').addClass('toggle-inactive-icon');
          listItems.addClass('disabled');
          if ($scope.productsSorted) {
            products = $('#productList').find('li');
            $scope.$broadcast('products:persist', products);
          }
        }
        return true;
      };
      $timeout(function() {
        $('#categoryList').kendoSortable({
          placeholder: function(element) {
            return element.clone().css("opacity", 0.3);
          },
          disabled: '.disabled',
          hint: function(element) {
            var draggedElem, hintElem;
            draggedElem = element.clone().removeClass("active").addClass("hint").removeAttr("data-ng-repeat");
            hintElem = angular.element('<div class="row"><div class="container"><div class="col-md-3"></div></div></div>');
            hintElem.find(".col-md-3").append(draggedElem);
            hintElem.find("a").css({
              "border-style": 'solid'
            });
            return hintElem;
          },
          change: function(e) {
            return updateCategorySorting();
          }
        });
        return $('#productList').kendoSortable({
          filter: ">li.product-tile",
          cursor: "move",
          disabled: '.disabled',
          placeholder: function(element) {
            var placeholder;
            if (!element.hasClass('disabled')) {
              placeholder = element.clone().css("opacity", 0.3);
              $('#productList').append(placeholder);
              return placeholder;
            }
          },
          hint: function(element) {
            return element.clone().removeClass("k-state-selected");
          },
          change: function(e) {
            $scope.productsSorted = true;
            return $scope.toggleSaveButton();
          }
        });
      }, 500);
      updateProductSorting = function(products) {
        var productArr;
        productArr = [];
        angular.forEach(products, function(value, index) {
          var listItem, product, propertiesToDelete;
          listItem = angular.element(value);
          product = _.find($scope.productsForCategory, function(it) {
            return it.id === angular.fromJson(listItem.attr("data-product")).id;
          });
          if (product != null) {
            delete product.version;
            delete product.created;
            propertiesToDelete = ['version', 'created'];
            _.forEach(product.images, function(image) {
              var prop, _i, _len, _results;
              _results = [];
              for (_i = 0, _len = propertiesToDelete.length; _i < _len; _i++) {
                prop = propertiesToDelete[_i];
                _results.push(delete image[prop]);
              }
              return _results;
            });
            _.forEach(product.modifiers, function(modifier) {
              var prop, _i, _len;
              for (_i = 0, _len = propertiesToDelete.length; _i < _len; _i++) {
                prop = propertiesToDelete[_i];
                delete modifier[prop];
              }
              return _.forEach(modifier.variants, function(variant) {
                var _j, _len1, _results;
                _results = [];
                for (_j = 0, _len1 = propertiesToDelete.length; _j < _len1; _j++) {
                  prop = propertiesToDelete[_j];
                  _results.push(delete variant[prop]);
                }
                return _results;
              });
            });
            if (product.favourite) {
              product.favouriteIndex = listItem.index();
            } else {
              product.index = listItem.index();
            }
            return productArr.push(product.plain());
          }
        });
        return $timeout(function() {
          $scope.productsSorted = false;
          return $scope.$broadcast('products:batchsave', productArr);
        }, 300);
      };
      updateCategorySorting = function() {
        categories = $('#categoryList').find('li');
        return angular.forEach(categories, function(value, index) {
          var category, listItem;
          listItem = angular.element(value);
          category = _.find($scope.categories, function(it) {
            return it.id === angular.fromJson(listItem.attr("data-category")).id;
          });
          if (category != null) {
            category.index = listItem.index();
            return CategoryService.save($rootScope.credentials.venue.id, category);
          }
        });
      };
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
        return $location.path("/venues/" + $scope.venue.id + "/products/duplicate/" + product.id);
      };
      $scope.edit = function(product) {
        return $location.path("/venues/" + $scope.venue.id + "/products/edit/" + product.id);
      };
      $scope.selectCategory = function(category) {
        return $location.path("/venues/" + $scope.venue.id + "/products/category/" + category.id);
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
      $scope.toggleMenu = function($event, product) {
        $scope.openMenu = $scope.isMenuOpen(product) ? null : product;
        return $event.stopPropagation();
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
        var _ref1;
        if ((_ref1 = $scope.selectedCategory) != null ? _ref1.favorites : void 0) {
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
        var index, _i, _j, _ref1, _ref2, _results;
        for (index = _i = 0, _ref1 = $scope.products.length; 0 <= _ref1 ? _i < _ref1 : _i > _ref1; index = 0 <= _ref1 ? ++_i : --_i) {
          if ($scope.products[index].id === product.id) {
            $scope.products[index] = angular.copy(product);
          }
        }
        _results = [];
        for (index = _j = 0, _ref2 = $scope.productsForCategory.length; 0 <= _ref2 ? _j < _ref2 : _j > _ref2; index = 0 <= _ref2 ? ++_j : --_j) {
          if ($scope.productsForCategory[index].id === product.id) {
            _results.push($scope.productsForCategory[index] = angular.copy(product));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
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
      $scope.$watch('selectedCategory', function(newSelectedCategory) {
        var _ref1;
        if ($scope.productsSorted) {
          products = $('#productList').find('li');
          $scope.$broadcast('products:persist', products);
        }
        if ((newSelectedCategory != null ? newSelectedCategory.favorites : void 0)) {
          return VenueService.getVenueProducts(venue.id, {
            favourite: newSelectedCategory != null ? newSelectedCategory.favorites : void 0
          }).then(function(products) {
            return $scope.productsForCategory = _(products).chain().sortBy(['favouriteIndex', 'title']).value();
          });
        } else {
          if (angular.isDefined(newSelectedCategory != null ? (_ref1 = newSelectedCategory.category) != null ? _ref1.id : void 0 : void 0)) {
            return VenueService.getVenueProductsByCategory(venue.id, newSelectedCategory != null ? newSelectedCategory.category.id : void 0).then(function(products) {
              return $scope.productsForCategory = _(products).chain().sortBy(['index', 'title']).value();
            });
          }
        }
      });
      $scope.save = function() {
        products = $('#productList').find('li');
        $scope.$broadcast('products:persist', products);
        $timeout(function() {
          return $scope.toggleSaveButton();
        }, 500);
      };
      $scope.toggleSaveButton = function() {
        var btn;
        btn = $('.product-save-btn');
        if ($scope.productsSorted) {
          return btn.removeAttr("disabled");
        } else {
          return btn.attr("disabled", "disabled");
        }
      };
      return $scope.$on('$locationChangeStart', function(event, next, current) {
        var answer;
        if ($scope.productsSorted) {
          event.preventDefault();
          answer = confirm("Save your changes before leaving the page?");
          if (answer) {
            products = $('#productList').find('li');
            $scope.$broadcast('products:persist', products);
          } else {
            $scope.productsSorted = false;
          }
          return $timeout(function() {
            location.href = $location.url(next).hash();
            return location.reload();
          }, 500);
        }
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=products-controller2.js.map
