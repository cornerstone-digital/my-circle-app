(function() {
  angular.module('smartRegisterApp').factory('POSService', [
    '$rootScope', 'ResourceNoPaging', 'SettingsService', 'Auth', function($rootScope, ResourceNoPaging, SettingsService, Auth) {
      return {
        getList: function(venueId, params) {
          var _ref, _ref1, _ref2;
          venueId = venueId != null ? venueId : (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.venue) != null ? _ref1.id : void 0 : void 0;
          params = params != null ? params : {};
          return ResourceNoPaging.one("merchants", (_ref2 = Auth.getMerchant()) != null ? _ref2.id : void 0).one("venues", venueId).getList("pos", params);
        },
        getById: function(posId) {
          var _ref;
          return ResourceNoPaging.one("merchants", (_ref = Auth.getMerchant()) != null ? _ref.id : void 0).one("venues", venueId).one("pos", posId).get();
        },
        getByName: function(name) {
          return this.getList().then(function(response) {
            return _.filter(response, function(it) {
              return it.name === name;
            });
          });
        },
        getPosValues: function(venueId, params) {
          var _ref, _ref1, _ref2;
          venueId = venueId != null ? venueId : (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.venue) != null ? _ref1.id : void 0 : void 0;
          params = params != null ? params : {};
          return ResourceNoPaging.one("merchants", (_ref2 = Auth.getMerchant()) != null ? _ref2.id : void 0).one("venues", venueId).one("pos").one("values").get(params);
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=pos-service.js.map
