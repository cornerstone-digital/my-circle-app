'use strict'

angular.module('smartRegisterApp')
.controller 'ProductsCtrl', ['$route','$scope','$rootScope','$location', '$timeout', 'venue','venues','merchant','categories','products','sections', 'VenueService','ProductService','Catalog','catalogTemplate','CategoryService', 'SettingsService', 'MessagingService', ($route, $scope, $rootScope, $location, $timeout, venue, venues, merchant, categories, products, sections, VenueService, ProductService, Catalog, catalogTemplate, CategoryService, SettingsService, MessagingService) ->
  $scope.categories = categories
  $scope.products = products
  $scope.venues = venues
  $scope.sections = sections
  $scope.venue = venue ? $rootScope.credentials.venue
  $scope.merchant = merchant
  $scope.productsSorted = false
  $scope.lockedMode = false
  $scope.lockedModeText = 'Unlocked'
  $scope.lockedClass = ''

  if $route.current.params.categoryId? or $scope.products.length
    categoryId = $route.current.params.categoryId ? $scope.products[0].category

  if categoryId?
    $scope.category = _.find $scope.categories, (it) -> it.id is Number(categoryId)

    $scope.selectedCategory = []
    $scope.selectedCategory.category = $scope.category
    $scope.selectedCategory.favorites = false

  $scope.openMenu = null

  $scope.$on 'products:batchsave', (evenut, productArr) ->
    if productArr.length
      ProductService.batchSave($scope.venue.id, productArr)

  $scope.$on 'products:persist', (event, products) ->
    if $scope.productsSorted
      updateProductSorting(products)

  $scope.redirectToCategory = (venueId, categoryId) ->
    $location.path "/venues/#{venueId}/products/category/#{categoryId}"

  if  $scope.selectedCategory?
    $scope.redirectToCategory($scope.venue.id, $scope.selectedCategory.category.id)

  $scope.toggleLockMode = ->
    button = $('button.lockToggle')
    listItems = $('#categoryList, #productList').find('li')

    if $scope.lockedMode
      $scope.lockedMode = false
      $scope.lockedModeText = 'Unlocked'
      $scope.lockedClass = ''
      button.removeClass('toggle-inactive-icon').addClass('toggle-active-icon')
      listItems.removeClass('disabled')
    else
      $scope.lockedMode = true
      $scope.lockedModeText = 'Locked'
      $scope.lockedClass = 'disabled'
      button.removeClass('toggle-active-icon').addClass('toggle-inactive-icon')
      listItems.addClass('disabled')

      if $scope.productsSorted
        products = $('#productList').find('li')
        $scope.$broadcast 'products:persist', products

    return true

  $timeout ->
    $('#categoryList').kendoSortable
      placeholder: (element) ->
        return element.clone().css("opacity", 0.3)
      disabled: '.disabled'
      hint: (element) ->
        draggedElem = element.clone().removeClass("active").addClass("hint").removeAttr("data-ng-repeat")
        hintElem = angular.element('<div class="row"><div class="container"><div class="col-md-3"></div></div></div>')
        hintElem.find(".col-md-3").append(draggedElem)
        hintElem.find("a").css("border-style": 'solid')

        return hintElem
      change: (e) ->
        updateCategorySorting()

    $('#productList').kendoSortable
      filter: ">li.product-tile"
      cursor: "move"
      disabled: '.disabled'
      placeholder: (element) ->
        if(!element.hasClass('disabled'))
          placeholder = element.clone().css("opacity", 0.3)
          $('#productList').append(placeholder)
          return placeholder
      hint: (element) ->
        return element.clone().removeClass("k-state-selected")
      change: (e) ->
        $scope.productsSorted = true

        $scope.toggleSaveButton()

  , 500

  updateProductSorting = (products) ->
    productArr = []

    angular.forEach products, (value,index) ->
      listItem = angular.element(value)
      product = _.find $scope.productsForCategory, (it) -> it.id is angular.fromJson(listItem.attr("data-product")).id

      if product?
        delete product.version
        delete product.created

        propertiesToDelete = ['version', 'created']

        _.forEach product.images, (image) ->
          delete image[prop] for prop in propertiesToDelete
        _.forEach product.modifiers, (modifier) ->
          delete modifier[prop] for prop in propertiesToDelete
          _.forEach modifier.variants, (variant) ->
            delete variant[prop] for prop in propertiesToDelete

        if(product.favourite)
          product.favouriteIndex = listItem.index()
        else
          product.index = listItem.index()

        productArr.push product.plain()

    $timeout ->
      $scope.productsSorted = false
      $scope.$broadcast 'products:batchsave', productArr

    , 300

  updateCategorySorting = ->
    categories = $('#categoryList').find('li')

    angular.forEach categories, (value,index) ->
      listItem = angular.element(value)
      category = _.find $scope.categories, (it) -> it.id is angular.fromJson(listItem.attr("data-category")).id

      if category?
        category.index = listItem.index()

        CategoryService.save($rootScope.credentials.venue.id, category)


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
    $location.path "/venues/#{$scope.venue.id}/products/duplicate/#{product.id}"

  $scope.edit = (product) ->
    $location.path "/venues/#{$scope.venue.id}/products/edit/#{product.id}"

  $scope.selectCategory = (category) ->
    $location.path "/venues/#{$scope.venue.id}/products/category/#{category.id}"

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

  $scope.toggleMenu = ($event, product) ->
    $scope.openMenu = if $scope.isMenuOpen(product) then null else product
    $event.stopPropagation()

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

  $scope.$on 'merchant:switch', (event, venue) ->
    venue.getList("products").then((response) ->
      $scope.products = response
    )

  $scope.$on 'venue:switch', (event, venue) ->
    $rootScope.credentials.venue = venue
    $route.reload()

  $scope.$watch 'selectedCategory', (newSelectedCategory) ->
    if $scope.productsSorted
      products = $('#productList').find('li')
      $scope.$broadcast 'products:persist', products

    if(newSelectedCategory?.favorites)
      VenueService.getVenueProducts(venue.id, {favourite: newSelectedCategory?.favorites}).then((products) ->
        $scope.productsForCategory = _(products).chain()
          .sortBy(['favouriteIndex','title'])
          .value()
      )
    else
      if angular.isDefined(newSelectedCategory?.category?.id)
        VenueService.getVenueProductsByCategory(venue.id, newSelectedCategory?.category.id).then((products) ->
          $scope.productsForCategory = _(products).chain()
            .sortBy(['index','title'])
            .value()
        )

  $scope.save = ->
    products = $('#productList').find('li')
    $scope.$broadcast 'products:persist', products

    $timeout ->
      $scope.toggleSaveButton()
    , 500

    return

  $scope.toggleSaveButton = ->
    btn = $('.product-save-btn')

    if $scope.productsSorted
      btn.removeAttr("disabled")
    else
      btn.attr("disabled", "disabled")

  $scope.$on('$locationChangeStart', ( event, next, current) ->

    if $scope.productsSorted
      event.preventDefault()

      answer = confirm("Save your changes before leaving the page?")

      if answer
        products = $('#productList').find('li')
        $scope.$broadcast 'products:persist', products
      else
        $scope.productsSorted = false

      $timeout ->
        location.href = $location.url(next).hash()
        location.reload()
      , 500

  )
]
