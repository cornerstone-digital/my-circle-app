angular.module('smartRegisterApp')
.factory 'VenueService', ['$rootScope', 'ResourceNoPaging', 'SettingsService', 'Auth', ($rootScope, ResourceNoPaging, SettingsService, Auth) ->

  new: ->
    venue = ResourceNoPaging.one("merchants", $rootScope.credentials.merchant?.id).one("venues")
    venue.address = {
      country:
        numericCode: 826
      isAddressFor: 'ALL'
    }

    venue.contacts = [
      type: 'PHONE'
    ]

    venue.sections = []

    return venue

  getVenueContactByType: (venue, type) ->
    _.find venue.contacts, (it) -> it.type is type

  getSectionById: (venue, sectionId) ->
    _.find venue.sections, (it) -> it.id is sectionId

  isExistingSection: (venue, name) ->
    _.filter venue.sections, (it) -> it.name is name

  getGridList: (merchantId, params) ->
    merchantId = merchantId ? $rootScope.credentials?.merchant?.id
    params = params ? {}
    gridList = []

    ResourceNoPaging.one("merchants", merchantId).getList("venues", params).then((venues) ->

      angular.forEach venues, (venue, index) ->


        email = _.find venue.contacts, (it) -> it.type is "EMAIL" ? ""
        phone = _.find venue.contacts, (it) -> it.type is "PHONE" ? ""

        gridRow =
          id: venue.id
          name: venue.name
          postcode: venue.address.postCode
          email: email?.value ? ""
          phone: phone?.value ? ""

        gridList.push(gridRow)

      return gridList
    )

  getList: (merchantId, params) ->

    merchantId = merchantId ? $rootScope.credentials?.merchant?.id
    params = params ? {}

    ResourceNoPaging.one("merchants", merchantId).all("venues").getList(params)

  getById: (venueId, params) ->
    venueId = venueId ? $rootScope.credentials?.venue?.id
    params = params ? {full:true}
    venue = null

    ResourceNoPaging.one("merchants", $rootScope.credentials?.merchant?.id).one("venues", venueId).get(params).then((response) ->
      venue = response

      unless venue.sections
        venue.sections = []

      return venue
    )

  getVenueCategories: (venueId, params) ->
    venueId = venueId ? $rootScope.credentials?.venue?.id
    params = params ? {}

    ResourceNoPaging.one("merchants", $rootScope.credentials?.merchant?.id).one("venues", venueId).getList("categories", params)

  getVenueSections: (venueId) ->
    @getById(venueId).then((response) ->
      response?.sections
    )

  getVenueProducts: (venueId, params) ->
    venueId = venueId ? $rootScope.credentials?.venue?.id
    params = params ? {}

    ResourceNoPaging.one("merchants", $rootScope.credentials?.merchant?.id).one("venues", venueId).getList("products", params)

  getVenueProductsByCategory: (venueId, categoryId, params) ->
    venueId = venueId ? $rootScope.credentials?.venue?.id
    params = params ? {}

    ResourceNoPaging.one("merchants", $rootScope.credentials?.merchant?.id).one("venues", venueId).one("categories", categoryId).getList("products", params)

  save: (venue) ->
    if(venue.id)
      venue = ResourceNoPaging.copy(venue)
      venue.save()
    else
      ResourceNoPaging.one("merchants", $rootScope.credentials?.merchant?.id).post("venues", venue)

  remove: (venue) ->
    venue = ResourceNoPaging.copy(venue)
    venue.remove()

  canAddVenue: ->
    SettingsService.hasModuleEnabled('multivenue') && Auth.hasRole('PERM_MERCHANT_ADMINISTRATOR')

  duplicate: (venue) ->
    venueId = venue?.id ? $rootScope.credentials?.venue?.id
    ResourceNoPaging
      .one("merchants", $rootScope.credentials?.merchant?.id)
      .one("venues", venueId)
      .customPOST("", "clone")

]
