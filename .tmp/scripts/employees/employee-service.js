(function() {
  angular.module('smartRegisterApp').factory('EmployeeService', [
    '$rootScope', '$http', '$route', '$timeout', '$location', 'ResourceWithPaging', 'ResourceNoPaging', 'Auth', 'VenueService', 'MessagingService', function($rootScope, $http, $route, $timeout, $location, ResourceWithPaging, ResourceNoPaging, Auth, VenueService, MessagingService) {
      var Employees;
      Employees = {};
      Employees["new"] = function() {
        var employee, _ref;
        employee = ResourceNoPaging.one("merchants", (_ref = $rootScope.credentials.merchant) != null ? _ref.id : void 0).one("employees");
        employee.enabled = true;
        employee.isNew = true;
        employee.credentials = [
          {
            type: 'PIN'
          }
        ];
        employee.groups = [
          {
            name: 'MERCHANT_EMPLOYEE'
          }
        ];
        if ($route.current.params.venueId != null) {
          employee["type"] = "Venue";
          employee.venueId = $route.current.params.venueId;
        } else {
          employee["type"] = "Merchant";
          employee.merchantId = $rootScope.credentials.merchant.id;
        }
        return employee;
      };
      Employees.getGridListByVenue = function(venue, params) {
        var gridList, merchantId, _ref, _ref1, _ref2;
        merchantId = (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.merchant) != null ? _ref1.id : void 0 : void 0;
        venue = venue != null ? venue : (_ref2 = $rootScope.credentials) != null ? _ref2.venue : void 0;
        params = params != null ? params : {};
        gridList = [];
        return ResourceNoPaging.one("merchants", merchantId).one("venues", venue.id).getList("employees", params).then(function(employees) {
          angular.forEach(employees, function(employee, index) {
            var activeText, gridRow;
            activeText = "Active";
            if (!employee.enabled) {
              activeText = "Active";
            }
            gridRow = {
              id: employee.id,
              firstname: employee.firstname,
              lastname: employee.lastname,
              displayName: employee.displayName,
              venueId: venue.id,
              venueName: venue.name,
              email: employee.email,
              active: activeText
            };
            return gridList.push(gridRow);
          });
          return gridList;
        });
      };
      Employees.getList = function(merchantId, params) {
        var _ref, _ref1;
        merchantId = merchantId != null ? merchantId : (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.merchant) != null ? _ref1.id : void 0 : void 0;
        params = params != null ? params : {};
        return ResourceNoPaging.one("merchants", merchantId).getList("employees", params);
      };
      Employees.getGridList = function(merchantId, params) {
        var gridList, _ref, _ref1;
        merchantId = merchantId != null ? merchantId : (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.merchant) != null ? _ref1.id : void 0 : void 0;
        params = params != null ? params : {};
        gridList = [];
        return ResourceNoPaging.one("merchants", merchantId).getList("employees", params).then(function(employees) {
          angular.forEach(employees, function(employee, index) {
            var activeText, gridRow;
            activeText = "Active";
            if (!employee.enabled) {
              activeText = "Active";
            }
            gridRow = {
              id: employee.id,
              firstname: employee.firstname,
              lastname: employee.lastname,
              displayName: employee.displayName,
              email: employee.email,
              active: activeText
            };
            return gridList.push(gridRow);
          });
          return gridList;
        });
      };
      Employees.getById = function(employeeId, params) {
        var _ref, _ref1;
        params = params != null ? params : {
          full: true
        };
        return ResourceNoPaging.one("merchants", (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.merchant) != null ? _ref1.id : void 0 : void 0).one("employees", employeeId).get();
      };
      Employees.getByVenueId = function(employeeId, venueId, params) {
        var _ref, _ref1;
        params = params != null ? params : {
          full: true
        };
        return ResourceNoPaging.one("merchants", (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.merchant) != null ? _ref1.id : void 0 : void 0).one("venues", venueId).one("employees", employeeId).get();
      };
      Employees.bulkDeleteVenueEmployees = function(employeeIds, venueId) {
        var _ref, _ref1;
        return $http({
          url: "api://api/merchants/" + ((_ref = $rootScope.credentials) != null ? (_ref1 = _ref.merchant) != null ? _ref1.id : void 0 : void 0) + "/venues/" + venueId + "/employees",
          method: "DELETE",
          headers: {
            'Content-Type': 'application/json;charset=utf-8'
          },
          data: {
            ids: employeeIds
          }
        }).success(function(data, status, headers, config) {
          return data;
        }, function(error) {
          console.log(error);
        });
      };
      Employees.bulkDeleteMerchantEmployees = function(employeeIds, merchantId) {
        var _ref, _ref1;
        return $http({
          url: "api://api/merchants/" + ((_ref = $rootScope.credentials) != null ? (_ref1 = _ref.merchant) != null ? _ref1.id : void 0 : void 0) + "/employees",
          method: "DELETE",
          headers: {
            'Content-Type': 'application/json;charset=utf-8'
          },
          data: {
            ids: employeeIds
          }
        }).success(function(data, status, headers, config) {
          return data;
        }, function(error) {
          console.log(error);
        });
      };
      Employees.updateCredentials = function(employee, credential, callback) {
        var errorCallback, newCredential;
        if (credential != null ? credential.token : void 0) {
          errorCallback = function(response, status) {
            return console.error("failed to create credentials", status, response);
          };
          if (credential.id != null) {
            newCredential = angular.copy(credential);
            delete newCredential.id;
            return $http.put("api://api/merchants/" + (Auth.getMerchant().id) + "/employees/" + employee.id + "/credentials/" + credential.id, newCredential).success(callback).error(errorCallback);
          } else {
            return $http.post("api://api/merchants/" + (Auth.getMerchant().id) + "/employees/" + employee.id + "/credentials", credential).success(callback).error(errorCallback);
          }
        } else if ((credential != null ? credential.id : void 0) != null) {
          return $http["delete"]("api://api/merchants/" + (Auth.getMerchant().id) + "/employees/" + employee.id + "/credentials/" + credential.id).success(function() {
            employee.credentials = _.reject(employee.credentials, function(it) {
              return it.id === credential.id;
            });
            return callback();
          }).error(function(response, status) {
            return console.error("failed to delete credential", status, response);
          });
        } else {
          return callback();
        }
      };
      Employees.save = function(employee, credential) {
        var currentVenueId, pin, _ref;
        pin = _.findWhere(employee.credentials, {
          type: 'PIN'
        });
        if ((employee.credentials != null) && !pin.value) {
          delete employee.credentials;
        }
        currentVenueId = (_ref = $route.current.params.venueId) != null ? _ref : null;
        if (employee.isNew && (employee.id == null)) {
          if (employee.type === "Venue") {
            return ResourceNoPaging.one("merchants", $rootScope.credentials.merchant.id).one("venues", employee.venueId).post("employees", employee).then(function(newEmployee) {
              return Employees.updateCredentials(newEmployee, credential, function() {
                return $location.path("venues/" + employee.venueId + "/employees");
              });
            });
          } else if (employee.type === "Merchant") {
            return ResourceNoPaging.one("merchants", $rootScope.credentials.merchant.id).post("employees", employee).then(function(newEmployee) {
              return Employees.updateCredentials(newEmployee, credential, function() {
                return $location.path("/merchant");
              });
            });
          }
        } else {
          employee = ResourceNoPaging.copy(employee);
          return employee.save().then(function(response) {
            if (employee.type === "Venue") {
              if (employee.merchantId != null) {
                console.log("Move employee from merchant to venue");
                return ResourceNoPaging.one("merchants", $rootScope.credentials.merchant.id).one("employees", employee.id).one("venues", employee.venueId).customPUT(employee).then(function(response) {
                  return $location.path("/venues/" + employee.venueId + "/employees/edit/" + employee.id);
                });
              } else {
                console.log("Move venue from one venue to another");
                return ResourceNoPaging.one("merchants", $rootScope.credentials.merchant.id).one("venues", currentVenueId).one("employees", employee.id).one("venues", employee.venueId).customPUT(employee).then(function(response) {
                  return $location.path("/venues/" + employee.venueId + "/employees/edit/" + employee.id);
                });
              }
            } else if (employee.type === "Merchant") {
              console.log("Move venue employee to merchant");
              return ResourceNoPaging.one("merchants", $rootScope.credentials.merchant.id).one("venues", currentVenueId).one("employees", employee.id).one("merchant").customPUT(employee).then(function(response) {
                return $location.path("/employees/edit/" + employee.id);
              });
            }
          });
        }
      };
      Employees.remove = function(employee) {
        var _ref, _ref1;
        if (employee.venueId != null) {
          return ResourceNoPaging.one("merchants", (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.merchant) != null ? _ref1.id : void 0 : void 0).one("venues", employee.venueId).one("employees", employee.id).get().then(function(employee) {
            return employee.remove();
          });
        } else {
          return Employees.getById().then(function(employee) {
            return employee.remove();
          });
        }
      };
      Employees.isInGroup = function(employee, groupName) {
        return _.findWhere(employee.groups, {
          name: groupName
        }) != null;
      };
      Employees.resetToken = function(token, password) {
        var apiURL, requestBody;
        requestBody = {
          reference: token,
          password: password
        };
        apiURL = "merchants/employees/token/reset";
        return ResourceNoPaging.allUrl(apiURL).customPUT(requestBody);
      };
      Employees.requestPasswordReset = function(email) {
        var apiURL, requestBody;
        requestBody = {
          email: email
        };
        apiURL = "api://api/merchants/employees/token/forgot";
        return $http({
          method: "PUT",
          url: apiURL,
          data: requestBody
        }).success(function(data, status, headers, config) {
          return data;
        }).error(function(data, status, headers, config) {
          var error;
          error = MessagingService.createMessage("error", data.message, 'ForgottenPassword');
          MessagingService.addMessage(error);
          return MessagingService.hasMessages('ForgottenPassword');
        });
      };
      return Employees;
    }
  ]);

}).call(this);

//# sourceMappingURL=employee-service.js.map
