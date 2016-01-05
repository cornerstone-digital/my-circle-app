'use strict'

angular.module('smartRegisterApp')
.factory 'Discount', ['$resource', 'Config', 'Auth', ($resource, Config, Auth) ->
  $resource "api://api/merchants/:merchantId/venues/:venueId/discounts/:id",
    id: '@id'
    merchantId: -> Auth.getMerchant()?.id
    venueId: -> Auth.getVenue()?.id
  ,
    update:
      method: 'PUT'
]
