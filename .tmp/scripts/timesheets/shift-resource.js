(function() {
  'use strict';
  angular.module('smartRegisterApp').factory('Shift', [
    '$resource', 'Config', 'Auth', function($resource, Config, Auth) {
      var Shift;
      Shift = $resource("api://api/merchants/:merchantId/employees/:eid/shifts/:id", {
        merchantId: function() {
          var _ref;
          return (_ref = Auth.getMerchant()) != null ? _ref.id : void 0;
        },
        id: '@id',
        eid: '@employeeId'
      }, {
        query: {
          url: "api://api/merchants/:merchantId/employees/shifts",
          method: 'GET',
          isArray: true,
          params: {
            merchantId: function() {
              var _ref;
              return (_ref = Auth.getMerchant()) != null ? _ref.id : void 0;
            }
          }
        },
        update: {
          method: 'PUT'
        },
        report: {
          url: "api://api/merchants/:merchantId/venues/:venueId/reports/timesheet",
          method: 'GET',
          isArray: true,
          params: {
            merchantId: function() {
              var _ref;
              return (_ref = Auth.getMerchant()) != null ? _ref.id : void 0;
            },
            venueId: function() {
              var _ref;
              return (_ref = Auth.getVenue()) != null ? _ref.id : void 0;
            }
          }
        }
      });
      Shift.prototype.getDate = function() {
        return moment(this.started).format('YYYY-MM-DD');
      };
      return Shift;
    }
  ]);

}).call(this);

//# sourceMappingURL=shift-resource.js.map
