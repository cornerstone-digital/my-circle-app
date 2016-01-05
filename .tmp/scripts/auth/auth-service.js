(function() {
  'use strict';

  /*
  Service for authenticating users and verifying they are logged in.
   */
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  angular.module('smartRegisterApp').factory('Auth', [
    '$http', '$rootScope', '$location', '$timeout', 'Config', 'Venue', 'ResourceNoPaging', 'locale', function($http, $rootScope, $location, $timeout, Config, Venue, ResourceNoPaging, locale) {

      /*
      The object that holds information about the logged in user
       */
      var storeVenueDetails;
      $rootScope.credentials = null;
      $rootScope.unsecured = ['forgottenPassword', 'resetToken'];
      $rootScope.$watch('credentials', function(value) {
        if (value != null) {
          localStorage.setItem('credentials', JSON.stringify(value));
        } else {
          localStorage.removeItem('credentials');
        }
        return $rootScope.$broadcast('auth:updated');
      }, true);
      storeVenueDetails = function(venue) {
        $rootScope.credentials.venue = venue;
        $rootScope.credentials.tools = [];
        return _.each(venue.smartTools, function(tool) {
          if (tool.groups.length > 0) {
            return $rootScope.credentials.tools.push(tool.appId);
          }
        });
      };
      return {

        /*
        Is a user logged in? This is determined by the presence of a credentials object in localStorage.
         */
        isLoggedIn: function() {
          return $rootScope.credentials != null;
        },
        isSecured: function() {
          return !$rootScope.unsecured.indexOf($location.$$path);
        },
        isMemberOf: function(groupName) {
          var groups, _ref, _ref1;
          groups = (_ref = (_ref1 = $rootScope.credentials) != null ? _ref1.groups : void 0) != null ? _ref : [];
          return __indexOf.call(groups, groupName) >= 0;
        },
        hasRole: function(permission) {
          var permissions, _ref, _ref1;
          permissions = (_ref = (_ref1 = $rootScope.credentials) != null ? _ref1.permissions : void 0) != null ? _ref : [];
          return __indexOf.call(permissions, permission) >= 0 || __indexOf.call(permissions, 'PERM_DEVELOPER') >= 0;
        },
        hasTool: function(toolId) {
          var tools, _ref, _ref1;
          tools = (_ref = (_ref1 = $rootScope.credentials) != null ? _ref1.tools : void 0) != null ? _ref : [];
          return __indexOf.call(tools, toolId) >= 0;
        },

        /*
        Log in via the /authenticate endpoint in the API.
         */
        login: function(user, successCallback, errorCallback) {
          var authHeader;
          authHeader = btoa("" + user.email + ":" + user.password);
          return $http.get("api://api/merchants/authenticate", {
            headers: {
              Authorization: "Basic " + authHeader
            }
          }).success((function(_this) {
            return function(data) {
              var _ref;
              $rootScope.credentials = {
                username: data.employee.displayName,
                email: user.email,
                token: data.sessionId,
                merchant: {
                  id: data.merchantId
                },
                permissions: _.flatten((_ref = data.employee.groups) != null ? _ref.map(function(group) {
                  var permissions, _ref1;
                  permissions = (_ref1 = group.authorities) != null ? _ref1.map(function(it) {
                    return it.permission;
                  }) : void 0;
                  return permissions != null ? permissions : [];
                }) : void 0),
                groups: _.pluck(data.employee.groups, 'name')
              };
              return $timeout(function() {
                var permissions, _ref1, _ref2;
                ResourceNoPaging.one("merchants", data.merchantId).getList("venues", {
                  full: false
                }).then(function(venues) {
                  if (venues.length) {
                    storeVenueDetails(venues[0]);
                    $rootScope.credentials.venues = venues;
                    return successCallback($rootScope.credentials);
                  } else {
                    $rootScope.credentials = null;
                    return errorCallback('Merchant has no venues');
                  }
                });
                permissions = (_ref1 = (_ref2 = $rootScope.credentials) != null ? _ref2.permissions : void 0) != null ? _ref1 : [];
                if (__indexOf.call(permissions, 'PERM_PLATFORM_ADMINISTRATOR') >= 0 || __indexOf.call(permissions, 'PERM_DEVELOPER') >= 0) {
                  return ResourceNoPaging.all("merchants").all("list").getList().then(function(merchants) {
                    if (merchants.length) {
                      return $rootScope.merchants = merchants;
                    } else {
                      $rootScope.credentials = null;
                      return errorCallback('Merchant has no venues');
                    }
                  });
                }
              });
            };
          })(this)).error(function(data, status) {
            return errorCallback(status === 401 ? 'Incorrect username or password' : 'Login failed');
          });
        },
        logout: function() {
          return $http.get("api://api/merchants/logout").success(function() {
            $rootScope.credentials = null;
            return $location.path('/login');
          }).error(function() {
            $rootScope.credentials = null;
            return $location.path('/login');
          });
        },
        getVenue: function() {
          var _ref;
          return (_ref = $rootScope.credentials) != null ? _ref.venue : void 0;
        },
        getMerchant: function() {
          var _ref;
          return (_ref = $rootScope.credentials) != null ? _ref.merchant : void 0;
        },
        getCredentials: function() {
          return $rootScope.credentials;
        },
        clearCredentials: function() {
          return $rootScope.credentials = null;
        },
        impersonateMerchant: function(merchant, callback) {
          $rootScope.credentials.merchant = merchant;
          return ResourceNoPaging.one("merchants", merchant.id).getList("venues", {
            full: false
          }).then(function(venues) {
            if (venues.length) {
              $rootScope.credentials.venues = venues;
              $rootScope.$broadcast('merchant:switch', venues[0]);
              storeVenueDetails(venues[0]);
              return callback();
            } else {
              $rootScope.credentials = null;
              return errorCallback('Merchant has no venues');
            }
          });
        },
        switchVenue: function(venue, callback) {
          storeVenueDetails(venue);
          return callback();
        },
        setLocale: function(localeStr) {
          return locale.setLocale(localeStr);
        },
        getLocale: function() {
          return locale.getLocale();
        },
        getLocaleService: function() {
          return locale;
        },

        /*
        Initializes authentication state based on `token` and `venueId` query string params
        or local storage values.
         */
        init: function() {
          var email, merchantId, token, venueId;
          token = $location.search().token;
          merchantId = $location.search().merchantId;
          venueId = $location.search().venueId;
          email = $location.search().email;
          if ((email != null) && (token != null) && (merchantId != null) && (venueId != null)) {
            $rootScope.credentials = {
              email: email,
              token: token,
              merchant: {
                id: merchantId
              },
              venue: {
                id: venueId
              }
            };
          } else if ((email != null) || (token != null) || (merchantId != null) || (venueId != null)) {
            this.clearCredentials();
          } else {
            $rootScope.credentials = JSON.parse(localStorage.getItem('credentials'));
          }
          if (!this.isLoggedIn() && $rootScope.secured) {
            return $location.path('/login');
          }
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=auth-service.js.map
