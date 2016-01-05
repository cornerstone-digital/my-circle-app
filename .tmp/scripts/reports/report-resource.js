(function() {
  'use strict';
  angular.module('smartRegisterApp').factory('Report', [
    '$resource', 'Config', 'Auth', '$filter', function($resource, Config, Auth, $filter) {
      var Report, collate;
      Report = $resource("api://api/merchants/:merchantId/venues/:venueId/reports", {
        merchantId: function() {
          var _ref;
          return (_ref = Auth.getMerchant()) != null ? _ref.id : void 0;
        },
        venueId: function() {
          var _ref;
          return (_ref = Auth.getVenue()) != null ? _ref.id : void 0;
        }
      }, {
        get: {
          method: 'GET',
          transformResponse: function(data, getHeader) {
            var dateHeader, json;
            json = typeof data === 'string' ? JSON.parse(data) : data;
            dateHeader = getHeader('Date');
            json.created = dateHeader != null ? new Date(dateHeader) : new Date();
            return json;
          }
        }
      });
      Report.prototype.totalTax = function() {
        var memo;
        memo = 0;
        _.forEach(this.vatReport.vatSummary, function(vatSummary) {
          return _.forEach(vatSummary.vatSummaryDetails, function(it) {
            return memo += it.type === 'PAYMENT' ? it.total : -it.total;
          });
        });
        return memo;
      };
      Report.prototype.totalGross = function() {
        return _.reduce(this.zReport.summary, function(memo, it) {
          return memo + (it.type === 'PAYMENT' ? it.total : -it.total);
        }, 0);
      };
      Report.prototype.totalSales = function() {
        return _.reduce(this.zReport.summary, function(memo, it) {
          return memo + (it.type === 'PAYMENT' ? it.total : 0);
        }, 0);
      };
      Report.prototype.totalRefunds = function() {
        return _.reduce(this.zReport.summary, function(memo, it) {
          return memo + (it.type === 'REFUND' ? it.total : 0);
        }, 0);
      };
      Report.prototype.refundCount = function() {
        return _.reduce(this.zReport.summary, function(memo, it) {
          return memo + (it.type === 'REFUND' ? it.count : 0);
        }, 0);
      };
      Report.prototype.cashIn = function() {
        var value;
        value = _.reduce(this.zReport.summary, function(memo, it) {
          return memo + (it.paymentType === 'CASH' && it.type === 'PAYMENT' ? it.total : 0);
        }, 0);
        value = _.reduce(this.paymentReport.payments, function(memo, it) {
          return memo + (it.paymentType === 'CASH' && it.direction === 'IN' ? it.total : 0);
        }, value);
        return value;
      };
      Report.prototype.cashOut = function() {
        var value;
        value = _.reduce(this.zReport.summary, function(memo, it) {
          return memo + (it.paymentType === 'CASH' && it.type === 'REFUND' ? it.total : 0);
        }, 0);
        value = _.reduce(this.paymentReport.payments, function(memo, it) {
          return memo + (it.paymentType === 'CASH' && it.direction === 'OUT' ? it.total : 0);
        }, value);
        return value;
      };
      Report.prototype.closingTotal = function() {
        var _ref;
        return parseFloat((_ref = this.openingTotal) != null ? _ref : '0') + this.cashIn() - this.cashOut();
      };

      /*
      A function that can collate PAYMENT and REFUND objects into a single view per
      category or product
       */
      collate = function(items, groupBy) {
        var element, item, result, type, _i, _j, _len, _len1, _ref;
        result = [];
        for (_i = 0, _len = items.length; _i < _len; _i++) {
          item = items[_i];
          element = result.filter(function(it) {
            return it[groupBy] === item[groupBy];
          })[0];
          if (element == null) {
            element = {
              net: 0
            };
            element[groupBy] = item[groupBy];
            _ref = ['payment', 'refund'];
            for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
              type = _ref[_j];
              element[type] = {
                total: 0,
                count: 0
              };
            }
            result.push(element);
          }
          element[item.type.toLowerCase()].total += item.total;
          element[item.type.toLowerCase()].count += item.count;
          if (item.type === 'PAYMENT') {
            element.net += item.total;
          } else {
            element.net -= item.total;
          }
        }
        return _.sortBy(result, function(it) {
          return -it.payment.total;
        });
      };
      Report.prototype.byCategory = function() {
        var _ref, _ref1;
        if (this._byCategory == null) {
          this._byCategory = collate((_ref = (_ref1 = this.categoryReport) != null ? _ref1.categories : void 0) != null ? _ref : [], 'category');
        }
        return this._byCategory;
      };
      Report.prototype.byProduct = function() {
        var _ref, _ref1;
        if (this._byProduct == null) {
          this._byProduct = collate((_ref = (_ref1 = this.productReport) != null ? _ref1.products : void 0) != null ? _ref : [], 'title');
        }
        return this._byProduct;
      };
      Report.prototype.topByProduct = function() {
        if (this._topByProduct == null) {
          this._topByProduct = $filter('limitTo')(this.byProduct(), 10);
        }
        return this._topByProduct;
      };
      Report.prototype.byPaymentType = function(paymentType, transactionType) {
        var data;
        data = this.zReport.summary.filter(function(it) {
          return it.paymentType === paymentType && it.type === transactionType;
        });
        if (data.length === 0) {
          return null;
        } else {
          return data[0];
        }
      };
      return Report;
    }
  ]);

}).call(this);

//# sourceMappingURL=report-resource.js.map
