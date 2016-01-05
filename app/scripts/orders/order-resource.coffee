'use strict'

angular.module('smartRegisterApp')
  .factory 'Order', ['$resource', 'Config', '$location', 'Auth', ($resource, Config, $location, Auth) ->
    $resource "api://api/merchants/:merchantId/venues/:venueId/orders/:id",
      id: "@id"
      merchantId: -> Auth.getMerchant()?.id
      venueId: -> Auth.getVenue()?.id
    ,
      query:
        method: 'GET'
        isArray: true
        params:
          sort: 'created,desc'
        transformResponse: (data) ->
          data = JSON.parse(data) if typeof data is 'string'
          data.content
      refund:
        method: 'PUT'
        transformRequest: (data) ->
          JSON.stringify
            items: _.pluck data.basket.items.filter((item) -> item.toRefund), 'id'
            pos: $location.search()['pos.name']
  ]
