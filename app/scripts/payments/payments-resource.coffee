'use strict'

angular.module('smartRegisterApp')
  .factory 'Payments', ['$resource', 'Config', 'Auth', ($resource, Config, Auth) ->
    $resource "api://api/merchants/:merchantId/venues/:venueId/payments/:id",
      id: "@id"
      venueId: -> Auth.getVenue()?.id
      merchantId: -> Auth.getMerchant()?.id

  ]
