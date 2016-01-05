# TODO: Write new tests for products-controller.spec
#'use strict'
#
#describe 'Controller: Products', ->
#
#  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'testFixtures'
#
#  Product = null
#  Category = null
#  $scope = null
#  fixtures = {}
#
#  beforeEach inject ($controller, $rootScope, _Product_, _Category_, flatWhite, croissant, bagel, baconRoll, categories) ->
#    Product = _Product_
#    Category = _Category_
#    fixtures.flatWhite = new Product(flatWhite)
#    fixtures.croissant = new Product(croissant)
#    fixtures.bagel = new Product(bagel)
#    fixtures.baconRoll = new Product(baconRoll)
#    fixtures.categories = categories.map (it) -> new Category(it)
#
#    $scope = $rootScope.$new()
#    $controller 'ProductsCtrl',
#      $scope: $scope
#      products: [fixtures.flatWhite, fixtures.croissant, fixtures.bagel, fixtures.baconRoll]
#      categories: fixtures.categories
#
#  describe 'displaying the product list', ->
#    it 'should attach whatever products it is given to the scope', ->
#      expect($scope.products.length).toBe 4
#      expect(_.pluck $scope.products, 'title').toEqual [fixtures.flatWhite.title, fixtures.croissant.title, fixtures.bagel.title, fixtures.baconRoll.title]
#
#  describe 'changing the active category', ->
#
#    describe 'to another category', ->
#
#      category = null
#
#      beforeEach ->
#        category = _.find fixtures.categories, (it) -> it.title is 'breakfast'
#        $scope.$apply ->
#          $scope.selectedCategory =
#            favorites: false
#            category: category
#
#      it 'should select the products from that category', ->
#        expect(_.every $scope.productsForCategory, (it) -> it.category is category.id).toBe true
#
#    describe 'to favorites', ->
#
#      beforeEach ->
#        $scope.$apply ->
#          $scope.selectedCategory =
#            favorites: true
#            category: null
#
#      it 'should select the favorite products', ->
#        expect(_.every $scope.productsForCategory, (it) -> it.favourite).toBe true
#
#  describe 'sorting the product list in a category', ->
#
#    coffeeCategory = null
#    breakfastCategory = null
#
#    beforeEach ->
#      coffeeCategory = _.find fixtures.categories, (it) -> it.title is 'coffee'
#      breakfastCategory = _.find fixtures.categories, (it) -> it.title is 'breakfast'
#
#      $scope.$apply ->
#        $scope.selectedCategory =
#          favorites: false
#          category: breakfastCategory
#
#      for product in $scope.productsForCategory
#        spyOn(product, '$update').andCallFake (callback) -> callback()
#
#      $scope.productsForCategory.reverse()
#      $scope.$broadcast 'productsForCategory:sortupdate'
#
#    it 'should update the indices of the products in the active category', ->
#      expect(_.pluck $scope.productsForCategory, 'index').toEqual [0, 1, 2]
#
#    it 'should save the new indices', ->
#      expect(product.$update).toHaveBeenCalled() for product in $scope.productsForCategory
#
#    describe 'then changing to another category and back', ->
#
#      beforeEach ->
#        $scope.$apply ->
#          $scope.selectedCategory =
#            favorites: false
#            category: coffeeCategory
#        $scope.$apply ->
#          $scope.selectedCategory =
#            favorites: false
#            category: breakfastCategory
#
#      it 'should keep the products in order', ->
#        expect(_.pluck $scope.productsForCategory, 'index').toEqual [0, 1, 2]
#
#  describe 'sorting the favorites', ->
#
#    beforeEach ->
#      $scope.$apply ->
#        $scope.selectedCategory =
#          favorites: true
#          category: null
#
#      for product in $scope.productsForCategory
#        spyOn(product, '$update').andCallFake (callback) -> callback()
#
#      $scope.productsForCategory.reverse()
#      $scope.$broadcast 'productsForCategory:sortupdate'
#
#    it 'should update the indices of the products in the active category', ->
#      expect(_.pluck $scope.productsForCategory, 'favouriteIndex').toEqual [0, 1]
#
#    it 'should save the new indices', ->
#      expect(product.$update).toHaveBeenCalled() for product in $scope.productsForCategory
#
#    describe 'then changing to another category and back', ->
#
#      beforeEach ->
#        coffeeCategory = _.find fixtures.categories, (it) -> it.title is 'coffee'
#        $scope.$apply ->
#          $scope.selectedCategory =
#            favorites: false
#            category: coffeeCategory
#        $scope.$apply ->
#          $scope.selectedCategory =
#            favorites: true
#            category: null
#
#      it 'should keep the products in order', ->
#        expect(_.pluck $scope.productsForCategory, 'favouriteIndex').toEqual [0, 1]
#
#  describe 'creating a new product', ->
#
#    beforeEach ->
#      $scope.$apply ->
#        $scope.selectedCategory =
#          favorites: false
#          category: _.find fixtures.categories, (it) -> it.id is fixtures.flatWhite.category
#
#      spyOn $scope, '$broadcast'
#
#      $scope.create()
#
#    it 'should trigger an event', ->
#      expect($scope.$broadcast).toHaveBeenCalled()
#      expect($scope.$broadcast.mostRecentCall.args[0]).toBe 'product:create'
#
#    it 'should specify the currently selected category', ->
#      categories = $scope.$broadcast.mostRecentCall.args[1].categories
#      expect(categories.length).toBe 1
#      expect(categories[0]).toEqual $scope.selectedCategory.category
#
#  describe 'removing a product from favorites', ->
#
#    $httpBackend = null
#
#    beforeEach inject (_$httpBackend_, Auth, Config) ->
#      $httpBackend = _$httpBackend_
#
#      spyOn(Auth, 'getMerchant').andCallFake -> id: 'the-merchant-id'
#      spyOn(Auth, 'getVenue').andCallFake -> id: 'the-venue-id'
#
#      $httpBackend.expectPUT "#{Config.baseURL()}/api/merchants/the-merchant-id/venues/the-venue-id/products/#{fixtures.flatWhite.id}", (data) ->
#        JSON.parse(data).favourite is false
#      .respond 200
#
#      $scope.removeFromFavorites fixtures.flatWhite
#      $httpBackend.flush()
#
#    afterEach ->
#      $httpBackend.verifyNoOutstandingExpectation()
#      $httpBackend.verifyNoOutstandingRequest()
#
#    it 'unsets the favorite flag', ->
#      expect(fixtures.flatWhite.favourite).toBe false
#
#  describe 'deleting a product', ->
#    beforeEach ->
#      spyOn $scope, '$broadcast'
#
#    describe 'making the delete request', ->
#      beforeEach ->
#        spyOn fixtures.croissant, '$delete'
#
#        $scope.delete fixtures.croissant
#
#      it 'should send a DELETE request to the API', ->
#        expect(fixtures.croissant.$delete).toHaveBeenCalled()
#
#      it 'should broadcast an event', ->
#        expect($scope.$broadcast).toHaveBeenCalledWith 'delete:pending', fixtures.croissant
#
#    describe 'when the delete is successful', ->
#      beforeEach ->
#        spyOn(fixtures.croissant, '$delete').andCallFake (successCallback, errorCallback) -> successCallback @
#
#        console.log 'deleting', fixtures.croissant.title, 'from', _.pluck $scope.products, 'title'
#        $scope.delete fixtures.croissant
#
#      it 'should broadcast an event', ->
#        expect($scope.$broadcast).toHaveBeenCalledWith 'delete:succeeded', fixtures.croissant
#
#      it 'should remove the deleted product from the scope if the deletion succeeds', ->
#        expect($scope.products.length).toBe 3
#        console.log _.pluck $scope.products, 'title'
#        expect($scope.products.some (it) -> it.title == fixtures.croissant.title).toBeFalsy()
#        expect($scope.productsForCategory.some (it) -> it.title == fixtures.croissant.title).toBeFalsy()
#
#    describe 'when the delete fails', ->
#      beforeEach ->
#        spyOn(fixtures.croissant, '$delete').andCallFake (successCallback, errorCallback) -> errorCallback @
#
#        $scope.delete fixtures.croissant
#
#      it 'should broadcast an event', ->
#        expect($scope.$broadcast).toHaveBeenCalledWith 'delete:failed', fixtures.croissant
#
#      it 'should not remove the deleted product from the scope if the deletion fails', ->
#        expect($scope.products.length).toBe 4
#
#  describe 'responding to a delete request from a child scope', ->
#    childScope = null
#
#    beforeEach ->
#      spyOn $scope, 'delete'
#
#      childScope = $scope.$new()
#      childScope.$emit 'delete:requested', fixtures.croissant
#
#    it 'should delegate to its own delete method', ->
#      expect($scope.delete).toHaveBeenCalledWith fixtures.croissant
#
#  describe 'responding to an update notification from a child scope', ->
#    childScope = null
#    updatedProduct = null
#
#    beforeEach ->
#      updatedProduct = angular.copy fixtures.croissant
#      updatedProduct.title = 'UPDATED TITLE'
#
#      childScope = $scope.$new()
#      childScope.$emit 'product:updated', updatedProduct
#
#    it 'should splice the updated product into the list in scope', ->
#      matchingProducts = $scope.products.filter (it) -> it.id is fixtures.croissant.id
#      expect(matchingProducts.length).toBe 1
#      expect(matchingProducts[0].title).toBe updatedProduct.title
#
#  describe 'responding to a created notification from a child scope', ->
#    childScope = null
#    createdProduct = null
#
#    beforeEach ->
#      createdProduct = new Product()
#      createdProduct.title = 'Eggy Banjo'
#
#      childScope = $scope.$new()
#      childScope.$emit 'product:created', createdProduct
#
#    it 'should append the new product to the list in scope', ->
#      expect($scope.products.length).toBe 5
#      matchingProducts = $scope.products.filter (it) -> it.title is createdProduct.title
#      expect(matchingProducts.length).toBe 1
#
#  describe 'deleting a category', ->
#
#    $httpBackend = null
#
#    beforeEach inject (_$httpBackend_) ->
#      $httpBackend = _$httpBackend_
#
#    afterEach ->
#      $httpBackend.verifyNoOutstandingExpectation()
#      $httpBackend.verifyNoOutstandingRequest()
#
#    describe 'when no category is selected', ->
#
#      beforeEach ->
#        delete $scope.selectedCategory
#
#      it 'should not allow deletion', ->
#        expect($scope.canDeleteCategory()).toBe false
#
#      it 'should do nothing if the deleteCategory function is called', ->
#        $scope.deleteCategory()
#
#    describe 'when favorites is selected', ->
#
#      beforeEach ->
#        $scope.$apply ->
#          $scope.selectedCategory =
#            favorites: true
#            category: null
#
#      it 'should not allow deletion', ->
#        expect($scope.canDeleteCategory()).toBe false
#
#      it 'should do nothing if the deleteCategory function is called', ->
#        $scope.deleteCategory()
#
#    describe 'when a category that has products is selected', ->
#
#      beforeEach ->
#        $scope.$apply ->
#          $scope.selectedCategory =
#            favorites: false
#            category: _.find fixtures.categories, (it) -> it.id is fixtures.flatWhite.category
#
#      it 'should not allow deletion', ->
#        expect($scope.canDeleteCategory()).toBe false
#
#      it 'should do nothing if the delete function is called', ->
#        $scope.deleteCategory()
#
#    describe 'when a category with no products is selected', ->
#
#      emptyCategory = null
#
#      beforeEach ->
#        emptyCategory = new Category
#          id: 'empty-category-id'
#          title: 'Empty'
#
#        $scope.categories.push emptyCategory
#
#        $scope.$apply ->
#          $scope.selectedCategory =
#            favorites: false
#            category: emptyCategory
#
#      it 'should allow deletion', ->
#        expect($scope.canDeleteCategory()).toBe true
#
#      describe 'when the deleteCategory function is called', ->
#
#        beforeEach inject (Config, Auth) ->
#          spyOn(Auth, 'getMerchant').andCallFake -> id: 'the-merchant-id'
#          spyOn(Auth, 'getVenue').andCallFake -> id: 'the-venue-id'
#
#          $httpBackend.expectDELETE("#{Config.baseURL()}/api/merchants/the-merchant-id/venues/the-venue-id/categories/#{emptyCategory.id}").respond 200
#
#          $scope.deleteCategory()
#
#        it 'should remove the category from the scope', ->
#          numCategories = $scope.categories.length
#
#          $httpBackend.flush()
#
#          expect($scope.categories.length).toBe numCategories - 1
#
#        it 'should select the first remaining category', ->
#          $httpBackend.flush()
#
#          expect($scope.selectedCategory.category.id).toBe $scope.categories[0].id
