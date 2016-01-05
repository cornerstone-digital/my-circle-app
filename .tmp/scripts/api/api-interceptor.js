(function() {
  'use strict';
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  angular.module('smartRegisterApp').factory('apiInterceptor', [
    '$q', '$rootScope', '$location', '$timeout', '$filter', 'Config', 'MessagingService', function($q, $rootScope, $location, $timeout, $filter, Config, MessagingService) {
      return {
        request: function(config) {
          var credentials, hash;
          MessagingService.resetMessages();
          if (config.url.indexOf('api:/') === 0) {
            config.url = config.url.replace(/^api:\//, Config.baseURL());
            config.isApiCall = true;
            credentials = JSON.parse(localStorage.getItem('credentials'));
            if (((credentials != null ? credentials.token : void 0) != null) && (config.headers['Authorization'] == null)) {
              hash = $filter('hmacSha256')("" + credentials.token + ":" + credentials.email, credentials.token);
              config.headers['Authorization'] = "Token " + hash;
              config.headers['X-Session-Id'] = credentials.token;
            }
          }
          if (!config.headers) {
            config.headers = {};
          }
          config.headers['X-Merchant-Dashboard-Version'] = $rootScope.currentVersion;
          return config;
        },
        responseError: function(response) {
          var errorMsg, _i, _ref, _ref1, _ref2, _ref3, _results;
          if (response.config.isApiCall) {
            switch (false) {
              case response.status !== 401:
                $rootScope.retryPath = $location.path();
                $rootScope.credentials = null;
                $location.path('/login');
                break;
              case _ref = response.status, __indexOf.call((function() {
                  _results = [];
                  for (_i = 500; _i <= 599; _i++){ _results.push(_i); }
                  return _results;
                }).apply(this), _ref) < 0:
                $rootScope.$broadcast('apiConnectionError');
                break;
              case response.status !== 0:
                break;
              default:
                $rootScope.errors = (_ref1 = (_ref2 = response.data) != null ? _ref2.errors : void 0) != null ? _ref1 : [];
                if ($rootScope.errors != null) {
                  angular.forEach($rootScope.errors, function(value, index) {
                    var error, errorMsg, message;
                    error = $rootScope.errors[index];
                    if (angular.isArray(error)) {
                      message = error[0];
                      console.log(message);
                    }
                    errorMsg = MessagingService.createMessage('error', message, 'GlobalErrors');
                    return MessagingService.addMessage(errorMsg);
                  });
                  if (((_ref3 = response.data) != null ? _ref3.message : void 0) != null) {
                    MessagingService.resetMessages();
                    errorMsg = MessagingService.createMessage('error', response.data.message + " Error Reference: " + response.data.reference, 'GlobalErrors');
                    MessagingService.addMessage(errorMsg);
                  }
                }
                MessagingService.hasMessages('GlobalErrors');
                console.error("Got error " + response.status, response.config.method, response.config.url);
            }
          }
          return $q.reject(response);
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=api-interceptor.js.map
