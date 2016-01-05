'use strict'

angular.module('smartRegisterApp')
  .factory 'Product', ['$resource', 'Config', 'Auth', ($resource, Config, Auth) ->
    $resource "api://api/merchants/:merchantId/venues/:venueId/products/:id",
      id: "@id"
      venueId: -> Auth.getVenue()?.id
      merchantId: -> Auth.getMerchant()?.id
    ,
      update:
        method: 'PUT'
  ]
