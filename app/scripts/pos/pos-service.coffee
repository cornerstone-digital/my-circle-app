angular.module('smartRegisterApp')
.factory 'POSService', ['$rootScope', 'ResourceNoPaging', 'SettingsService', 'Auth', ($rootScope, ResourceNoPaging, SettingsService, Auth) ->
  getList: (venueId, params) ->
    venueId = venueId ? $rootScope.credentials?.venue?.id
    params = params ? {}

    ResourceNoPaging.one("merchants", Auth.getMerchant()?.id).one("venues", venueId).getList("pos", params)

  getById: (posId) ->
    ResourceNoPaging.one("merchants", Auth.getMerchant()?.id).one("venues", venueId).one("pos", posId).get()

  getByName: (name) ->
    @getList().then((response)->
      return _.filter response, (it) -> it.name is name
    )

  getPosValues: (venueId, params) ->
    venueId = venueId ? $rootScope.credentials?.venue?.id
    params = params ? {}

    ResourceNoPaging.one("merchants", Auth.getMerchant()?.id).one("venues", venueId).one("pos").one("values").get(params)
]