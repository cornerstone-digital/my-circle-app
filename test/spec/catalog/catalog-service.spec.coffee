# TODO: Update tests for catalog-service.spec
#'use strict'
#
#describe 'Service: Catalog', ->
#
#  beforeEach module 'mockEnvironment', 'smartRegisterApp'
#
#  # this overrides the catalogTemplate
#  beforeEach module ($provide) ->
#    $provide.constant 'catalogTemplate', Object.freeze
#      categories: [
#        title: 'coffee'
#        products: [
#          title: 'Flat White'
#        ]
#      ,
#        title: 'breakfast'
#        products: [
#          title: 'Croissant'
#        ,
#          title: 'Bagel'
#        ]
#      ]
#    null
#
#  merchant = null
#
#  beforeEach inject (Merchant, Venue) ->
#    merchant = new Merchant
#      id: 'the-merchant-id'
#      name: 'The Electric Psychedelic Pussycat Swingers Club'
#      venues: [
#        new Venue
#          id: 'the-venue-id'
#          name: 'The Electric Psychedelic Pussycat Swingers Club'
#          categories: []
#          products: []
#      ]
#
#  describe "populating a merchant's catalog", ->
#
#    categories = null
#    products = null
#    $httpBackend = null
#    callback = null
#
#    beforeEach inject (Catalog, _$httpBackend_, Config) ->
#      categories = []
#      products = []
#
#      $httpBackend = _$httpBackend_
#
#      $httpBackend.whenPOST("#{Config.baseURL()}/api/merchants/#{merchant.id}/venues/#{merchant.venues[0].id}/categories")
#      .respond (method, uri, data) ->
#        category = JSON.parse(data)
#        categories.push category
#        [201, JSON.stringify(id: "#{category.title}-id")]
#
#      $httpBackend.whenPOST("#{Config.baseURL()}/api/merchants/#{merchant.id}/venues/#{merchant.venues[0].id}/products")
#      .respond (method, uri, data) ->
#        product = JSON.parse(data)
#        products.push product
#        [201, JSON.stringify(id: "#{product.title}-id")]
#
#      callback = jasmine.createSpy()
#      Catalog.populate merchant, callback
#
#    afterEach ->
#      $httpBackend.verifyNoOutstandingExpectation()
#      $httpBackend.verifyNoOutstandingRequest()
#
#    it 'should persist categories', ->
#      $httpBackend.flush()
#      expect(_.pluck categories, 'title').toBeEqualSet ['breakfast', 'coffee']
#
#    it 'should persist products', ->
#      $httpBackend.flush()
#      expect(_.pluck products, 'title').toBeEqualSet ['Bagel', 'Croissant', 'Flat White']
#
#    it 'should wire up the correct category for each product', ->
#      $httpBackend.flush()
#
#      productsByCategory = _.groupBy products, (it) -> it.category
#      expect(Object.keys productsByCategory).toBeEqualSet ['breakfast-id', 'coffee-id']
#      expect(_.pluck productsByCategory['breakfast-id'], 'title').toBeEqualSet ['Bagel', 'Croissant']
#      expect(_.pluck productsByCategory['coffee-id'], 'title').toBeEqualSet ['Flat White']
#
#    it 'should call the callback at the end', ->
#      $httpBackend.flush()
#      expect(callback).toHaveBeenCalled()
