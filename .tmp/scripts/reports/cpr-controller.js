(function() {
  angular.module('smartRegisterApp').controller('CPRReportCtrl', [
    '$rootScope', '$scope', '$timeout', '$route', '$filter', 'venues', 'POSList', "POSName", 'venue', 'ReportsService', 'POSService', 'MessagingService', 'ValidationService', function($rootScope, $scope, $timeout, $route, $filter, venues, POSList, POSName, venue, ReportsService, POSService, MessagingService, ValidationService) {
      var _ref;
      $scope.readOnly = function() {
        return $scope.readonly;
      };
      $scope.hasErrors = function() {
        return MessagingService.hasMessages('CPRReport').length;
      };
      $scope.setDateValues = function(openingDate, closingDate) {
        var now;
        now = moment(new Date());
        if (openingDate) {
          $scope.openingDate = moment(openingDate);
        }
        if (closingDate) {
          $scope.closingDate = moment(closingDate);
        }
        if ($scope.openingDate > now) {
          $scope.openingDate = now;
        }
        if ($scope.closingDate > now) {
          $scope.closingDate = now;
        }
      };
      $scope.setDatePickers = function(opening, closing) {
        $scope.setDateValues(opening, closing);
        return $timeout(function() {
          if ($scope.opening != null) {
            $scope.opening.min(kendo.parseDate($scope.openingDate.toISOString()));
            $scope.opening.max(kendo.parseDate($scope.closingDate.toISOString()));
          }
          if ($scope.closing != null) {
            $scope.closing.min(kendo.parseDate($scope.openingDate.toISOString()));
            return $scope.closing.max(kendo.parseDate($scope.closingDate.toISOString()));
          }
        }, 1000);
      };
      $scope.updateVenue = function(e) {
        var dataItem;
        dataItem = this.dataItem(e.item.index());
        $scope.venueId = dataItem.id;
        POSService.getList($scope.venueId).then(function(response) {
          $('#posId').data("kendoDropDownList").setDataSource(response);
          if (response.length) {
            $('#posId').data("kendoDropDownList").refresh();
            return $('#posId').data("kendoDropDownList").enable();
          } else {
            return $('#posId').data("kendoDropDownList").enable(false);
          }
        });
        return $scope.generateReport();
      };
      $scope.updatePOS = function(e) {
        var dataItem;
        dataItem = this.dataItem(e.item.index());
        $scope.posId = dataItem.id;
        $scope.POS = dataItem;
        return $scope.generateReport();
      };
      $scope.getPOS = function(id, name) {
        var error, _ref, _ref1;
        if (!$scope.POS) {
          $scope.POS = null;
        }
        if ((id != null) && ((_ref = $scope.POS) != null ? _ref.id : void 0) !== id) {
          $scope.POS = _.findWhere(POSList, {
            id: Number(id)
          });
        } else if ((name != null) && ((_ref1 = $scope.POS) != null ? _ref1.name : void 0) !== name) {
          $scope.POS = _.findWhere(POSList, {
            name: name
          });
        }
        if (!angular.isObject($scope.POS)) {
          error = MessagingService.createMessage("error", "POS '" + name + "' does not exist for the selected venue", 'CPRReport');
          MessagingService.resetMessages();
          MessagingService.addMessage(error);
          MessagingService.hasMessages('CPRReport');
          return true;
        } else {
          return $scope.POS;
        }
      };
      $scope.getVenue = function(id, name) {
        venue = null;
        if (id != null) {
          venue = _.findWhere(venues, {
            id: Number(id)
          });
        } else if (name != null) {
          venue = _.findWhere(venues, {
            name: name
          });
        }
        return venue;
      };
      $scope.formatPercentage = function(value) {
        return numeral(value).format('0.000%');
      };
      $scope.calculatePayments = function() {
        $scope.report.calculated = {};
        $scope.report.calculated.paymentTotal = Number($scope.report.cashPayment) + Number($scope.report.cardPayment);
        $scope.report.calculated.cashPaymentDifference = Number($scope.report.cashPaymentActual) - Number($scope.report.cashPayment);
        if ($scope.report.cashPayment > 0) {
          $scope.report.calculated.cashPaymentPercentageDifference = $scope.report.calculated.cashPaymentDifference / $scope.report.cashPayment;
        }
        $scope.report.calculated.cardPaymentDifference = Number($scope.report.cardPaymentActual) - Number($scope.report.cardPayment);
        if ($scope.report.cardPayment > 0) {
          $scope.report.calculated.cardPaymentPercentageDifference = $scope.report.calculated.cardPaymentDifference / $scope.report.cardPayment;
        }
        $scope.report.calculated.actualPaymentTotal = Number($scope.report.cashPaymentActual) + Number($scope.report.cardPaymentActual);
        $scope.report.calculated.paymentDifferenceTotal = Number($scope.report.calculated.actualPaymentTotal) - Number($scope.report.calculated.paymentTotal);
        if ($scope.report.calculated.paymentTotal) {
          $scope.report.calculated.paymentPercentageDifference = $scope.report.calculated.paymentDifferenceTotal / $scope.report.calculated.paymentTotal;
        }
        $scope.report.calculated.cashDrawerBalance = Number($scope.report.openingBalance) + Number($scope.report.paymentIn) - Number($scope.report.paymentOut) + Number($scope.report.calculated.paymentTotal);
        $scope.report.calculated.cashDrawerActual = Number($scope.report.openingBalance) + Number($scope.report.paymentIn) - Number($scope.report.paymentOut) + Number($scope.report.calculated.actualPaymentTotal);
        $scope.report.calculated.cashDrawerDifference = Number($scope.report.calculated.cashDrawerActual) - Number($scope.report.calculated.cashDrawerBalance);
        if ($scope.report.calculated.cashDrawerBalance > 0) {
          return $scope.report.calculated.cashDrawerPercentageDifference = $scope.report.calculated.cashDrawerDifference / $scope.report.calculated.cashDrawerActual;
        }
      };
      $scope.$watch("openingDate", function() {
        if ($scope.openingDate) {
          if ($scope.opening) {
            return $scope.opening.value(kendo.parseDate($scope.openingDate.toISOString()));
          }
        }
      });
      $scope.$watch("closingDate", function() {
        if ($scope.closingDate) {
          if ($scope.closing) {
            return $scope.closing.value(kendo.parseDate($scope.closingDate.toISOString()));
          }
        }
      });
      $scope.$watch("POS", function() {
        if (($scope.POS != null) && angular.isNumber(parseInt($scope.POS.id))) {
          if ($('#posId').data("kendoDropDownList")) {
            return $('#posId').data("kendoDropDownList").value($scope.POS.id);
          }
        }
      });
      $scope.generateReport = function(reportId) {
        var data, params, _ref;
        data = {};
        $scope.readonly = false;
        if (angular.isDefined(reportId && angular.isNumber(parseInt(reportId)))) {
          $scope.readonly = true;
          return ReportsService.getSavedCPR($scope.venueId, reportId).then(function(response) {
            var _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9;
            data = response;
            $scope.POS = $scope.getPOS(null, response.pos);
            $scope.posId = (_ref = (_ref1 = $scope.POS) != null ? _ref1.id : void 0) != null ? _ref : POSList[0].id;
            if (data != null) {
              $scope.setDatePickers(data.opening, data.closing);
              data.paymentIn = parseFloat((_ref2 = data.paymentIn) != null ? _ref2 : 0).toFixed(2);
              data.paymentOut = parseFloat((_ref3 = data.paymentOut) != null ? _ref3 : 0).toFixed(2);
              data.cashPayment = parseFloat((_ref4 = data.cashPayment) != null ? _ref4 : 0).toFixed(2);
              data.cashPaymentActual = parseFloat((_ref5 = data.cashPaymentActual) != null ? _ref5 : data.cashPayment).toFixed(2);
              data.cardPayment = parseFloat((_ref6 = data.cardPayment) != null ? _ref6 : 0).toFixed(2);
              data.cardPaymentActual = parseFloat((_ref7 = data.cardPaymentActual) != null ? _ref7 : data.cardPayment).toFixed(2);
              data.openingBalance = parseFloat((_ref8 = data.openingBalance) != null ? _ref8 : 0).toFixed(2);
              data.cashDrawerActual = parseFloat((_ref9 = data.cashDrawerActual) != null ? _ref9 : 0).toFixed(2);
              $scope.report = data;
              $scope.closing.enable(!$scope.readOnly());
              $scope.calculatePayments();
              $('#venue').data("kendoDropDownList").enable(false);
              $('#posId').data("kendoDropDownList").enable(false);
              $scope.opening.enable(false);
              $scope.closing.enable(!$scope.readOnly());
              return $scope.calculatePayments();
            }
          });
        } else {
          if (angular.isNumber(parseInt((_ref = $scope.POS) != null ? _ref.id : void 0))) {
            params = {
              pos: $scope.POS.name
            };
            if ($scope.openingDate != null) {
              params.opening = $scope.openingDate.toISOString();
            }
            if ($scope.closingDate != null) {
              params.closing = $scope.closingDate.toISOString();
            }
            return POSService.getPosValues($scope.venueId, params).then(function(response) {
              var _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8;
              data = response;
              if (data != null) {
                $scope.setDatePickers(data.opening, data.closing);
                data.paymentIn = parseFloat((_ref1 = data.paymentIn) != null ? _ref1 : 0).toFixed(2);
                data.paymentOut = parseFloat((_ref2 = data.paymentOut) != null ? _ref2 : 0).toFixed(2);
                data.cashPayment = parseFloat((_ref3 = data.cashPayment) != null ? _ref3 : 0).toFixed(2);
                data.cashPaymentActual = parseFloat((_ref4 = data.cashPaymentActual) != null ? _ref4 : data.cashPayment).toFixed(2);
                data.cardPayment = parseFloat((_ref5 = data.cardPayment) != null ? _ref5 : 0).toFixed(2);
                data.cardPaymentActual = parseFloat((_ref6 = data.cardPaymentActual) != null ? _ref6 : data.cardPayment).toFixed(2);
                data.openingBalance = parseFloat((_ref7 = data.openingBalance) != null ? _ref7 : 0).toFixed(2);
                data.cashDrawerActual = parseFloat((_ref8 = data.cashDrawerActual) != null ? _ref8 : 0).toFixed(2);
                $scope.report = data;
                $scope.closing.enable(!$scope.readOnly());
                return $scope.calculatePayments();
              }
            });
          }
        }
      };
      $scope.openingChange = function() {
        $scope.openingDate = moment($scope.opening.value());
        $scope.closingDate = moment($scope.closing.value());
        return $scope.$apply(function() {
          if ($scope.openingDate) {
            $scope.closing.min($scope.openingDate.toISOString());
          } else if ($scope.closingDate) {
            $scope.opening.max(moment($scope.closingDate));
          } else {
            $scope.closingDate = moment();
            $scope.opening.max($scope.closingDate);
            $scope.closing.min($scope.closingDate);
            $scope.closing.max($scope.closingDate);
          }
          $scope.generateReport();
        });
      };
      $scope.closingChange = function() {
        $scope.closingDate = moment($scope.closing.value());
        $scope.openingDate = moment($scope.opening.value());
        return $scope.$apply(function() {
          if ($scope.closingDate) {
            $scope.opening.max($scope.closingDate.toISOString());
          } else if ($scope.openingDate) {
            $scope.closing.min(moment($scope.openingDate));
          } else {
            $scope.closingDate = moment();
            $scope.opening.max($scope.closingDate);
            $scope.closing.min($scope.closingDate);
            $scope.closing.max($scope.closingDate);
          }
          $scope.generateReport();
        });
      };
      $scope.save = function() {
        $scope.report.opening = new Date($scope.opening.value());
        $scope.report.closing = new Date($scope.closing.value());
        if (!$scope.report.openingBalance) {
          $scope.report.openingBalance = 0;
        }
        return ReportsService.saveCPR($scope.report).then(function(response) {
          window.location.href = '#' + $rootScope.backUrl;
          return location.reload();
        });
      };
      $scope.generatePDF = function() {
        var docDefinition, vatSection;
        docDefinition = {
          content: [
            {
              columns: [
                {
                  text: "Closing POS Report",
                  style: "headerBar",
                  margin: [0, 0, 0, 10]
                }
              ]
            }, {
              columns: [
                {
                  text: "Venue:",
                  width: 200,
                  style: "headerCol",
                  width: 100
                }, {
                  text: $scope.venue.name,
                  alignment: "right"
                }
              ]
            }, {
              columns: [
                {
                  text: "POS:",
                  width: 200,
                  style: "headerCol",
                  width: 100
                }, {
                  text: $scope.report.pos,
                  alignment: "right"
                }
              ]
            }, {
              columns: [
                {
                  text: "Opening:",
                  width: 200,
                  style: "headerCol",
                  width: 100
                }, {
                  text: kendo.toString(new Date(kendo.parseDate($scope.report.opening)), 'dddd dd MMM yyyy @ HH:mm'),
                  alignment: "right"
                }
              ]
            }, {
              columns: [
                {
                  text: "Closing:",
                  width: 200,
                  style: "headerCol",
                  width: 100
                }, {
                  text: kendo.toString(new Date(kendo.parseDate($scope.report.closing)), 'dddd dd MMM yyyy @ HH:mm'),
                  alignment: "right"
                }
              ]
            }, {
              columns: [
                {
                  text: "Sales",
                  style: "headerBar",
                  margin: [0, 20, 0, 10]
                }
              ]
            }, {
              columns: [
                {
                  text: '',
                  width: 100
                }, {
                  text: "Payments",
                  width: "*",
                  style: "headerCol"
                }, {
                  text: "Actual",
                  width: "*",
                  style: "headerCol"
                }, {
                  text: "Difference",
                  width: "*",
                  style: "headerCol"
                }, {
                  text: "% Difference",
                  width: "*",
                  style: "headerCol"
                }
              ]
            }, {
              columns: [
                {
                  text: "Cash",
                  style: "headerCol",
                  width: 100
                }, {
                  text: $filter('currency')($scope.report.cashPayment, "£"),
                  width: "*"
                }, {
                  text: $filter('currency')($scope.report.cashPaymentActual, "£"),
                  width: "*"
                }, {
                  text: $filter('currency')($scope.report.calculated.cashPaymentDifference, "£"),
                  width: "*"
                }, {
                  text: $scope.formatPercentage($scope.report.calculated.cashPaymentPercentageDifference),
                  width: "*"
                }
              ]
            }, {
              columns: [
                {
                  text: "Card",
                  style: "headerCol",
                  width: 100
                }, {
                  text: $filter('currency')($scope.report.cardPayment, "£"),
                  width: "*"
                }, {
                  text: $filter('currency')($scope.report.cardPaymentActual, "£"),
                  width: "*"
                }, {
                  text: $filter('currency')($scope.report.calculated.cardPaymentDifference, "£"),
                  width: "*"
                }, {
                  text: $scope.formatPercentage($scope.report.calculated.cardPaymentPercentageDifference),
                  width: "*"
                }
              ]
            }, {
              columns: [
                {
                  text: "Total",
                  style: "headerCol",
                  width: 100
                }, {
                  text: $filter('currency')($scope.report.calculated.paymentTotal, "£"),
                  width: "*"
                }, {
                  text: $filter('currency')($scope.report.calculated.actualPaymentTotal, "£"),
                  width: "*"
                }, {
                  text: $filter('currency')($scope.report.calculated.paymentDifferenceTotal, "£"),
                  width: "*"
                }, {
                  text: $scope.formatPercentage($scope.report.calculated.paymentPercentageDifference),
                  width: "*"
                }
              ]
            }, {
              columns: [
                {
                  text: "Payments",
                  style: "headerBar",
                  margin: [0, 20, 0, 10]
                }
              ]
            }, {
              columns: [
                {
                  text: '',
                  width: 100
                }, {
                  text: "Payments",
                  width: "*",
                  style: "headerCol"
                }, {
                  text: "Actual",
                  width: "*",
                  style: "headerCol"
                }, {
                  text: "Difference",
                  width: "*",
                  style: "headerCol"
                }, {
                  text: "% Difference",
                  width: "*",
                  style: "headerCol"
                }
              ]
            }, {
              columns: [
                {
                  text: "Payments In",
                  style: "headerCol",
                  width: 100
                }, {
                  text: $filter('currency')($scope.report.paymentIn, "£"),
                  width: "*"
                }, {
                  text: "-",
                  width: "*"
                }, {
                  text: "-",
                  width: "*"
                }, {
                  text: "-",
                  width: "*"
                }
              ]
            }, {
              columns: [
                {
                  text: "Payments Out",
                  style: "headerCol",
                  width: 100
                }, {
                  text: $filter('currency')($scope.report.paymentOut, "£"),
                  width: "*"
                }, {
                  text: "-",
                  width: "*"
                }, {
                  text: "-",
                  width: "*"
                }, {
                  text: "-",
                  width: "*"
                }
              ]
            }, {
              columns: [
                {
                  text: "Totals",
                  style: "headerBar",
                  margin: [0, 20, 0, 10]
                }
              ]
            }, {
              columns: [
                {
                  text: '',
                  width: 100
                }, {
                  text: "Payments",
                  width: "*",
                  style: "headerCol"
                }, {
                  text: "Actual",
                  width: "*",
                  style: "headerCol"
                }, {
                  text: "Difference",
                  width: "*",
                  style: "headerCol"
                }, {
                  text: "% Difference",
                  width: "*",
                  style: "headerCol"
                }
              ]
            }, {
              columns: [
                {
                  text: "Opening",
                  style: "headerCol",
                  width: 100
                }, {
                  text: "-",
                  width: "*"
                }, {
                  text: $filter('currency')($scope.report.openingBalance, "£"),
                  width: "*"
                }, {
                  text: "-",
                  width: "*"
                }, {
                  text: "-",
                  width: "*"
                }
              ]
            }, {
              columns: [
                {
                  text: "Cash Drawer Balance",
                  style: "headerCol",
                  width: 100
                }, {
                  text: $filter('currency')($scope.report.calculated.cashDrawerBalance, "£"),
                  width: "*"
                }, {
                  text: $filter('currency')($scope.report.calculated.cashDrawerActual, "£"),
                  width: "*"
                }, {
                  text: $filter('currency')($scope.report.calculated.cashDrawerDifference, "£"),
                  width: "*"
                }, {
                  text: $scope.formatPercentage($scope.report.calculated.cashDrawerPercentageDifference),
                  width: "*"
                }
              ]
            }
          ],
          styles: {
            headerBar: {
              fontSize: 18,
              bold: true,
              color: '#6b9b8e'
            },
            headerCol: {
              bold: true,
              fontSize: 10
            }
          },
          defaultStyle: {
            columnGap: 20,
            fontSize: 10
          }
        };
        if ($scope.report.vatSummaryDetails) {
          vatSection = [];
          vatSection.push({
            columns: [
              {
                text: "Tax",
                style: "headerBar",
                margin: [0, 20, 0, 10]
              }
            ]
          });
          vatSection.push({
            columns: [
              {
                text: '',
                width: 100
              }, {
                text: "Rate",
                width: "*",
                style: "headerCol"
              }, {
                text: "Total Tax value",
                width: "*",
                style: "headerCol"
              }, {
                text: "",
                width: "*",
                style: "headerCol"
              }, {
                text: "",
                width: "*",
                style: "headerCol"
              }
            ]
          });
          angular.forEach($scope.report.vatSummaryDetails, function(value, index) {
            return vatSection.push({
              columns: [
                {
                  text: "",
                  width: "*",
                  style: "headerCol",
                  width: 100
                }, {
                  text: $filter('percentage')(value.taxRate)
                }, {
                  text: $filter('currency')(value.total, "£"),
                  width: "*",
                  style: "headerCol"
                }, {
                  text: "-",
                  width: "*",
                  style: "headerCol"
                }, {
                  text: "-",
                  width: "*",
                  style: "headerCol"
                }
              ]
            });
          });
          docDefinition.content.push(vatSection);
        }
        return $timeout(function() {
          return pdfMake.createPdf(docDefinition).open();
        }, 200);
      };
      $rootScope.$on("$viewContentLoaded", function() {
        if ($route.current.loadedTemplateUrl === 'views/cpr-report.html') {
          return $timeout(function() {
            var error, reportId, _ref, _ref1;
            if (POSList.length) {
              if ($route.current.params.id) {
                reportId = $route.current.params.id;
              } else {
                $scope.POSName = POSName != null ? POSName : POSList[0].name;
                $scope.POS = $scope.getPOS(null, $scope.POSName);
                $scope.posId = (_ref = (_ref1 = $scope.POS) != null ? _ref1.id : void 0) != null ? _ref : POSList[0].id;
              }
              return $timeout(function() {
                return $scope.generateReport(reportId);
              }, 500);
            } else {
              error = MessagingService.createMessage("error", "No POS devices exist for the selected venue", 'CPRReport');
              MessagingService.resetMessages();
              MessagingService.addMessage(error);
              return MessagingService.hasMessages('CPRReport');
            }
          }, 500);
        }
      });
      $scope.venue = venue != null ? venue : $rootScope.credentials.venue;
      $scope.report = typeof report !== "undefined" && report !== null ? report : {
        calculated: {}
      };
      $scope.report.calculated.cashPaymentPercentageDifference = 0;
      $scope.report.calculated.cardPaymentPercentageDifference = 0;
      $scope.report.calculated.paymentPercentageDifference = 0;
      $scope.report.calculated.cashDrawerPercentageDifference = 0;
      $scope.venueId = (_ref = $scope.venue.id) != null ? _ref : venue.id;
      $scope.POSList = new kendo.data.DataSource({
        data: POSList
      });
      $scope.venues = new kendo.data.DataSource({
        data: venues
      });
      return $timeout(function() {
        $scope.venueSelect = $('#venue').kendoDropDownList({
          dataTextField: "name",
          dataValueField: "id",
          dataSource: $scope.venues,
          select: $scope.updateVenue,
          enabled: !$scope.readOnly()
        });
        $scope.posSelect = $('#posId').kendoDropDownList({
          dataTextField: "name",
          dataValueField: "id",
          dataSource: $scope.POSList,
          select: $scope.updatePOS,
          enabled: !$scope.readOnly()
        });
        $scope.opening = $("#opening").kendoDateTimePicker({
          value: $scope.openingDate,
          change: $scope.openingChange,
          timeFormat: "HH:mm",
          format: "dd/MM/yyyy HH:mm",
          parseFormats: ["dd/MM/yyyy hh:mmtt", "dd/MM/yyyy HH:mm", "dd/MM/yyyy", "HH:mm"],
          interval: '15'
        }).data("kendoDateTimePicker");
        $scope.closing = $("#closing").kendoDateTimePicker({
          value: $scope.closingDate,
          change: $scope.closingChange,
          timeFormat: "HH:mm",
          format: "dd/MM/yyyy HH:mm",
          parseFormats: ["dd/MM/yyyy hh:mmtt", "dd/MM/yyyy HH:mm", "dd/MM/yyyy", "HH:mm"],
          interval: '15'
        }).data("kendoDateTimePicker");
        $scope.openingDate;
        return $scope.setDatePickers($scope.openingDate, $scope.closingDate);
      }, 500);
    }
  ]);

}).call(this);

//# sourceMappingURL=cpr-controller.js.map
