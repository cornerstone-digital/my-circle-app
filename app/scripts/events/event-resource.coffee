'use strict'

angular.module('smartRegisterApp')
  .factory 'Event', ['$resource', 'Config', 'Auth', ($resource, Config, Auth) ->
    $resource "api://api/merchants/:merchantId/venues/:venueId/events/:id",
      id: "@id"
      merchantId: -> Auth.getMerchant()?.id
      venueId: -> Auth.getVenue()?.id
    ,
      query:
        method: 'GET'
        isArray: true
        transformResponse: (data) ->
          data = JSON.parse(data) if typeof data is 'string'
          data.content
  ]
