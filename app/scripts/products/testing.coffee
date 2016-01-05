# CURRENT
updateProductSorting = (products) ->
  angular.forEach products, (value,index) ->
    listItem = angular.element(value)
    product = _.find $scope.productsForCategory, (it) -> it.id is angular.fromJson(listItem.attr("data-product")).id

    if product?
      if(product.favourite)
        product.favouriteIndex = listItem.index()
      else
        product.index = listItem.index()

      ProductService.save($rootScope.credentials.venue.id, product)



# PROPOSED
updateProductSorting = (products) ->
  productArr = []

  angular.forEach products, (value,index) ->
    listItem = angular.element(value)
    product = _.find $scope.productsForCategory, (it) -> it.id is angular.fromJson(listItem.attr("data-product")).id

    if product?
      if(product.favourite)
        product.favouriteIndex = listItem.index()
      else
        product.index = listItem.index()

      productArr.push(product)

  ProductService.batchSave($rootScope.credentials.venue.id, productArr)



