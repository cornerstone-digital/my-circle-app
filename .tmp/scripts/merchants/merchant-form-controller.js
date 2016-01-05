(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('MerchantFormCtrl', [
    '$rootScope', '$scope', '$location', '$timeout', '$http', 'merchant', 'venues', 'employees', 'Auth', 'VenueService', 'EmployeeService', 'MerchantService', 'MessagingService', 'ValidationService', function($rootScope, $scope, $location, $timeout, $http, merchant, venues, employees, Auth, VenueService, EmployeeService, MerchantService, MessagingService, ValidationService) {
      var addStaffBtn, cancelBtn, cancelSaveBtn, deleteAlert, deleteStaffBtn, employeeDatasource, saveAlert, saveBtn;
      $scope.merchant = merchant;
      $scope.venues = venues;
      $scope.employees = employees;
      saveBtn = $('.save-btn');
      addStaffBtn = $('.add-staff-btn');
      deleteStaffBtn = $('.delete-staff-btn');
      deleteAlert = $('.delete-alert');
      cancelSaveBtn = $('.cancel-save-btn');
      cancelBtn = $('.cancel-btn');
      deleteAlert = $('.delete-alert');
      saveAlert = $('.save-alert');
      $scope.selectedItems = [];
      saveBtn.show();
      addStaffBtn.hide();
      deleteStaffBtn.hide();
      $scope.showMessage = function(messageText) {
        var message;
        MessagingService.resetMessages();
        message = MessagingService.createMessage("success", messageText, 'Venue');
        MessagingService.addMessage(message);
        return MessagingService.hasMessages('Venue');
      };
      $scope.cancelBtnClick = function() {
        saveAlert.hide();
        return console.log("cancel btn clicked");
      };
      $scope.cancelSaveBtnClick = function() {
        return $scope.safeApply(function() {
          saveAlert.hide();
          $scope.dataChanged = false;
          return window.location = $scope.nextURL;
        });
      };
      $scope.onSelect = function(e) {
        var tabText;
        tabText = $(e.item).find("> .k-link").text();
        if (tabText === 'Merchant') {
          saveBtn.show();
          addStaffBtn.hide();
          deleteStaffBtn.hide();
        }
        if (tabText === 'Staff') {
          saveBtn.hide();
          addStaffBtn.show();
          deleteStaffBtn.show();
        }
      };
      $scope.countries = [
        {
          id: 232,
          numericCode: 826,
          name: 'United Kingdom'
        }, {
          id: 233,
          numericCode: 840,
          name: 'United States'
        }
      ];
      employeeDatasource = new kendo.data.DataSource({
        data: $scope.employees,
        pageSize: 10,
        serverPaging: false,
        serverSorting: false
      });
      $scope.employeeGridOptions = {
        dataSource: employeeDatasource,
        sortable: true,
        pageable: true,
        filterable: true,
        columns: [
          {
            field: "check_row",
            title: " ",
            width: 30,
            template: "<input data-ng-click='checkboxClicked(this)' class='check_row' type='checkbox' />",
            filterable: false
          }, {
            field: "firstname",
            title: "First name"
          }, {
            field: "lastname",
            title: "Last name"
          }, {
            field: "displayName",
            title: "Display name"
          }, {
            template: "<input type=\"button\" class=\"icon icon-lg edit-icon ng-scope\" ng-click=\"editEmployee(#=id#)\" data-requires-permission=\"PERM_MERCHANT_ADMINISTRATOR\" value=\"Edit\">",
            title: "Actions",
            width: "70px"
          }
        ]
      };
      $scope.checkboxClicked = function(e) {
        var cb, row;
        row = $("[data-uid='" + e.dataItem.uid + "']");
        cb = row.find("input");
        if (cb.is(':checked')) {
          return $scope.selectedItems.push(e.dataItem.id);
        } else {
          return $scope.selectedItems = _.without($scope.selectedItems, e.dataItem.id);
        }
      };
      $scope.addEmployee = function() {
        return $location.path("employees/add");
      };
      $scope.deleteEmployees = function() {
        if ($scope.selectedItems.length) {
          deleteAlert.hide();
          return EmployeeService.bulkDeleteMerchantEmployees($scope.selectedItems, merchant.id).then(function(response) {
            return EmployeeService.getGridList().then(function(employees) {
              $scope.showMessage("Delete Successful");
              $scope.employees = employees;
              if ($scope.employees.length) {
                return $('#merchantEmployeesGrid').data("kendoGrid").dataSource.data(employees);
              }
            });
          });
        } else {
          return deleteAlert.show();
        }
      };
      $scope.editEmployee = function(employeeId) {
        return $location.path("employees/edit/" + employeeId);
      };
      $scope.editVenue = function(venueId) {
        return $location.path("venues/edit/" + venueId);
      };
      $scope.showMessage = function(messageText) {
        var message;
        MessagingService.resetMessages();
        message = MessagingService.createMessage("success", messageText, 'Merchant');
        MessagingService.addMessage(message);
        return MessagingService.hasMessages('Merchant');
      };
      $scope.reset = function() {
        MessagingService.resetMessages();
        ValidationService.reset();
        if ($scope.merchant.id != null) {
          return MerchantService.getById($scope.merchant.id).then(function(response) {
            return $scope.merchant = response;
          });
        } else {
          return $scope.merchant = MerchantService["new"]();
        }
      };
      $scope.save = function(redirect) {
        var _ref, _ref1;
        MessagingService.resetMessages();
        ValidationService.reset();
        ValidationService.validate('Merchant');
        if (!MessagingService.hasMessages('Merchant').length) {
          $scope.locked = true;
          merchant = $scope.merchant;
          if (!(merchant != null ? merchant.id : void 0) && ((_ref = merchant.employees) != null ? (_ref1 = _ref[0].credentials) != null ? _ref1[0] : void 0 : void 0)) {
            merchant.employees[0].credentials[0].uid = merchant.employees[0].email;
          }
          return MerchantService.save(merchant).then(function(response) {
            $scope.showMessage("Save Successful");
            $scope.locked = false;
            $scope.merchant = response;
            return $scope.dataChanged = false;
          }, function(response) {
            console.error('update failed');
            return $scope.locked = false;
          });
        } else {

        }
      };
      $scope.showDataChangedMessage = function() {
        return $scope.dataChanged = true;
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
      $scope.keypressCallback = function($event, $editable) {
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
      return $scope.$on('$locationChangeStart', function(event, next, current) {
        if ($scope.dataChanged) {
          $scope.nextURL = next;
          event.preventDefault();
          return saveAlert.show();
        }
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=merchant-form-controller.js.map
