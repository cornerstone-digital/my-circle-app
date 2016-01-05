(function() {
  'use strict';
  angular.module('smartRegisterApp').factory('Employee', [
    '$resource', 'Config', 'Auth', function($resource, Config, Auth) {
      var Employee;
      Employee = $resource("api://api/merchants/:merchantId/employees/:id", {
        id: "@id",
        merchantId: function() {
          var _ref;
          return (_ref = Auth.getMerchant()) != null ? _ref.id : void 0;
        }
      }, {
        save: {
          method: 'POST',
          transformRequest: function(requestBody) {
            var data;
            data = angular.copy(requestBody);
            delete data.credentials;
            return JSON.stringify(data);
          }
        },
        update: {
          method: 'PUT',
          transformRequest: function(requestBody) {
            var data;
            data = angular.copy(requestBody);
            delete data.credentials;
            delete data.discounts;
            delete data.smartTools;
            return JSON.stringify(data);
          }
        }
      });
      Employee.prototype.isInGroup = function(groupName) {
        return _.findWhere(this.groups, {
          name: groupName
        }) != null;
      };
      return Employee;
    }
  ]);

}).call(this);

//# sourceMappingURL=employee-resource.js.map
