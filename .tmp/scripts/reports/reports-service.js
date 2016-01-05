(function() {
  angular.module('smartRegisterApp').factory('ReportsService', [
    '$rootScope', '$q', '$http', '$timeout', '$route', 'ResourceWithPaging', 'ResourceNoPaging', 'Auth', 'POSService', 'MessagingService', function($rootScope, $q, $http, $timeout, $route, ResourceWithPaging, ResourceNoPaging, Auth, POSService, MessagingService) {
      return {
        getPagedCPRList: function(venueId, params) {
          var _ref, _ref1, _ref2, _ref3, _ref4, _ref5;
          venueId = venueId != null ? venueId : (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.venue) != null ? _ref1.id : void 0 : void 0;
          if (!angular.isObject(params)) {
            params = {
              page: (_ref2 = $route.current.params.page) != null ? _ref2 : null,
              size: (_ref3 = $route.current.params.size) != null ? _ref3 : null,
              sort: (_ref4 = $route.current.params.sort) != null ? _ref4 : null
            };
          }
          return ResourceWithPaging.one("merchants", (_ref5 = Auth.getMerchant()) != null ? _ref5.id : void 0).one("venues", venueId).one("reports").all("cprs").getList(params);
        },
        saveCPR: function(reportData) {
          var apiURL, response;
          response = $q.defer();
          apiURL = "api://api/merchants/" + reportData.merchantId + "/venues/" + reportData.venueId + "/reports/cpr";
          delete reportData.vatSummaryDetails;
          delete reportData.calculated;
          delete reportData.created;
          delete reportData.apiVersion;
          return $http({
            url: apiURL,
            method: 'POST',
            data: reportData
          }).success(function(data, status, headers, config) {
            response.resolve(data);
            return response.promise;
          }).error(function(data, status, headers, config) {
            var error;
            error = MessagingService.createMessage("error", data.message, 'CPRReport');
            MessagingService.resetMessages();
            MessagingService.addMessage(error);
            return MessagingService.hasMessages('CPRReport');
          });
        },
        getSavedCPR: function(venueId, id) {
          var _ref;
          return ResourceNoPaging.one("merchants", (_ref = Auth.getMerchant()) != null ? _ref.id : void 0).one("venues", venueId).one("reports").one("cprs", id).get();
        },
        getPagedOrderList: function(venueId, options) {
          var params, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6;
          venueId = venueId != null ? venueId : (_ref = $rootScope.credentials) != null ? (_ref1 = _ref.venue) != null ? _ref1.id : void 0 : void 0;
          params = {
            page: (_ref2 = options.data.page - 1) != null ? _ref2 : null,
            size: (_ref3 = options.data.pageSize) != null ? _ref3 : null
          };
          if (((_ref4 = options.data) != null ? _ref4.sort : void 0) != null) {
            angular.forEach(options.data.sort, function(item, index) {
              return params.sort = "" + item.field + "," + item.dir;
            });
          }
          if (((_ref5 = options.data) != null ? _ref5.filter : void 0) != null) {
            angular.forEach(options.data.filter.filters, function(item, index) {
              return params[item.field] = item.value;
            });
          }
          return ResourceWithPaging.one("merchants", (_ref6 = Auth.getMerchant()) != null ? _ref6.id : void 0).one("venues", venueId).all("orders").getList(params).then(function(response) {
            return angular.forEach(response, function(value, index) {
              var total;
              total = 0;
              angular.forEach(response[index].basket.items, function(value, index) {
                return total = total + value.total;
              });
              return response[index]["orderTotal"] = parseFloat(total != null ? total : 0).toFixed(2);
            });
          });
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=reports-service.js.map
