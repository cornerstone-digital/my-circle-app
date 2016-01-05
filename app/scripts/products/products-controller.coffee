'use strict'

angular.module('smartRegisterApp')
.controller 'ProductsCtrl', ['$route','$scope','$rootScope','$location', '$timeout', 'venue','venues','merchant','categories','products','sections', 'VenueService','ProductService','Catalog','catalogTemplate','CategoryService', 'SettingsService', ($route, $scope, $rootScope, $location, $timeout, venue, venues, merchant, categories, products, sections, VenueService, ProductService, Catalog, catalogTemplate, CategoryService, SettingsService) ->

  $scope.categories = categories

  $scope.selectedCategory = []
  $scope.selectedCategory.category = $scope.categories[0]
  $scope.selectedCategory.favorites = false

  $scope.products = products

  $scope.openMenu = null
  $scope.venue = venue ? $rootScope.credentials.venue
  $scope.merchant = merchant

  $scope.venues = venues
  $scope.productsForCategory = $scope.products

  $scope.populateCatalog = ->
    Catalog.populate($scope.merchant, $scope.venue, catalogTemplate.categories ,->
      $scope.$emit "catalog:populated"
    )

  $scope.canAddVenue = ->
    VenueService.canAddVenue()

  $scope.switchVenue = (venue) ->
    $scope.$broadcast 'venue:switch', venue

  $scope.create = ->
    $location.path "/venues/#{$scope.venue.id}/products/category/#{$scope.selectedCategory.category.id}/add"

  $scope.copy = (product) ->
    $scope.$broadcast 'product:create', product

  $scope.edit = (product) ->
    $location.path "/venues/#{$scope.venue.id}/products/edit/#{product.id}"

  $scope.delete = (product) ->
    $scope.$broadcast "delete:pending", product

    ProductService.remove(product).then(->
      $scope.products = _.reject $scope.products, (it) -> it.id is product.id
      $scope.productsForCategory  = _.reject $scope.productsForCategory, (it) -> it.id is product.id
    , ->
      console.error "could not delete", product
      $scope.$broadcast "delete:failed", product
    )

  $scope.removeFromFavorites = (product) ->
    product.favourite = false
    ProductService.save($rootScope.credentials.venue.id, product).then((response) ->
    (response) ->
      console.error 'update failed'
      $scope.locked = false
    )

  $scope.hasModuleEnabled = (moduleName) ->
    SettingsService.hasModuleEnabled moduleName

  $scope.hasMultipleVenues = ->
    if($scope.venues.length > 1)
      return true
    else
      return false

  $scope.hasProducts = ->
    if($scope.products.length)
      return true
    else
      return false

  $scope.hasCategories = ->
    if(angular.isArray($scope.categories) && $scope.categories.length)
      return true
    else
      return false

  $scope.canDeleteCategory = ->
    return true

  $scope.deleteCategory = ->
    if $scope.canDeleteCategory()
      category = $scope.selectedCategory.category
      CategoryService.remove(category).then((response)->
        $scope.categories = _.reject $scope.categories, (it) -> it.id is category.id
        $scope.selectedCategory.category = $scope.categories[0]
      )

  $scope.toggleMenu = (product) ->
    $scope.openMenu = if $scope.isMenuOpen(product) then null else product

  $scope.closeMenus = ->
    $scope.openMenu = null

  $scope.isMenuOpen = (product) ->
    $scope.openMenu is product

  $scope.confirmedDelete = (product) ->
    $scope.productToDelete = product

  $scope.closeConfirm = ->
    delete $scope.productToDelete

  $scope.confirmYes = ->
    $scope.delete $scope.productToDelete
    $scope.closeConfirm()

  $scope.indexProperty = ->
    if $scope.selectedCategory?.favorites then 'favouriteIndex' else 'index'

  $scope.$on 'catalog:populated', (event) ->
    $route.reload()

  $scope.$on 'delete:requested', (event, product) ->
    $scope.delete product

  $scope.$on 'product:created', (event, product) ->
    $scope.products.push product
    $scope.productsForCategory.push product

  $scope.$on 'product:updated', (event, product) ->
    for index in [0...$scope.products.length]
      $scope.products[index] = angular.copy(product) if $scope.products[index].id is product.id
    for index in [0...$scope.productsForCategory.length]
      $scope.productsForCategory[index] = angular.copy(product) if $scope.productsForCategory[index].id is product.id

  $scope.sortableOptions =
    update: (e, ui) ->
      product = ui.item.scope().product
      product.oldIndex = ui.item.scope().product.index
      product.newIndex = ui.item.index()

      $scope.$emit "products:sortupdate", product

  $scope.$on 'products:sortupdate', (event, product)->

    angular.forEach $scope.productsForCategory, (value, index) ->
      changed = false
      thisProduct = value

      if (thisProduct.id == product.id)
        changed = true
        thisProduct.index = product.newIndex
      else if thisProduct.index >= product.newIndex
        changed = true
        thisProduct.index = index + 1

      if changed
        ProductService.save($rootScope.credentials.venue.id, thisProduct).then((response) ->
        )

  $scope.$on 'merchant:switch', (event, venue) ->
    venue.getList("products").then((response) ->
      $scope.products = response
    )

  $scope.$on 'venue:switch', (event, venue) ->
      $rootScope.credentials.venue = venue
      $route.reload()

  $scope.$watch 'selectedCategory', (newSelectedCategory) ->
    if(newSelectedCategory?.favorites)
      VenueService.getVenueProducts(venue.id, {favourite: newSelectedCategory?.favorites}).then((products) ->
        $scope.productsForCategory = products

        $scope.productsForCategory = _.sortBy $scope.productsForCategory, $scope.indexProperty()

      )
    else
      if angular.isDefined(newSelectedCategory?.category?.id)
        VenueService.getVenueProductsByCategory(venue.id, newSelectedCategory?.category.id).then((products) ->
          $scope.productsForCategory = products

          $scope.productsForCategory = _.sortBy $scope.productsForCategory, $scope.indexProperty()

        )



]
