'use strict'

describe 'Controller: Timesheets', ->

  $scope = null
  $timeout = null
  Shift = null
  Timesheet = null
  Venue = null

  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'views/faq.html'

  beforeEach inject ($rootScope, _$timeout_, _Shift_, _Timesheet_, _Venue_) ->
    Shift = _Shift_
    Timesheet = _Timesheet_
    Venue = _Venue_

    $timeout = _$timeout_
    $scope = $rootScope.$new()

    $rootScope.credentials = [
      venue: {}
    ]

  describe 'displaying timesheets', ->

    timesheets = null
    shifts = null
    venues = null

    beforeEach inject ($controller) ->

      timesheets = [
        employeeId: "no68qjp"
        employeeName: "Al Coholic"
        dateStarted: '2013-11-29'
        totalDuration: 59166
        shifts: 2
      ,
        employeeId: "no68qjp"
        employeeName: "Al Coholic"
        dateStarted: '2013-11-26'
        totalDuration: 7093521
        shifts: 1
      ,
        employeeId: "3rs3X8g"
        employeeName: "Bea O'Problem"
        dateStarted: '2013-11-26'
        totalDuration: 6469520
        shifts: 1
      ].map (it) -> new Timesheet(it)

      shifts = [
        __v: 0
        id: "oTXr9iQ"
        duration: 6469520
        employeeId: "3rs3X8g"
        employeeName: "Bea O'Problem"
        ended: "2013-11-26T15:36:01.876Z"
        merchantId: "HP7BhIA"
        venueId: "lqEkgnL"
        status: "ENDED"
        started: "2013-11-26T13:48:12.356Z"
      ,
        __v: 0
        id: "bwIlBEy"
        duration: 7093521
        employeeId: "no68qjp"
        employeeName: "Al Coholic"
        ended: "2013-11-26T15:49:47.788Z"
        merchantId: "HP7BhIA"
        venueId: "lqEkgnL"
        status: "ENDED"
        started: "2013-11-26T13:51:34.267Z"
      ,
        __v: 0
        id: "Nd9NovE"
        duration: 48743
        employeeId: "no68qjp"
        employeeName: "Al Coholic"
        ended: "2013-11-29T15:59:57.525Z"
        merchantId: "HP7BhIA"
        venueId: "lqEkgnL"
        status: "ENDED"
        started: "2013-11-29T15:59:08.782Z"
      ,
        __v: 0
        id: "mY7gMqW"
        duration: 10423
        employeeId: "no68qjp"
        employeeName: "Al Coholic"
        ended: "2013-11-29T16:03:07.980Z"
        merchantId: "HP7BhIA"
        venueId: "lqEkgnL"
        status: "ENDED"
        started: "2013-11-29T16:02:57.557Z"
      ].map (it) -> new Shift(it)

      venues = [
        name: "venue name"
      ].map (it) -> new Venue(it)

      $controller 'TimesheetsCtrl',
        $scope: $scope
        venues: venues
        SettingsService: null
        startDate: moment('2013-11-26')
        endDate: moment('2013-11-29')
        timesheets: timesheets
        shifts: shifts

    it 'adds the date range as an array to the scope', ->
      expect($scope.dateRange.length).toBe 4
      expect($scope.dateRange[i]).toBe date for date, i in ['2013-11-26', '2013-11-27', '2013-11-28', '2013-11-29']

    it 'adds the timesheets to the scope grouped by date', ->
      expect($scope.timesheets['2013-11-26'].length).toBe 2
      expect($scope.timesheets['2013-11-27']).toBeUndefined()
      expect($scope.timesheets['2013-11-28']).toBeUndefined()
      expect($scope.timesheets['2013-11-29'].length).toBe 1

    describe 'updating the date range', ->

      beforeEach ->
        spyOn Timesheet, 'query'
        spyOn Shift, 'query'

        $scope.startDate = moment('2013-12-01')
        $scope.endDate = moment('2013-12-25')

        $scope.update()

      it 'should request new data from the API', ->
        expect(Timesheet.query).toHaveBeenCalled()
        expect(Timesheet.query.mostRecentCall.args[0]).toEqual
          from: '2013-12-01T00:00'
          to: '2013-12-26T00:00'

        expect(Shift.query).toHaveBeenCalled()
        expect(Shift.query.mostRecentCall.args[0]).toEqual
          from: '2013-12-01'
          to: '2013-12-26'
          status: 'ENDED'

    describe 'selecting a timesheet with a single shift', ->

      beforeEach ->
        $scope.$apply -> $scope.edit timesheets[1]

      it 'adds the selected timesheet to scope', ->
        expect($scope.selectedTimesheet).toBe timesheets[1]

      it 'adds the relevant shift to scope', ->
        expect($scope.selectedShifts.length).toBe 1
        expect($scope.selectedShifts[0].id).toBe 'bwIlBEy'

      describe 'saving', ->

        beforeEach ->
          spyOn(shifts[1], '$update').andCallFake (success, error) ->
            $timeout -> success()

          spyOn Timesheet, 'query'
          spyOn Shift, 'query'

          $scope.$apply -> $scope.save()

        it 'should update the shift', ->
          expect(shifts[1].$update).toHaveBeenCalled()

        it 'should close the form once the update completes', ->
          expect($scope.selectedTimesheet).not.toBeUndefined()

          $timeout.flush()

          expect($scope.selectedTimesheet).toBeUndefined()

        it 'should refresh the timesheet data once the update completes', ->
          expect(Timesheet.query).not.toHaveBeenCalled()

          $timeout.flush()

          expect(Timesheet.query).toHaveBeenCalled()
          expect(Timesheet.query.mostRecentCall.args[0]).toEqual
            from: '2013-11-26T00:00'
            to: '2013-11-30T00:00'
          expect(Shift.query).not.toHaveBeenCalled()

      describe 'cancelling', ->

        beforeEach ->
          $scope.$apply -> $scope.cancel()

        it 'removes the selected timesheet from scope', ->
          expect($scope.selectedTimesheet).toBeUndefined()

        it 'removes the selected shifts from scope', ->
          expect($scope.selectedShifts).toBeFalsy() # don't really care if it's undefined or empty array

    describe 'selecting a timesheet with multiple shifts', ->

      beforeEach ->
        $scope.$apply -> $scope.edit timesheets[0]

      it 'places all the relevant shifts in scope', ->
        expect($scope.selectedShifts.length).toBe 2
        expect(_.pluck $scope.selectedShifts, 'id').toEqual ['Nd9NovE', 'mY7gMqW']

      describe 'saving', ->

        beforeEach ->
          spyOn(shifts[2], '$update').andCallFake (success, error) ->
            $timeout -> success()
          spyOn(shifts[3], '$update').andCallFake (success, error) ->
            $timeout -> success()

          $scope.$apply -> $scope.save()

        it 'should update all the shifts', ->
          expect(shifts[2].$update).toHaveBeenCalled()
          expect(shifts[3].$update).toHaveBeenCalled()
