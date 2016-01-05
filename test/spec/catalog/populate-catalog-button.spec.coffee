'use strict'

describe 'Directive: populateCatalogFor', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'testFixtures'

  $scope = null
  $element = null

  beforeEach inject ($rootScope, Merchant, Venue) ->
    $element = '<button populate-catalog-for="merchant">Click me</button>'

    $scope = $rootScope.$new()

    $scope.merchant = {
      name: 'The Electric Psychedelic Pussycat Swingers Club'
      venues: [
        new Venue
          name: 'The Electric Psychedelic Pussycat Swingers Club'
          products: []
      ]
    }

    $scope.products = $scope.merchant.venues[0].products

  describe 'when a merchant has no products in their catalog', ->

    beforeEach inject ($compile) ->
      $element = $compile($element) $scope

    it 'the button should be enabled', ->
      expect($element).not.toBeDisabled()

    describe 'clicking the button', ->

      Catalog = null

      beforeEach inject (_Catalog_) ->
        Catalog = _Catalog_
        spyOn Catalog, 'populate'

        $element.click()

      it 'should populate the catalog', ->
        expect(Catalog.populate).toHaveBeenCalled()
        expect(Catalog.populate.mostRecentCall.args[0]).toEqual $scope.merchant

  describe 'when a merchant has some products in their catalog', ->

    beforeEach inject ($compile, Product, flatWhite) ->
      $scope.merchant.venues[0].products.push new Product(flatWhite)

      $element = $compile($element) $scope

    it 'the button should be disabled', ->
      expect($element).toBeDisabled()

    describe 'clicking the button', ->

      Catalog = null

      beforeEach inject (_Catalog_) ->
        Catalog = _Catalog_
        spyOn Catalog, 'populate'

        $element.click()

      it 'should do nothing', ->
        expect(Catalog.populate).not.toHaveBeenCalled()
