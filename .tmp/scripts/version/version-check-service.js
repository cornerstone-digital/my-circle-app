(function() {
  'use strict';
  angular.module('versionPoll').constant('frequencySeconds', 5 * 60).factory('versionCheckService', [
    '$rootScope', '$http', '$timeout', 'frequencySeconds', 'POSService', function($rootScope, $http, $timeout, frequencySeconds, POSService) {
      var checkPOSVersion, compareVersions, currentVersion, gitHash, lastModified, pollDashboardVersion, pollGitHashVersion, pollServerVersion, serverInformation;
      currentVersion = null;
      lastModified = null;
      serverInformation = null;
      gitHash = null;
      pollDashboardVersion = function() {
        var requestHeaders;
        requestHeaders = {};
        if (lastModified != null) {
          requestHeaders['If-Modified-Since'] = lastModified;
        }
        return $http.get('/version.txt', {
          headers: requestHeaders
        }).success(function(newVersion, status, responseHeaders) {
          if (currentVersion != null) {
            if (currentVersion === newVersion) {
              return $timeout(pollDashboardVersion, frequencySeconds * 1000);
            } else {
              currentVersion = newVersion;
              lastModified = responseHeaders('Last-Modified');
              return $rootScope.$broadcast('version:changed', newVersion);
            }
          } else {
            currentVersion = newVersion;
            $rootScope.currentVersion = currentVersion;
            lastModified = responseHeaders('Last-Modified');
            return $timeout(pollDashboardVersion, frequencySeconds * 1000);
          }
        }).error(function(data, status) {
          if (status === 304) {
            return $timeout(pollDashboardVersion, frequencySeconds * 1000);
          } else {
            return console.warn('Version check got an error', status, data);
          }
        });
      };
      pollGitHashVersion = function() {
        var requestHeaders;
        requestHeaders = {};
        if (lastModified != null) {
          requestHeaders['If-Modified-Since'] = lastModified;
        }
        return $http.get('/git-version.txt', {
          headers: requestHeaders
        }).success(function(newGitHash, status, responseHeaders) {
          if (gitHash != null) {
            if (gitHash === newGitHash) {
              return $timeout(pollGitHashVersion, frequencySeconds * 1000);
            } else {
              gitHash = newGitHash;
              lastModified = responseHeaders('Last-Modified');
              return $rootScope.$broadcast('version:changed', newGitHash);
            }
          } else {
            gitHash = newGitHash;
            lastModified = responseHeaders('Last-Modified');
            return $timeout(pollGitHashVersion, frequencySeconds * 1000);
          }
        }).error(function(data, status) {
          if (status === 304) {
            return $timeout(pollGitHashVersion, frequencySeconds * 1000);
          } else {
            return console.warn('Git version check got an error', status, data);
          }
        });
      };
      checkPOSVersion = function(serverInformation) {
        if ($rootScope.posVersion != null) {
          if ((serverInformation != null ? serverInformation.latestPosVersion : void 0) > $rootScope.posVersion) {
            return $rootScope.$broadcast('posversion:changed', serverInformation);
          }
        }
      };
      pollServerVersion = function() {
        return $http.get("api://api/information").success(function(response) {
          serverInformation = response;
          $timeout(pollServerVersion, frequencySeconds * 1000);
          return checkPOSVersion(serverInformation);
        });
      };
      compareVersions = function(versionOne, versionTwo) {
        var versionDiff, versionOneArr, versionTwoArr;
        versionOneArr = versionOne.split('.');
        versionTwoArr = versionTwo.split('.');
        versionDiff = false;
        if (versionOneArr[0] !== versionTwoArr[0]) {
          versionDiff = true;
        }
        if (versionOneArr[1] !== versionTwoArr[1]) {
          versionDiff = true;
        }
        if (versionOneArr[2] !== versionTwoArr[2]) {
          versionDiff = true;
        }
        return versionDiff;
      };
      return {
        startPolling: function() {
          pollDashboardVersion();
          pollGitHashVersion();
          return pollServerVersion();
        },
        currentVersion: function() {
          return currentVersion;
        },
        checkPOSVersions: function(POSList) {
          if (POSList == null) {
            POSService.getList().then(function(posList) {
              return POSList = posList;
            });
          }
          return $timeout(function() {
            return $http.get("api://api/information").success(function(response) {
              var message, versionDiff;
              serverInformation = response;
              versionDiff = false;
              angular.forEach(POSList, function(value, index) {
                if (compareVersions(serverInformation != null ? serverInformation.latestPosVersion : void 0, value.posVersion)) {
                  return versionDiff = true;
                }
              });
              console.log(versionDiff);
              if (versionDiff) {
                message = "Version " + serverInformation.latestPosVersion + " of the iOS App is now available. Some of your POS may be running an older version, please update as soon as possible.";
                toastr.options = {
                  "closeButton": true,
                  "debug": false,
                  "positionClass": "toast-top-full-width",
                  "onclick": null,
                  "showDuration": "1000",
                  "hideDuration": "1000",
                  "timeOut": "0",
                  "extendedTimeOut": "1000",
                  "showEasing": "swing",
                  "hideEasing": "linear",
                  "showMethod": "fadeIn",
                  "hideMethod": "fadeOut"
                };
                return toastr.info(message);
              }
            }, 500);
          });
        },
        getHash: function() {
          return gitHash;
        },
        lastModified: function() {
          return lastModified;
        },
        serverInformation: function() {
          return serverInformation;
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=version-check-service.js.map
