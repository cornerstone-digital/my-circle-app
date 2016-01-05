angular.module('smartRegisterApp')
.factory 'CategoryService', ['$rootScope', 'ResourceNoPaging', ($rootScope, ResourceNoPaging) ->
  getList: (venueId, params) ->
    venueId = venueId ? $rootScope.credentials?.venue?.id
    params = params ? {}

    ResourceNoPaging.one("merchants", $rootScope.credentials?.merchant?.id).one("venues", venueId).getList("categories", params)

  getById: (venueId, categoryId, params) ->
    venueId = venueId ? $rootScope.credentials?.venue?.id
    params = params ? {}

    ResourceNoPaging.one("merchants", $rootScope.credentials.merchant.id).one("venues", venueId).one("categories", categoryId).get(params)

  save: (venueId, category) ->
    if(category.id)
      category = ResourceNoPaging.copy(category)
      category.save()
    else
      ResourceNoPaging.one("merchants", $rootScope.credentials?.merchant?.id).one("venues", venueId).post("categories", category)

  remove: (category) ->
    category = ResourceNoPaging.copy(category)
    category.remove()
]