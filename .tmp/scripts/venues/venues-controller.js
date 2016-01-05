(function() {
  'use strict';
  angular.module('smartRegisterApp').controller('VenuesCtrl', [
    '$rootScope', '$document', '$http', '$location', '$route', '$scope', 'venues', 'Auth', 'VenueService', 'SettingsService', 'MessagingService', function($rootScope, $document, $http, $location, $route, $scope, venues, Auth, VenueService, SettingsService, MessagingService) {
      var deleteAlert;
      deleteAlert = $('.delete-alert');
      $scope.venues = venues;
      $scope.selectedItems = [];
      $scope.venuesGridOptions = {
        dataSource: {
          data: $scope.venues,
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
            field: "postcode",
            title: "Postcode"
          }, {
            field: "email",
            title: "Email"
          }, {
            field: "phone",
            title: "Phone"
          }, {
            template: "<button data-kendo-button data-ng-click=\"editVenue(#=id#)\">Edit</button>",
            title: "",
            width: "100px"
          }
        ]
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
      $rootScope.errors = {
        venue: []
      };
      $scope.deleteVenues = function() {
        if ($scope.selectedItems.length) {
          deleteAlert.hide();
          return VenueService.getById($scope.selectedItems[0]).then(function(venue) {
            return VenueService.remove(venue).then(function(response) {
              return VenueService.getGridList().then(function(venues) {
                $scope.showMessage("Delete Successful");
                $scope.venues = venues;
                if ($scope.venues.length) {
                  $('#venuesGrid').data("kendoGrid").dataSource.data(venues);
                  return $scope.selectedItems = [];
                }
              });
            });
          });
        } else {
          return deleteAlert.show();
        }
      };
      $scope.getVenueContactByType = function(venue, type) {
        var _ref, _ref1;
        if (((_ref = VenueService.getVenueContactByType(venue, type)) != null ? _ref.value : void 0) != null) {
          return (_ref1 = VenueService.getVenueContactByType(venue, type)) != null ? _ref1.value : void 0;
        } else {
          return null;
        }
      };
      $scope.confirmedDelete = function(venue) {
        return $scope.venuesToDelete = [venue];
      };
      $scope.closeConfirm = function() {
        return delete $scope.venuesToDelete;
      };
      $scope.confirmYes = function() {
        $scope.remove($scope.venuesToDelete[0]);
        return $scope.closeConfirm();
      };
      $scope.resetChecked = function() {
        $('input[type="checkbox"').prop("checked", false);
        return $scope.checkedVenues = [];
      };
      $scope.resetErrors = function() {
        return $rootScope.errors.venue = [];
      };
      $scope.updateCheckboxStatus = function(venue) {
        var venueCheckbox;
        $scope.resetChecked();
        venueCheckbox = $('#venueCheckbox' + venue.id);
        venueCheckbox.prop("checked", !venueCheckbox.prop("checked"));
        return $scope.checkedVenues.push(venue.id);
      };
      $scope.showMessage = function(messageText) {
        var message;
        MessagingService.resetMessages();
        message = MessagingService.createMessage("success", messageText, 'Venue');
        MessagingService.addMessage(message);
        return MessagingService.hasMessages('Venue');
      };
      $scope.create = function() {
        return $location.path('/venues/add');
      };
      $scope.duplicateVenue = function() {
        $scope.resetErrors();
        if ($scope.selectedItems.length && $scope.selectedItems.length === 1) {
          return VenueService.getById($scope.selectedItems[0]).then(function(venue) {
            return $scope.duplicate(venue);
          });
        } else if ($scope.selectedItems.length > 1) {
          return $scope.errors.venue.push("You can only duplicate 1 venue at a time.");
        } else if ($scope.selectedItems.length === 0) {
          return $scope.errors.venue.push("Please select a venue to duplicate");
        }
      };
      $scope.duplicate = function(venue) {
        return $scope.$broadcast('venue:duplicate', venue);
      };
      $scope.editVenue = function(venueId) {
        return $location.path("/venues/edit/" + venueId);
      };
      $scope.editVenueProducts = function(venue) {
        return $scope.$broadcast('venue:editProducts', venue);
      };
      $scope.remove = function(venue) {
        return VenueService.remove(venue).then(function() {
          return VenueService.getList().then(function(venues) {
            return $scope.venues = venues;
          });
        }, function() {
          console.error("could not delete", venue);
          return $scope.$broadcast("delete:failed", venue);
        });
      };
      $scope.hasErrors = function() {
        if (angular.isDefined($rootScope.errors)) {
          return true;
        } else {
          return false;
        }
      };
      $scope.hasMultipleVenues = function() {
        if ($scope.venues != null) {
          if ($scope.venues.length > 1) {
            return true;
          } else {
            return false;
          }
        }
      };
      $scope.canAddVenue = function() {
        return VenueService.canAddVenue();
      };
      $scope.canDuplicateVenues = function() {
        return Auth.hasRole('PERM_MERCHANT_ADMINISTRATOR');
      };
      $scope.canDeleteVenues = function() {
        if (Auth.hasRole('PERM_MERCHANT_ADMINISTRATOR') && $scope.hasMultipleVenues()) {
          return true;
        } else {
          return false;
        }
      };
      $scope.$on('delete:succeeded', function() {
        return $route.reload();
      });
      $scope.$on('delete:requested', function(event, venue) {
        return $scope["delete"](venue);
      });
      $scope.$on('venue:saved', function(event, response) {
        return VenueService.getList().then(function(response) {
          return $scope.venues = response;
        });
      });
      $scope.$on('venue:created', function(event, venue) {
        return $scope.venues.push(venue);
      });
      $scope.$on('venue:updated', function(event, venue) {
        var index, _i, _ref, _results;
        _results = [];
        for (index = _i = 0, _ref = $scope.venues.length; 0 <= _ref ? _i < _ref : _i > _ref; index = 0 <= _ref ? ++_i : --_i) {
          if ($scope.venues[index].id === venue.id) {
            _results.push($scope.venues[index] = angular.copy(venue));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      });
      $scope.$on('venue:editProducts', function(event, venue) {
        $rootScope.credentials.venue = angular.copy(venue);
        $scope.productsForCategory = $scope.products;
        return $location.path('/products');
      });
      return $scope.$on('venue:duplicate', function(event, venue) {
        return VenueService.getById(venue.id, {
          full: true
        }).then(function(fullVenue) {
          return VenueService.duplicate(fullVenue).then(function(duplicateVenue) {
            $scope.$broadcast('venue:created', duplicateVenue);
            return VenueService.getGridList().then(function(venues) {
              $scope.venues = venues;
              if ($scope.venues.length) {
                $('#venuesGrid').data("kendoGrid").dataSource.data(venues);
                $scope.selectedItems = [];
                return $scope.showMessage("Duplication Successful");
              }
            });
          });
        });
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=venues-controller.js.map
