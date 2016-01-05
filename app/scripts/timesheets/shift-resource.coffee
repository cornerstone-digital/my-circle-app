'use strict'

angular.module('smartRegisterApp')
  .factory 'Shift', ['$resource', 'Config', 'Auth', ($resource, Config, Auth) ->
    Shift = $resource "api://api/merchants/:merchantId/employees/:eid/shifts/:id",
      merchantId: -> Auth.getMerchant()?.id
      id: '@id'
      eid: '@employeeId'
    ,
      query:
        url: "api://api/merchants/:merchantId/employees/shifts"
        method: 'GET'
        isArray: true
        params:
          merchantId: -> Auth.getMerchant()?.id
      update:
        method: 'PUT'
      report:
        url: "api://api/merchants/:merchantId/venues/:venueId/reports/timesheet"
        method: 'GET'
        isArray: true
        params:
          merchantId: -> Auth.getMerchant()?.id
          venueId: -> Auth.getVenue()?.id

    Shift::getDate = ->
      moment(@started).format 'YYYY-MM-DD'

    Shift
  ]
