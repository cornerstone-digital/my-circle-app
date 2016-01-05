'use strict'

angular.module('smartRegisterApp')
.factory 'Catalog', ['catalogTemplate', '$http', '$timeout', 'Config','VenueService', (catalogTemplate, $http, $timeout, Config, VenueService) ->
  populate: (merchant, venue, categories, completeCallback) ->
    createNextProduct = (categoryId, products, completeCallback) ->
      product = products.pop()
      product.category = categoryId
      $http.post("api://api/merchants/#{merchant.id}/venues/#{venue.id}/products", product).success (response) ->
        if products.length
          createNextProduct categoryId, products, completeCallback
        else
          completeCallback()

    createNextCategory = (categories, completeCallback) ->
      category = categories.pop()
      products = category.products
      delete category.products

      $http.post("api://api/merchants/#{merchant.id}/venues/#{venue.id}/categories", category).success (response) ->
        createNextProduct response.id, products, ->
          if categories.length
            createNextCategory categories, completeCallback
          else
            completeCallback()


    createNextCategory categories, completeCallback
]
