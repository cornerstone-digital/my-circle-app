angular.module('smartRegisterApp')
.factory 'DiscountService', ['$rootScope', '$http', 'ResourceWithPaging','ResourceNoPaging', 'MessagingService', ($rootScope, $http, ResourceWithPaging, ResourceNoPaging, MessagingService) ->
  new: ->
    discount = ResourceNoPaging.one("merchants", $rootScope.credentials.merchant?.id).one("venues", $rootScope.credentials.venue?.id).one("discounts")
    discount.value = 0
    discount.groups = []

    return discount

  getList: (venueId, params) ->

    merchantId = $rootScope.credentials?.merchant?.id
    venueId = venueId ? $rootScope.credentials?.venue?.id

    params = params ? {}

    ResourceNoPaging.one("merchants", merchantId).one("venues", venueId).getList("discounts", params)

  getById: (discountId, params) ->
    params = params ? {full:true}

    ResourceNoPaging.one("merchants", $rootScope.credentials?.merchant?.id).one("venues", $rootScope.credentials.venue?.id).one("discounts", discountId).get().then((response)->
      discount = response
      discount.groups = [] unless response.groups

      return discount
    )

  save: (discount) ->
    if(discount.id)
      discount = ResourceNoPaging.copy(discount)
      discount.save()
    else
      ResourceNoPaging.one("merchants", $rootScope.credentials?.merchant?.id).one("venues", $rootScope.credentials.venue?.id).post("discounts", discount)

  remove: (discount) ->
    discount = ResourceNoPaging.copy(discount)
    discount.remove()
]