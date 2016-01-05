(function() {
  var updateProductSorting;

  updateProductSorting = function(products) {
    return angular.forEach(products, function(value, index) {
      var listItem, product;
      listItem = angular.element(value);
      product = _.find($scope.productsForCategory, function(it) {
        return it.id === angular.fromJson(listItem.attr("data-product")).id;
      });
      if (product != null) {
        if (product.favourite) {
          product.favouriteIndex = listItem.index();
        } else {
          product.index = listItem.index();
        }
        return ProductService.save($rootScope.credentials.venue.id, product);
      }
    });
  };

  updateProductSorting = function(products) {
    var productArr;
    productArr = [];
    angular.forEach(products, function(value, index) {
      var listItem, product;
      listItem = angular.element(value);
      product = _.find($scope.productsForCategory, function(it) {
        return it.id === angular.fromJson(listItem.attr("data-product")).id;
      });
      if (product != null) {
        if (product.favourite) {
          product.favouriteIndex = listItem.index();
        } else {
          product.index = listItem.index();
        }
        return productArr.push(product);
      }
    });
    return ProductService.batchSave($rootScope.credentials.venue.id, productArr);
  };

}).call(this);

//# sourceMappingURL=testing.js.map
