(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('TimesheetsCtrl', [
    '$route', '$rootScope', '$scope', 'venues', 'SettingsService', 'Timesheet', 'Shift', 'startDate', 'endDate', 'timesheets', 'shifts', function($route, $rootScope, $scope, venues, SettingsService, Timesheet, Shift, startDate, endDate, timesheets, shifts) {
      var updateShifts, updateTimesheets;
      $scope.venues = venues;
      $scope.venue = $rootScope.credentials.venue;
      $scope.computeDateRange = function() {
        var i, _, _i, _len, _ref, _results;
        $scope.dateRange = new Array(Math.max($scope.endDate.diff($scope.startDate, 'days'), 0) + 1);
        _ref = $scope.dateRange;
        _results = [];
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          _ = _ref[i];
          _results.push($scope.dateRange[i] = $scope.startDate.clone().add('d', i).format('YYYY-MM-DD'));
        }
        return _results;
      };
      $scope.hasTimesheetData = function() {
        return Object.keys($scope.timesheets).length > 0;
      };
      $scope.startDate = startDate;
      $scope.endDate = endDate;
      $scope.timesheets = _.groupBy(timesheets, function(it) {
        return it.getDate();
      });
      $scope.shifts = shifts;
      $scope.computeDateRange();
      updateTimesheets = function() {
        var from, to;
        from = $scope.startDate.format('YYYY-MM-DDTHH:mm');
        to = $scope.endDate.clone().add('days', 1).format('YYYY-MM-DDTHH:mm');
        return Timesheet.query({
          from: from,
          to: to
        }, function(response) {
          $scope.timesheets = _.groupBy(response, function(it) {
            return it.getDate();
          });
          return $scope.computeDateRange();
        });
      };
      updateShifts = function() {
        var from, to;
        from = $scope.startDate.format('YYYY-MM-DD');
        to = $scope.endDate.clone().add('days', 1).format('YYYY-MM-DD');
        return Shift.query({
          from: from,
          to: to,
          status: 'ENDED'
        }, function(response) {
          return $scope.shifts = response;
        });
      };
      $scope.update = function() {
        updateTimesheets();
        return updateShifts();
      };
      $scope.edit = function(timesheet) {
        return $scope.selectedTimesheet = timesheet;
      };
      $scope.save = function() {
        var count, i, shift, _i, _len, _ref, _results;
        count = $scope.selectedShifts.length;
        _ref = $scope.selectedShifts;
        _results = [];
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          shift = _ref[i];
          _results.push(shift.$update(function() {
            count--;
            if (count === 0) {
              $scope.cancel();
              return updateTimesheets();
            }
          }));
        }
        return _results;
      };
      $scope.cancel = function() {
        return delete $scope.selectedTimesheet;
      };
      $scope.$watch('selectedTimesheet', function(timesheet) {
        if (timesheet != null) {
          return $scope.selectedShifts = _.filter($scope.shifts, function(it) {
            return it.employeeId === timesheet.employeeId && it.getDate() === timesheet.getDate();
          });
        } else {
          return delete $scope.selectedShifts;
        }
      });
      $scope.hasModuleEnabled = function(moduleName) {
        return SettingsService.hasModuleEnabled(moduleName);
      };
      $scope.hasMultipleVenues = function() {
        if ($scope.venues.length > 1) {
          return true;
        } else {
          return false;
        }
      };
      $scope.switchVenue = function(venue) {
        return $scope.$broadcast('venue:switch', venue);
      };
      return $scope.$on('venue:switch', function(event, venue) {
        $rootScope.credentials.venue = venue;
        return $route.reload();
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=timesheets-controller.js.map
