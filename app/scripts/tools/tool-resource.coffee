'use strict'

angular.module('smartRegisterApp')
  .factory 'Tool', ['$resource', 'Config', 'Auth', ($resource, Config, Auth) ->
    $resource "api://api/merchants/:merchantId/venues/:venueId/tools/:id",
      id: "@id"
      merchantId: -> Auth.getMerchant()?.id
      venueId: -> Auth.getVenue()?.id
    ,
      update:
        method: 'PUT'
        transformRequest: (resource, headers) ->
          # the endpoint does not allow modification of the appId and will
          # respond with 409 if it is sent
          JSON.stringify _.omit(resource, 'appId')
  ]
