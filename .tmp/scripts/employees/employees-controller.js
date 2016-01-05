(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('EmployeesCtrl', [
    '$rootScope', '$scope', '$http', '$location', '$route', 'Employee', 'employees', 'venue', 'venues', 'Auth', 'Config', 'SettingsService', 'EmployeeService', function($rootScope, $scope, $http, $location, $route, Employee, employees, venue, venues, Auth, Config, SettingsService, EmployeeService) {
      var updateCredentials;
      $scope.employees = employees;
      $scope.venue = venue;
      $scope.venues = venues;
      $scope.roles = [
        {
          group: {
            name: 'MERCHANT_EMPLOYEE'
          },
          label: 'Staff'
        }, {
          group: {
            name: 'MERCHANT_ADMINISTRATORS'
          },
          label: 'Merchant admin'
        }, {
          group: {
            name: 'PLATFORM_ADMINISTRATORS'
          },
          label: 'Global admin'
        }
      ];
      if (!Auth.isMemberOf('PLATFORM_ADMINISTRATORS')) {
        $scope.roles = $scope.roles.slice(0, _.lastIndexOf($scope.roles, function(it) {
          return Auth.isMemberOf(it.group.name);
        }));
      }
      $scope.create = function() {
        return $location.path("/venues/" + venue.id + "/employees/add");
      };
      $scope.edit = function(employee) {
        return $location.path("/venues/" + $scope.venue.id + "/employees/edit/" + employee.id);
      };
      $scope.remove = function(employee) {
        return EmployeeService.remove(employee).then(function() {
          var index;
          index = $scope.employees.indexOf(employee);
          return $scope.employees.splice(index, 1);
        }, function() {
          console.error("could not delete", employee);
          return $scope.$broadcast("delete:failed", employee);
        });
      };
      updateCredentials = function(employee, credential, callback) {
        var errorCallback;
        if (credential != null ? credential.token : void 0) {
          errorCallback = function(response, status) {
            console.error("failed to create credentials", status, response);
            $scope.error = "" + response.reference + ": " + response.message;
            if (status === 409) {
              $scope.employeeForm.pin.$setValidity('unique', false);
            }
            return delete $scope.locked;
          };
          if (credential.id != null) {
            return $http.put("api://api/merchants/" + (Auth.getMerchant().id) + "/employees/" + employee.id + "/credentials/" + credential.id, credential).success(callback).error(errorCallback);
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
            console.error("failed to delete credential", status, response);
            $scope.error = "" + response.reference + ": " + response.message;
            return delete $scope.locked;
          });
        } else {
          return callback();
        }
      };
      $scope.save = function() {
        var credential, employee;
        if ($scope.employeeForm.$valid) {
          $scope.locked = true;
          employee = $scope.employee;
          credential = $scope.credential;
          if (employee.id != null) {
            return employee.$update(function() {
              return updateCredentials(employee, credential, function() {
                var index, _i, _ref;
                for (index = _i = 0, _ref = $scope.employees.length; 0 <= _ref ? _i < _ref : _i > _ref; index = 0 <= _ref ? ++_i : --_i) {
                  if ($scope.employees[index].id === employee.id) {
                    $scope.employees[index] = employee;
                  }
                }
                delete $scope.employee;
                delete $scope.credential;
                return delete $scope.locked;
              });
            }, function(response) {
              console.error("failed to update employee '" + employee.name + "'");
              $scope.error = "" + response.data.reference + ": " + response.data.message;
              return delete $scope.locked;
            });
          } else {
            return employee.$save(function(response) {
              employee.credentials = [credential];
              return updateCredentials(employee, credential, function() {
                $scope.employees.push(employee);
                delete $scope.employee;
                delete $scope.credential;
                return delete $scope.locked;
              });
            }, function(response) {
              console.error("failed to save employee '" + employee.name + "'");
              $scope.error = "" + response.data.reference + ": " + response.data.message;
              return delete $scope.locked;
            });
          }
        }
      };
      $scope.cancel = function() {
        delete $scope.employee;
        delete $scope.credential;
        return delete $scope.error;
      };
      $scope.switchToGroup = function(group) {
        var role, _i, _len, _ref;
        _ref = $scope.roles;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          role = _ref[_i];
          $scope.employee.groups = _.reject($scope.employee.groups, function(it) {
            return it.name === role.group.name;
          });
        }
        return $scope.employee.groups.push(group);
      };
      $scope.hasModuleEnabled = function(moduleName) {
        return SettingsService.hasModuleEnabled(moduleName);
      };
      $scope.confirmedDelete = function(employee) {
        return $scope.employeeToDelete = employee;
      };
      $scope.closeConfirm = function() {
        return delete $scope.employeeToDelete;
      };
      $scope.confirmYes = function() {
        $scope.remove($scope.employeeToDelete);
        return $scope.closeConfirm();
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

//# sourceMappingURL=employees-controller.js.map
