(function() {
  angular.module('smartRegisterApp').factory('VenueService', [
    '$rootScope', 'ResourceNoPaging', 'SettingsService', 'Auth', function($rootScope, ResourceNoPaging, SettingsService, Auth) {
      return {
        "new": function() {
          var venue, _ref;
          venue = ResourceNoPaging.one("merchants", (_ref = $rootScope.credentials.merchant) != null ? _ref.id : void 0).one("venues");
          venue.address = {
            country: {
              numericCode: 826
            },
            isAddressFor: 'ALL'
          };
          venue.contacts = [
            {
              type: 'PHONE'
            }
          ];
          venue.sections = [];
          return venue;
        },
        getVenueContactByType: function(venue, type) {
          return _.find(venue.contacts, function(it) {
            return it.type === type;
          });
        },
        getSectionById: function(venue, sectionId) {
          return _.find(venue.sections, function(it) {
            return it.id === sectionId;
          });
        },
        isExistingSection: function(venue, name) {
          return _.filter(venue.sections, function(it) {
            return it.name === name;
          });
        },
        getGridList: function(merchantId, params) {
          var gridList, _ref, _ref1;
          merchantId = merchantId != null ? merchantId : (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.merchant) != null ? _ref1.id : void 0 : void 0;
          params = params != null ? params : {};
          gridList = [];
          return ResourceNoPaging.one("merchants", merchantId).getList("venues", params).then(function(venues) {
            angular.forEach(venues, function(venue, index) {
              var email, gridRow, phone, _ref2, _ref3;
              email = _.find(venue.contacts, function(it) {
                var _ref2;
                return (_ref2 = it.type === "EMAIL") != null ? _ref2 : "";
              });
              phone = _.find(venue.contacts, function(it) {
                var _ref2;
                return (_ref2 = it.type === "PHONE") != null ? _ref2 : "";
              });
              gridRow = {
                id: venue.id,
                name: venue.name,
                postcode: venue.address.postCode,
                email: (_ref2 = email != null ? email.value : void 0) != null ? _ref2 : "",
                phone: (_ref3 = phone != null ? phone.value : void 0) != null ? _ref3 : ""
              };
              return gridList.push(gridRow);
            });
            return gridList;
          });
        },
        getList: function(merchantId, params) {
          var _ref, _ref1;
          merchantId = merchantId != null ? merchantId : (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.merchant) != null ? _ref1.id : void 0 : void 0;
          params = params != null ? params : {};
          return ResourceNoPaging.one("merchants", merchantId).all("venues").getList(params);
        },
        getById: function(venueId, params) {
          var venue, _ref, _ref1, _ref2, _ref3;
          venueId = venueId != null ? venueId : (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.venue) != null ? _ref1.id : void 0 : void 0;
          params = params != null ? params : {
            full: true
          };
          venue = null;
          return ResourceNoPaging.one("merchants", (_ref2 = $rootScope.credentials) != null ? (_ref3 = _ref2.merchant) != null ? _ref3.id : void 0 : void 0).one("venues", venueId).get(params).then(function(response) {
            venue = response;
            if (!venue.sections) {
              venue.sections = [];
            }
            return venue;
          });
        },
        getVenueCategories: function(venueId, params) {
          var _ref, _ref1, _ref2, _ref3;
          venueId = venueId != null ? venueId : (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.venue) != null ? _ref1.id : void 0 : void 0;
          params = params != null ? params : {};
          return ResourceNoPaging.one("merchants", (_ref2 = $rootScope.credentials) != null ? (_ref3 = _ref2.merchant) != null ? _ref3.id : void 0 : void 0).one("venues", venueId).getList("categories", params);
        },
        getVenueSections: function(venueId) {
          return this.getById(venueId).then(function(response) {
            return response != null ? response.sections : void 0;
          });
        },
        getVenueProducts: function(venueId, params) {
          var _ref, _ref1, _ref2, _ref3;
          venueId = venueId != null ? venueId : (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.venue) != null ? _ref1.id : void 0 : void 0;
          params = params != null ? params : {};
          return ResourceNoPaging.one("merchants", (_ref2 = $rootScope.credentials) != null ? (_ref3 = _ref2.merchant) != null ? _ref3.id : void 0 : void 0).one("venues", venueId).getList("products", params);
        },
        getVenueProductsByCategory: function(venueId, categoryId, params) {
          var _ref, _ref1, _ref2, _ref3;
          venueId = venueId != null ? venueId : (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.venue) != null ? _ref1.id : void 0 : void 0;
          params = params != null ? params : {};
          return ResourceNoPaging.one("merchants", (_ref2 = $rootScope.credentials) != null ? (_ref3 = _ref2.merchant) != null ? _ref3.id : void 0 : void 0).one("venues", venueId).one("categories", categoryId).getList("products", params);
        },
        save: function(venue) {
          var _ref, _ref1;
          if (venue.id) {
            venue = ResourceNoPaging.copy(venue);
            return venue.save();
          } else {
            return ResourceNoPaging.one("merchants", (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.merchant) != null ? _ref1.id : void 0 : void 0).post("venues", venue);
          }
        },
        remove: function(venue) {
          venue = ResourceNoPaging.copy(venue);
          return venue.remove();
        },
        canAddVenue: function() {
          return SettingsService.hasModuleEnabled('multivenue') && Auth.hasRole('PERM_MERCHANT_ADMINISTRATOR');
        },
        duplicate: function(venue) {
          var venueId, _ref, _ref1, _ref2, _ref3, _ref4;
          venueId = (_ref = venue != null ? venue.id : void 0) != null ? _ref : (_ref1 = $rootScope.credentials) != null ? (_ref2 = _ref1.venue) != null ? _ref2.id : void 0 : void 0;
          return ResourceNoPaging.one("merchants", (_ref3 = $rootScope.credentials) != null ? (_ref4 = _ref3.merchant) != null ? _ref4.id : void 0 : void 0).one("venues", venueId).customPOST("", "clone");
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=venue-service.js.map
