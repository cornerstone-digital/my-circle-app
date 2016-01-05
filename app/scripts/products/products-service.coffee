angular.module('smartRegisterApp')
.factory 'ProductService', ['$rootScope', 'ResourceNoPaging', 'SettingsService', 'Auth', ($rootScope, ResourceNoPaging, SettingsService, Auth) ->
  new: (venueId) ->
    product = ResourceNoPaging.one("merchants", $rootScope.credentials.merchant?.id).one("venues").one("venues", venueId).one("products")
    product.tax = 0.20
    product.altTax = 0.20

    product.modifiers = []


    return product

  getListByCategory: (venueId, categoryId, params) ->
    venueId = venueId ? $rootScope.credentials?.venue?.id
    params = params ? {}

    ResourceNoPaging.one("merchants", $rootScope.credentials?.merchant?.id).one("venues", venueId).one("categories", categoryId).getList("products")

  getById: (venueId, productId, params) ->
    venueId = venueId ? $rootScope.credentials?.venue?.id
    params = params ? {}

    ResourceNoPaging.one("merchants", $rootScope.credentials.merchant.id).one("venues", venueId).one("products", productId).get(params)

  save: (venueId, product) ->
    if(product.id)
      product.save()
    else
      ResourceNoPaging.one("merchants", $rootScope.credentials?.merchant?.id).one("venues", venueId).post("products", product)

  batchSave: (venueId, products) ->
    if products.length
      ResourceNoPaging.one("merchants", $rootScope.credentials?.merchant?.id).one("venues", venueId).one("products").customPUT(products)

  remove: (product) ->
    ResourceNoPaging.one("merchants", $rootScope.credentials?.merchant?.id).one("venues", $rootScope.credentials?.venue?.id).one("products", product.id).remove()
]
