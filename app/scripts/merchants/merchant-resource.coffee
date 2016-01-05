'use strict'

angular.module('smartRegisterApp')
  .factory 'Merchant', ['$resource', 'Config', ($resource, Config) ->
    $resource "api://api/merchants/:id",
      id: "@id"
    ,
      query:
        method: 'GET'
        isArray: true
        transformResponse: (data) ->
          data = JSON.parse(data) if typeof data is 'string'
          data.content
    ,
      update:
        method: 'PUT'
  ]
