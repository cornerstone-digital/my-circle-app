(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('EmployeeFormCtrl', [
    '$rootScope', '$scope', '$location', '$timeout', '$http', 'employee', 'venues', 'venue', 'Auth', 'EmployeeService', 'MessagingService', 'ValidationService', function($rootScope, $scope, $location, $timeout, $http, employee, venues, venue, Auth, EmployeeService, MessagingService, ValidationService) {
      $scope.employee = employee;
      $scope.credential = _.find($scope.employee.credentials, function(it) {
        return it.type === 'PIN';
      });
      $scope.venues = venues;
      $scope.venue = venue;
      if (!$scope.credential) {
        $scope.credential = {
          type: 'PIN'
        };
      }
      $scope.roles = [
        {
          group: {
            name: 'MERCHANT_ADMINISTRATORS'
          },
          label: 'Merchant admin'
        }
      ];
      $scope.isInGroup = function(employee, groupName) {
        return EmployeeService.isInGroup(employee, groupName);
      };
      if ($scope.isInGroup(employee, 'MERCHANT_EMPLOYEE')) {
        $scope.roles.push({
          group: {
            name: 'MERCHANT_EMPLOYEE'
          },
          label: 'Staff'
        });
      }
      if ($scope.isInGroup(employee, 'VENUE_EMPLOYEE')) {
        $scope.roles.push({
          group: {
            name: 'VENUE_EMPLOYEE'
          },
          label: 'Staff'
        });
      }
      if ($scope.isInGroup(employee, 'PLATFORM_ADMINISTRATORS')) {
        $scope.roles.push({
          group: {
            name: 'PLATFORM_ADMINISTRATORS'
          },
          label: 'Global admin'
        });
      }
      $scope.switchEmployeeType = function(employeeType) {
        $scope.employee["type"] = employeeType;
        if (employeeType === 'Venue') {
          return $scope.employee.venueId = $scope.venues[0].id;
        } else {
          return delete $scope.employee.venueId;
        }
      };
      $scope.isVenueStaffMember = function(employee) {
        return ($scope.employee.venueId != null) && angular.isNumber(parseInt($scope.employee.venueId));
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
      $scope.updateCredentials = function(employee, credential, callback) {
        var errorCallback, newCredential;
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
            console.error("failed to delete credential", status, response);
            $scope.error = "" + response.reference + ": " + response.message;
            return delete $scope.locked;
          });
        } else {
          return callback();
        }
      };
      $scope.showMessage = function(messageText) {
        var message;
        MessagingService.resetMessages();
        message = MessagingService.createMessage("success", messageText, 'GlobalErrors');
        MessagingService.addMessage(message);
        return MessagingService.hasMessages('GlobalErrors');
      };
      $scope.reset = function() {
        MessagingService.resetMessages();
        ValidationService.reset();
        if ($scope.employee.id != null) {
          return EmployeeService.getById($scope.employee.id).then(function(response) {
            return $scope.employee = response;
          });
        } else {
          return $scope.employee = EmployeeService["new"]();
        }
      };
      $scope.save = function(redirect) {
        var credential;
        MessagingService.resetMessages();
        ValidationService.reset();
        ValidationService.validate('Employee');
        if (!MessagingService.hasMessages('Employee').length) {
          $scope.locked = true;
          employee = $scope.employee;
          credential = $scope.credential;
          return EmployeeService.save(employee, credential);
        }
      };
      $scope.cancel = function() {
        delete $scope.employee;
        delete $scope.credential;
        return delete $scope.error;
      };
      $scope.showDataChangedMessage = function() {
        var message;
        MessagingService.resetMessages();
        message = MessagingService.createMessage("warning", "Your employee data has changed. Don't forget to press the 'Save' button.", 'Employee');
        MessagingService.addMessage(message);
        return MessagingService.hasMessages('Employee');
      };
      $scope.findNextElemByTabIndex = function(tabIndex) {
        var matchedElement;
        matchedElement = angular.element(document.querySelector("[tabindex='" + tabIndex + "']"));
        return matchedElement;
      };
      $scope.moveToNextTabIndex = function($event, $editable) {
        var currentElem, nextElem;
        currentElem = $editable;
        nextElem = [];
        if (currentElem.attrs.nexttabindex != null) {
          nextElem = $scope.findNextElemByTabIndex(currentElem.attrs.nexttabindex);
        }
        currentElem.save();
        currentElem.hide();
        if (nextElem.length) {
          return $timeout(function() {
            return nextElem.click();
          }, 10);
        }
      };
      return $scope.keypressCallback = function($event, $editable) {
        var currentElem, nextElem;
        currentElem = $editable;
        nextElem = [];
        if (currentElem.attrs.nexttabindex != null) {
          nextElem = $scope.findNextElemByTabIndex(currentElem.attrs.nexttabindex);
        }
        if ($event.which === 9) {
          $event.preventDefault();
          currentElem.save();
          currentElem.hide();
          if (nextElem.length) {
            $timeout(function() {
              return nextElem.click();
            }, 10);
          }
        }
        if ($event.which === 13) {
          $event.preventDefault();
          currentElem.save();
          return currentElem.hide();
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=employees-form-controller.js.map
