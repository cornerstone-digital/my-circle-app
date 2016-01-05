(function() {
  'use strict';
  angular.module('smartRegisterApp').factory('Timesheet', [
    '$resource', 'Config', 'Auth', function($resource, Config, Auth) {
      var Timesheet;
      Timesheet = $resource("api://api/merchants/:merchantId/venues/:venueId/reports", {
        id: '@id',
        type: 'timesheet',
        merchantId: function() {
          var _ref;
          return (_ref = Auth.getMerchant()) != null ? _ref.id : void 0;
        },
        venueId: function() {
          var _ref;
          return (_ref = Auth.getVenue()) != null ? _ref.id : void 0;
        }
      }, {
        query: {
          method: 'GET',
          isArray: true,
          transformResponse: function(data) {
            var json, _ref;
            json = typeof data === 'string' ? JSON.parse(data) : data;
            return (_ref = json.timesheetReport.timesheets) != null ? _ref : [];
          }
        }
      });
      Timesheet.prototype.getDate = function() {
        return moment(this.dateStarted).format('YYYY-MM-DD');
      };
      return Timesheet;
    }
  ]);

}).call(this);

//# sourceMappingURL=timesheet-resource.js.map
