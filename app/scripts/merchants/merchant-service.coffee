angular.module('smartRegisterApp')
.factory 'MerchantService', ['$rootScope', 'ResourceWithPaging','ResourceNoPaging', '$route', ($rootScope, ResourceWithPaging, ResourceNoPaging, $route) ->
  new: ->
    merchant = ResourceNoPaging.one("merchants")
    merchant.enabled = true

    merchant.venues = [
      address:
        country:
          numericCode: 826
        isAddressFor: 'ALL'
      contacts: [
        {type: 'NAME', value: ''}
        {type: 'PHONE', value: ''}
        {type: 'EMAIL', value: ''}
      ]
    ]
    merchant.employees = [
        enabled: true
        credentials: [
          type: 'EMAIL'
        ]
        groups: [
          name: 'MERCHANT_ADMINISTRATORS'
        ]
      ]

    return merchant

  getPagedList: (params) ->
    if(!angular.isObject(params))
      params = {
        page: $route.current.params.page ? null
        size: $route.current.params.size ? null
        sort: $route.current.params.sort ? null
      }

    ResourceWithPaging.all("merchants").getList(params)

  getList: ->
    ResourceNoPaging.all("merchants").all("list").getList()

  getById: (merchantId, params) ->
    merchantId = merchantId ? $rootScope.credentials.merchant.id
    params = params ? {full:false}

    ResourceNoPaging.one("merchants", merchantId).get(params)

  save: (merchant) ->
    if(merchant.id)
      merchant.save()
    else
      ResourceNoPaging.all("merchants").post(merchant)

  remove: (merchant) ->
    merchant.remove()
]
