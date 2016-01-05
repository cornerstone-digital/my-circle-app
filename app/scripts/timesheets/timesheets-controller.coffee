'use strict'

angular.module('smartRegisterApp')
  .controller 'TimesheetsCtrl', ['$route', '$rootScope', '$scope', 'venues', 'SettingsService', 'Timesheet', 'Shift', 'startDate', 'endDate', 'timesheets', 'shifts', ($route, $rootScope, $scope, venues, SettingsService, Timesheet, Shift, startDate, endDate, timesheets, shifts) ->

    $scope.venues = venues
    $scope.venue = $rootScope.credentials.venue

    $scope.computeDateRange = ->
      $scope.dateRange = new Array(Math.max($scope.endDate.diff($scope.startDate, 'days'), 0) + 1)
      $scope.dateRange[i] = $scope.startDate.clone().add('d', i).format('YYYY-MM-DD') for _, i in $scope.dateRange

    $scope.hasTimesheetData = ->
      Object.keys($scope.timesheets).length > 0

    $scope.startDate = startDate
    $scope.endDate = endDate
    $scope.timesheets = _.groupBy timesheets, (it) -> it.getDate()
    $scope.shifts = shifts

    $scope.computeDateRange()

    updateTimesheets = ->
      from = $scope.startDate.format('YYYY-MM-DDTHH:mm')
      to = $scope.endDate.clone().add('days', 1).format('YYYY-MM-DDTHH:mm')
      Timesheet.query
        from: from
        to: to
      , (response) ->
        $scope.timesheets = _.groupBy response, (it) -> it.getDate()
        $scope.computeDateRange()

    updateShifts = ->
      from = $scope.startDate.format('YYYY-MM-DD')
      to = $scope.endDate.clone().add('days', 1).format('YYYY-MM-DD')
      Shift.query
        from: from
        to: to
        status: 'ENDED'
      , (response) ->
        $scope.shifts = response

    $scope.update = ->
      updateTimesheets()
      updateShifts()

    $scope.edit = (timesheet) ->
      $scope.selectedTimesheet = timesheet

    $scope.save = ->
      count = $scope.selectedShifts.length
      for shift, i in $scope.selectedShifts
        shift.$update ->
          count--
          # once last update completes successfully close the form and refresh timesheet data
          if count is 0
            $scope.cancel()
            updateTimesheets()

    $scope.cancel = ->
      delete $scope.selectedTimesheet

    $scope.$watch 'selectedTimesheet', (timesheet) ->
      if timesheet?
        $scope.selectedShifts = _.filter $scope.shifts, (it) ->
          it.employeeId is timesheet.employeeId and it.getDate() is timesheet.getDate()
      else
        delete $scope.selectedShifts

    $scope.hasModuleEnabled = (moduleName) ->
      SettingsService.hasModuleEnabled moduleName

    $scope.hasMultipleVenues = ->
      if($scope.venues.length > 1)
        return true
      else
        return false

    $scope.switchVenue = (venue) ->
      $scope.$broadcast 'venue:switch', venue

    $scope.$on 'venue:switch', (event, venue) ->
        $rootScope.credentials.venue = venue
        $route.reload()
]

