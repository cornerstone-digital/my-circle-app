'use strict'

describe 'Resource: Product', ->

  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'testFixtures', 'views/faq.html', 'views/login.html'

  Config = {}
  Product = {}
  httpBackend = {}
  merchantId = 'the-merchant-id'
  venueId = 'the-venue-id'
  fixtures = {}

  beforeEach inject (_Config_, _Product_, Auth, $httpBackend, flatWhite, croissant) ->
    Config = _Config_
    Product = _Product_
    httpBackend = $httpBackend
    fixtures.flatWhite = flatWhite
    fixtures.croissant = croissant

    spyOn(Auth, 'getMerchant').andCallFake -> id: merchantId
    spyOn(Auth, 'getVenue').andCallFake -> id: venueId

  afterEach ->
    localStorage.clear()

    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'setting the venue in the resource URL', ->
    it 'should use the venueId from local storage when making requests', ->
      httpBackend.expectGET("#{Config.baseURL()}/api/merchants/#{merchantId}/venues/#{venueId}/products").respond 200, []

      Product.query()

      httpBackend.flush()

  describe 'REST API', ->
    describe 'retrieving data', ->
      it 'should retrieve a list of products', ->
        httpBackend.expectGET("#{Config.baseURL()}/api/merchants/#{merchantId}/venues/#{venueId}/products").respond [fixtures.flatWhite, fixtures.croissant]

        products = Product.query()
        httpBackend.flush()

        expect(products.length).toBe 2
        expect(_.pluck products, 'title').toEqual [fixtures.flatWhite.title, fixtures.croissant.title]

      it 'should retrieve a single product', ->
        httpBackend.expectGET("#{Config.baseURL()}/api/merchants/#{merchantId}/venues/#{venueId}/products/#{fixtures.flatWhite.id}").respond fixtures.flatWhite

        products = Product.get id: fixtures.flatWhite.id
        httpBackend.flush()

        expect(products.title).toBe fixtures.flatWhite.title

    describe 'creating data', ->
      it 'should create a new product', ->
        httpBackend.expectPOST "#{Config.baseURL()}/api/merchants/#{merchantId}/venues/#{venueId}/products",
          title: 'Americano'
        .respond 201,
          id: '1'
          title: 'Americano'

        product = new Product(title: 'Americano')
        product.$save()
        httpBackend.flush()

        expect(product.id).toBe '1'
        expect(product.title).toBe 'Americano'

    describe 'updating data', ->
      product = null

      beforeEach ->
        product = new Product(fixtures.croissant)

      it 'should update a product', ->
        httpBackend.expectPUT("#{Config.baseURL()}/api/merchants/#{merchantId}/venues/#{venueId}/products/#{fixtures.croissant.id}", fixtures.croissant).respond fixtures.croissant

        product.$update()

        httpBackend.flush()

      it 'should delete a product', ->
        httpBackend.expectDELETE("#{Config.baseURL()}/api/merchants/#{merchantId}/venues/#{venueId}/products/#{fixtures.croissant.id}").respond 200

        product.$delete()

        httpBackend.flush()
