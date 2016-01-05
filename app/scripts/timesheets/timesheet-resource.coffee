'use strict'

angular.module('smartRegisterApp')
  .factory 'Timesheet', ['$resource', 'Config', 'Auth', ($resource, Config, Auth) ->
    Timesheet = $resource "api://api/merchants/:merchantId/venues/:venueId/reports",
      id: '@id'
      type: 'timesheet'
      merchantId: -> Auth.getMerchant()?.id
      venueId: -> Auth.getVenue()?.id
    ,
      query:
        method: 'GET'
        isArray: true
        transformResponse: (data) ->
          json = if typeof data is 'string' then JSON.parse(data) else data
          json.timesheetReport.timesheets ? []

    Timesheet::getDate = ->
      moment(@dateStarted).format 'YYYY-MM-DD'

    Timesheet
  ]
