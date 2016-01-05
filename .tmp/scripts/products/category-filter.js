(function() {
  'use strict';
  angular.module('smartRegisterApp').filter('category', [
    function() {
      return function(products, predicate) {
        if (predicate != null) {
          return products.filter(function(product) {
            var _ref;
            if (predicate.favorites) {
              return product.favourite;
            } else {
              return product.category === (predicate != null ? (_ref = predicate.category) != null ? _ref.id : void 0 : void 0);
            }
          });
        } else {
          return [];
        }
      };
    }
  ]).directive('categoryFilter', [
    function() {
      return {
        restrict: 'E',
        scope: {
          categories: '=',
          selected: '=',
          sections: '='
        },
        templateUrl: 'views/partials/products/category-filter.html',
        controller: [
          '$scope', '$rootScope', '$element', '$timeout', '$location', 'Colors', 'VenueService', 'CategoryService', 'ModalService', 'ProductService', function($scope, $rootScope, $element, $timeout, $location, Colors, VenueService, CategoryService, ModalService, ProductService) {
            $scope.categoryModal = angular.element($('#categoryModal'));
            $scope.sectionDropdown = angular.element($('#sectionNames'));
            $scope.renderModal = function() {
              var options;
              options = {
                scope: $scope,
                width: "600px",
                title: "Edit Category",
                actions: ["Pin", "Minimize", "Maximize", "Close"],
                apiEvents: {
                  close: $scope.cancel
                },
                templateUrl: 'views/partials/products/categoryModal.html'
              };
              ModalService.createWindow('categoryModal', options);
              VenueService.getVenueSections($rootScope.credentials.venue.id).then(function(response) {
                return $scope.sections = response;
              });
              return $timeout(function() {
                if (!$('#sectionNames').data("kendoMultiSelect")) {
                  $scope.sectionIds = _.map($scope.selected.category.sections, function(categorySection) {
                    return categorySection.id;
                  });
                  return $('#sectionNames').kendoMultiSelect({
                    animation: false,
                    open: function() {},
                    placeholder: "Select a section...",
                    dataTextField: "name",
                    dataValueField: "id",
                    maxSelectedItems: 4,
                    dataSource: {
                      data: $scope.sections
                    },
                    value: $scope.sectionIds,
                    change: function(event) {
                      return $scope.sectionIds = this.value();
                    }
                  });
                }
              }, 100);
            };
            $scope.palette = ['#b0cffe', '#2ca8c2', '#5481e5', '#913ccc', '#b179a3', '#df93ff', '#c93237', '#f05f74', '#f76d3c', '#fcb96b', '#e0be2f', '#948d61', '#168349', '#839097', '#bfbfbf', '#e5a760'];
            $scope.hasCategories = function() {
              if (angular.isArray($scope.categories) && $scope.categories.length) {
                return true;
              } else {
                return false;
              }
            };
            $scope.canDeleteCategory = function() {
              return !$scope.$parent.products.length;
            };
            $scope.deleteCategory = function() {
              var category;
              category = $scope.selected.category;
              if ($scope.canDeleteCategory()) {
                category = $scope.selected.category;
                return CategoryService.remove(category).then(function(response) {
                  $scope.categories = _.reject($scope.categories, function(it) {
                    return it.id === category.id;
                  });
                  return $scope.$parent.selectedCategory.category = $scope.categories[0];
                });
              }
            };
            $scope.selectCategory = function(category) {
              return $scope.$parent.selectCategory(category);
            };
            $scope.selectFavorites = function() {
              return $scope.selected = {
                category: null,
                favorites: true
              };
            };
            $scope.isSelected = function(category) {
              var _ref;
              return ((_ref = $scope.selected.category) != null ? _ref.id : void 0) === category.id;
            };
            $scope.isFavoritesSelected = function() {
              var _ref, _ref1;
              return (_ref = (_ref1 = $scope.selected) != null ? _ref1.favorites : void 0) != null ? _ref : false;
            };
            $scope.create = function() {
              $scope.category = {
                colour: $scope.palette[0]
              };
              return $timeout(function() {
                return $scope.renderModal();
              }, 200);
            };
            $scope.edit = function(category) {
              $scope.category = angular.copy(category);
              $scope.sectionIds = _.map($scope.category.sections, function(categorySection) {
                return categorySection.id;
              });
              return $timeout(function() {
                return $scope.renderModal();
              }, 200);
            };
            $scope.save = function(category) {
              var filteredSections;
              $scope.locked = true;
              filteredSections = [];
              angular.forEach($scope.sectionIds, function(value, index) {
                var section;
                section = _.filter($scope.sections, function(section) {
                  return section.id === value;
                });
                return filteredSections.push(section);
              });
              $scope.category.sections = _.flatten(filteredSections);
              if (category.id != null) {
                return CategoryService.save($rootScope.credentials.venue.id, category).then(function(response) {
                  var index, _i, _ref, _ref1;
                  for (index = _i = 0, _ref = $scope.categories.length; 0 <= _ref ? _i < _ref : _i > _ref; index = 0 <= _ref ? ++_i : --_i) {
                    if ($scope.categories[index].id === category.id) {
                      $scope.categories[index] = category;
                    }
                  }
                  if (((_ref1 = $scope.selected.category) != null ? _ref1.id : void 0) === category.id) {
                    $scope.selected.category = category;
                  }
                  $scope.$emit('category:updated', response);
                  $scope.selectCategory(category);
                  delete $scope.category;
                  delete $scope.locked;
                  return $('#categoryModal').data("kendoWindow").close();
                }, function(response) {
                  console.error("failed to update category '" + category.title + "'");
                  return delete $scope.locked;
                });
              } else {
                category.index = $scope.categories.length + 1;
                return CategoryService.save($rootScope.credentials.venue.id, category).then(function(response) {
                  $scope.$emit('category:created', response);
                  $scope.categories.push(response);
                  $scope.selectCategory(response);
                  delete $scope.category;
                  delete $scope.locked;
                  return $('#categoryModal').data("kendoWindow").close();
                }, function(response) {
                  console.error("failed to save category '" + category.title + "'");
                  return delete $scope.locked;
                });
              }
            };
            return $scope.cancel = function() {
              return delete $scope.category;
            };
          }
        ]
      };
    }
  ]).directive('productGrid', [
    '$timeout', function($timeout) {
      return {
        restrict: 'C',
        link: function($scope, $element) {
          return $scope.$watch('selectedCategory', function(value) {
            var height;
            height = $('.category-filter').height() - $element.prev().outerHeight() - parseInt($element.prev().css('margin-bottom'), 10);
            return $element.css({
              'min-height': "" + height + "px"
            });
          });
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=category-filter.js.map
