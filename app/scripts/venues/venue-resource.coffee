'use strict'

angular.module('smartRegisterApp')
  .factory 'Venue', ['$location', '$resource', 'Config', '$rootScope', ($location, $resource, Config, $rootScope) ->



    $resource "api://api/merchants/:merchantId/venues/:id",
      id: "@id"
      # there's a circular dependency if Auth is injected here as Auth queries venues
      merchantId: -> $rootScope.credentials?.merchant?.id
    ,
      query:
        method: 'GET'
        isArray: true
        params:
          full: true
    ,
      update:
        method: 'PUT'
        params: {id: '@id'}
  ]
