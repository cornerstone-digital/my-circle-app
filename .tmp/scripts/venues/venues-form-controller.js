(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('VenueFormCtrl', [
    '$rootScope', '$scope', '$location', '$timeout', 'Config', 'venue', 'employees', 'discounts', 'VenueService', 'EmployeeService', 'DiscountService', 'MessagingService', 'ValidationService', function($rootScope, $scope, $location, $timeout, Config, venue, employees, discounts, VenueService, EmployeeService, DiscountService, MessagingService, ValidationService) {
      var addDiscountBtn, addStaffBtn, cancelBtn, cancelSaveBtn, deleteAlert, deleteDiscountBtn, deleteStaffBtn, saveAlert, saveBtn, venueDiscountsGrid, venueEmployeesGrid, _ref, _ref1, _ref2, _ref3;
      $scope.venue = venue;
      $scope.employees = employees;
      $scope.discounts = discounts;
      saveBtn = $('.save-btn');
      addStaffBtn = $('.add-staff-btn');
      deleteStaffBtn = $('.delete-staff-btn');
      addDiscountBtn = $('.add-discount-btn');
      deleteDiscountBtn = $('.delete-discount-btn');
      cancelSaveBtn = $('.cancel-save-btn');
      cancelBtn = $('.cancel-btn');
      deleteAlert = $('.delete-alert');
      saveAlert = $('.save-alert');
      venueEmployeesGrid = $('#venueEmployeesGrid');
      venueDiscountsGrid = $('#venueDiscountsGrid');
      $scope.selectedItems = [];
      saveBtn.show();
      addStaffBtn.hide();
      deleteStaffBtn.hide();
      addDiscountBtn.hide();
      deleteDiscountBtn.hide();
      $scope.cancelBtnClick = function() {
        saveAlert.hide();
        return console.log("cancel btn clicked");
      };
      $scope.cancelSaveBtnClick = function() {
        $scope.safeApply(function() {
          $scope.dataChanged = false;
          saveAlert.hide();
          return window.location = $scope.nextURL;
        });
      };
      $scope.onSelect = function(e) {
        var tabText;
        tabText = $(e.item).find("> .k-link").text();
        deleteAlert.hide();
        saveAlert.hide();
        if (tabText === 'Venue') {
          saveBtn.show();
          addStaffBtn.hide();
          deleteStaffBtn.hide();
          addDiscountBtn.hide();
          deleteDiscountBtn.hide();
        }
        if (tabText === 'Staff') {
          saveBtn.hide();
          addStaffBtn.show();
          deleteStaffBtn.show();
          addDiscountBtn.hide();
          deleteDiscountBtn.hide();
        }
        if (tabText === 'Discounts') {
          saveBtn.hide();
          addStaffBtn.hide();
          deleteStaffBtn.hide();
          addDiscountBtn.show();
          deleteDiscountBtn.show();
        }
      };
      if (!$scope.venue.contacts) {
        $scope.venue.contacts = [];
      }
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
      $scope.name = (_ref = VenueService.getVenueContactByType(venue, 'NAME')) != null ? _ref : {};
      $scope.phone = (_ref1 = VenueService.getVenueContactByType(venue, 'PHONE')) != null ? _ref1 : {};
      $scope.email = (_ref2 = VenueService.getVenueContactByType(venue, 'EMAIL')) != null ? _ref2 : {};
      $scope.venue.sections = (_ref3 = $scope.venue.sections) != null ? _ref3 : [];
      $scope.employeeGridOptions = {
        dataSource: {
          data: $scope.employees,
          pageSize: 10,
          serverPaging: false,
          serverSorting: false
        },
        sortable: true,
        pageable: true,
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
            field: "active",
            title: "Active"
          }, {
            template: "<button data-kendo-button data-ng-click=\"editEmployee(#=id#)\">Edit</button>",
            title: "",
            width: "100px"
          }
        ]
      };
      $scope.discountGridOptions = {
        dataSource: {
          data: $scope.discounts,
          pageSize: 10,
          serverPaging: false,
          serverSorting: false
        },
        sortable: true,
        pageable: true,
        columns: [
          {
            field: "check_row",
            title: " ",
            width: 30,
            template: "<input data-ng-click='singleCheckboxClicked(this)' class='check_row' type='checkbox' />",
            filterable: false
          }, {
            field: "name",
            title: "Name"
          }, {
            field: "value",
            title: "Value",
            template: "#=value * 100#\\%"
          }, {
            template: "<button data-kendo-button data-ng-click=\"editDiscount(#=id#)\">Edit</button>",
            title: "",
            width: "100px"
          }
        ]
      };
      $scope.resetChecked = function() {
        $('input[type="checkbox"').prop("checked", false);
        return $scope.selectedItems = [];
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
      $scope.singleCheckboxClicked = function(e) {
        var cb, row;
        row = $("[data-uid='" + e.dataItem.uid + "']");
        cb = row.find("input");
        if (cb.is(':checked')) {
          $('input[type="checkbox"').prop("checked", false);
          cb.prop("checked", true);
          return $scope.selectedItems.push(e.dataItem.id);
        } else {
          return $scope.selectedItems = [];
        }
      };
      $scope.editEmployee = function(employeeId) {
        return $location.path("venues/" + venue.id + "/employees/edit/" + employeeId);
      };
      $scope.editDiscount = function(discountId) {
        return $location.path("discounts/edit/" + discountId);
      };
      $scope.addEmployee = function() {
        return $location.path("venues/" + venue.id + "/employees/add");
      };
      $scope.deleteEmployees = function() {
        if ($scope.selectedItems.length) {
          deleteAlert.hide();
          return EmployeeService.bulkDeleteVenueEmployees($scope.selectedItems, venue.id).then(function(response) {
            return EmployeeService.getGridListByVenue(venue).then(function(employees) {
              $scope.showMessage("Delete Successful");
              $scope.employees = employees;
              if ($scope.employees.length) {
                return $('#venueEmployeesGrid').data("kendoGrid").dataSource.data(employees);
              }
            });
          });
        } else {
          return deleteAlert.show();
        }
      };
      $scope.addDiscount = function() {
        return $location.path("discounts/add");
      };
      $scope.deleteDiscounts = function() {
        if ($scope.selectedItems.length) {
          deleteAlert.hide();
          return angular.forEach($scope.selectedItems, function(id, index) {
            return DiscountService.getById(id).then(function(discount) {
              return DiscountService.remove(discount).then(function(response) {
                return DiscountService.getList().then(function(discounts) {
                  $scope.showMessage("Delete Successful");
                  $scope.discounts = discounts;
                  if ($scope.discounts.length) {
                    return $('#venueDiscountsGrid').data("kendoGrid").dataSource.data(discounts);
                  }
                });
              });
            });
          });
        } else {
          deleteAlert.css("right", "305px");
          return deleteAlert.show();
        }
      };
      $scope.updateVenueCountry = function() {
        return $scope.venue.address.country = {
          numericCode: $scope.venue.address.country.numericCode
        };
      };
      $scope.addSection = function(section, $event) {
        var error;
        MessagingService.resetMessages();
        ValidationService.reset();
        ValidationService.validate('Sections');
        if ((VenueService.isExistingSection($scope.venue, section).length)) {
          error = MessagingService.createMessage("error", "A section with that name already exists.", 'Sections');
          MessagingService.addMessage(error);
        }
        if (!MessagingService.hasMessages('Sections').length) {
          $scope.venue.sections.push({
            name: section
          });
          delete $scope.newSection;
          return $scope.showDataChangedMessage();
        }
      };
      $scope.deleteSection = function(section) {
        var index;
        section = VenueService.getSectionById($scope.venue, section.id);
        index = $scope.venue.sections.indexOf(section);
        $scope.venue.sections.splice(index, 1);
        return $scope.showDataChangedMessage();
      };
      $scope.reset = function() {
        MessagingService.resetMessages();
        ValidationService.reset();
        if ($scope.venue.id != null) {
          return VenueService.getById($scope.venue.id).then(function(response) {
            return $scope.venue = response;
          });
        } else {
          return $scope.venue = VenueService["new"]();
        }
      };
      $scope.showMessage = function(messageText) {
        var message;
        MessagingService.resetMessages();
        message = MessagingService.createMessage("success", messageText, 'Venue');
        MessagingService.addMessage(message);
        return MessagingService.hasMessages('Venue');
      };
      $scope.showDataChangedMessage = function() {
        return $scope.dataChanged = true;
      };
      $scope.save = function(redirect) {
        var hasEmail, hasName, hasPhone, _ref4, _ref5;
        MessagingService.resetMessages();
        ValidationService.reset();
        ValidationService.validate('Venue');
        if (!MessagingService.hasMessages('Venue').length) {
          hasName = VenueService.getVenueContactByType($scope.venue, 'NAME');
          hasPhone = VenueService.getVenueContactByType($scope.venue, 'PHONE');
          hasEmail = VenueService.getVenueContactByType($scope.venue, 'EMAIL');
          if (!hasName) {
            if ($scope.name.value != null) {
              $scope.name.type = 'NAME';
              if ((_ref4 = $scope.venue) != null) {
                _ref4.contacts.push($scope.name);
              }
            }
          }
          if (!hasPhone) {
            if ($scope.phone.value != null) {
              $scope.phone.type = 'PHONE';
              if ((_ref5 = $scope.venue) != null) {
                _ref5.contacts.push($scope.phone);
              }
            }
          }
          if (!hasEmail) {
            if (($scope.email.value != null)) {
              $scope.email.type = 'EMAIL';
              $scope.venue.contacts.push($scope.email);
            }
          }
          return VenueService.save($scope.venue).then(function(response) {
            $scope.locked = false;
            $scope.venue = response;
            $location.path("/venues");
            $scope.dataChanged = false;
            return true;
          }, function(response) {
            console.error('update failed');
            return $scope.locked = false;
          });
        }
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
      $scope.validateEmail = function(email) {
        var message;
        if (email.length && !ValidationService.isEmail(email)) {
          MessagingService.resetMessages();
          message = MessagingService.createMessage("error", "'" + email + "' is not a valid email address.", 'Venue');
          MessagingService.addMessage(message);
          return MessagingService.hasMessages('Venue');
        }
      };
      $scope.validatePostcode = function(postcode) {
        var message;
        if (postcode.length && !ValidationService.isPostcode(postcode)) {
          MessagingService.resetMessages();
          message = MessagingService.createMessage("error", "'" + postcode + "' is not a valid postcode.", 'Venue');
          MessagingService.addMessage(message);
          return MessagingService.hasMessages('Venue');
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

//# sourceMappingURL=venues-form-controller.js.map
