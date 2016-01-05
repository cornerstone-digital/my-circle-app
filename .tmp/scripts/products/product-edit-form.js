(function() {
  'use strict';
  angular.module('smartRegisterApp').directive('productEditForm', [
    '$filter', function($filter) {
      return {
        templateUrl: 'views/partials/products/product-edit-form.html',
        replace: true,
        restrict: 'E',
        controller: [
          '$scope', '$rootScope', '$element', '$attrs', 'ProductService', '$location', function($scope, $rootScope, $element, $attrs, ProductService, $location) {
            $scope.$on('product:create', function(event, productToCopy) {
              var nonClonedProperties, product;
              product = ProductService["new"]($rootScope.credentials.venue.id);
              if (productToCopy != null) {
                angular.copy(productToCopy, product);
                delete product.id;
                product.title = '';
                nonClonedProperties = ['id', 'version', 'created'];
                _.forEach(product.images, function(image) {
                  var prop, _i, _len, _results;
                  _results = [];
                  for (_i = 0, _len = nonClonedProperties.length; _i < _len; _i++) {
                    prop = nonClonedProperties[_i];
                    _results.push(delete image[prop]);
                  }
                  return _results;
                });
                _.forEach(product.modifiers, function(modifier) {
                  var prop, _i, _len;
                  for (_i = 0, _len = nonClonedProperties.length; _i < _len; _i++) {
                    prop = nonClonedProperties[_i];
                    delete modifier[prop];
                  }
                  return _.forEach(modifier.variants, function(variant) {
                    var _j, _len1, _results;
                    _results = [];
                    for (_j = 0, _len1 = nonClonedProperties.length; _j < _len1; _j++) {
                      prop = nonClonedProperties[_j];
                      _results.push(delete variant[prop]);
                    }
                    return _results;
                  });
                });
              }
              if (product.price == null) {
                product.price = 0;
              }
              if (product.tax == null) {
                product.tax = 0;
              }
              if (product.favourite == null) {
                product.favourite = false;
              }
              if (product.modifiers == null) {
                product.modifiers = [];
              }
              if (product.images == null) {
                product.images = [];
              }
              $scope.product = product;
              $scope.selectedModifier = $scope.product.modifiers.length > 0 ? $scope.product.modifiers[0] : null;
              return $element.find('.nav-tabs a:first').tab('show');
            });
            $scope.$on('product:edit', function(event, product) {
              return $location.path('/products/edit/#{product.id}');
            });
            $scope.cancel = function() {
              delete $scope.product;
              delete $scope.selectedModifier;
              $scope.productForm.$setPristine();
              return $scope.$broadcast('product:closed');
            };
            $scope.$on('product:created', $scope.cancel);
            $scope.$on('product:updated', $scope.cancel);
            $scope.save = function(form) {
              if (form.$valid) {
                return $scope.locked = true;
              }
            };

            /*
            called when a modifier is selected – this will cause the modifier section of the form
            to display the selected modifier's details
             */
            $scope.selectModifier = function(modifier) {
              return $scope.selectedModifier = modifier;
            };
            $scope.addModifier = function() {
              var newModifier;
              newModifier = {
                title: '',
                allowNone: false,
                allowMultiples: false,
                variants: []
              };
              $scope.selectedModifier = newModifier;
              return $scope.product.modifiers.push(newModifier);
            };
            $scope.deleteModifier = function() {
              var index, _ref;
              index = $scope.product.modifiers.indexOf($scope.selectedModifier);
              if (index >= 0) {
                $scope.product.modifiers.splice(index, 1);
                return $scope.selectedModifier = (_ref = $scope.product.modifiers[index]) != null ? _ref : $scope.product.modifiers[$scope.product.modifiers.length - 1];
              }
            };
            $scope.addVariant = function() {
              var newVariant;
              newVariant = {
                title: '',
                priceDelta: 0,
                isDefault: false
              };
              if ($scope.selectedModifier.variants == null) {
                $scope.selectedModifier.variants = [];
              }
              return $scope.selectedModifier.variants.push(newVariant);
            };
            $scope.deleteVariant = function(variant) {
              var index;
              index = $scope.selectedModifier.variants.indexOf(variant);
              if (index >= 0) {
                return $scope.selectedModifier.variants.splice(index, 1);
              }
            };
            return $scope.selectDefaultVariant = function(modifier, defaultVariant) {
              var variant, _i, _len, _ref, _results;
              _ref = modifier.variants;
              _results = [];
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                variant = _ref[_i];
                if (variant !== defaultVariant) {
                  _results.push(variant.isDefault = false);
                } else {
                  _results.push(void 0);
                }
              }
              return _results;
            };
          }
        ]
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=product-edit-form.js.map
