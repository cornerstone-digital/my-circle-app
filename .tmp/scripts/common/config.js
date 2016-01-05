(function() {
  'use strict';
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  angular.module('smartRegisterApp').factory('Config', [
    '$rootScope', '$location', 'environments', function($rootScope, $location, environments) {
      return {
        baseURL: function() {
          var _ref;
          this._overrideFromQueryString('env');
          this._reverseLookupEnvFromBaseURL();
          this._defaultEnvFromHost();
          this._rejectInvalidEnv();
          return (_ref = environments[$rootScope.env]) != null ? _ref.baseURL : void 0;
        },
        mode: function() {
          var _ref;
          this._overrideFromQueryString('mode');
          return (_ref = $rootScope.mode) != null ? _ref : 'browser';
        },
        _overrideFromQueryString: function(key) {
          var value;
          value = $location.search()[key];
          if (value) {
            return $rootScope[key] = value;
          }
        },
        _reverseLookupEnvFromBaseURL: function() {
          var baseURL;
          baseURL = $location.search().baseURL;
          if (baseURL != null) {
            return $rootScope.env = _.find(_.keys(environments), function(it) {
              return environments[it].baseURL === baseURL;
            });
          }
        },
        _defaultEnvFromHost: function() {
          var match;
          if ($location.host() === 'localhost') {
            return $rootScope.env = 'test';
          } else if ($location.host() === 'imac.mycircleinc.net') {
            return $rootScope.env = 'test';
          } else if ($location.host() === 'merchant.mycircleinc.com') {
            return $rootScope.env = 'live';
          } else {
            match = /^merchant[\.-](\w+)\./.exec($location.host());
            if (match != null) {
              return $rootScope.env = match[1];
            }
          }
        },
        _rejectInvalidEnv: function() {
          var _ref;
          if (_ref = $rootScope.env, __indexOf.call(_.keys(environments), _ref) < 0) {
            console.warn("Invalid environment '" + $rootScope.env + "'");
            delete $rootScope.env;
            return $location.path('/invalid-env');
          }
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=config.js.map
