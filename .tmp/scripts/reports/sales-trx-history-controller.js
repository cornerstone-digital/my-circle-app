(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  angular.module('smartRegisterApp').controller('SalesTransactionHistoryCtrl', [
    '$rootScope', '$scope', '$timeout', '$location', '$q', '$http', 'Config', 'ReportsService', 'POSService', 'MessagingService', 'ValidationService', function($rootScope, $scope, $timeout, $location, $q, $http, Config, ReportsService, POSService, MessagingService, ValidationService) {
      var orderHistoryGrid, rangeFrom, rangeTo, setFilteredMembers;
      rangeFrom = $("#dateRangeFrom").kendoDateTimePicker({
        format: "dd/MM/yyyy HH:MM"
      });
      rangeTo = $("#dateRangeTo").kendoDateTimePicker({
        format: "dd/MM/yyyy HH:MM"
      });
      $scope.populateDeviceList = function(posList) {
        var it, pos, _i, _len, _ref;
        $scope.device = null;
        $scope.deviceList = [
          {
            id: 'ALL_POS',
            name: 'All POS'
          }
        ];
        for (_i = 0, _len = posList.length; _i < _len; _i++) {
          it = posList[_i];
          $scope.deviceList.push({
            id: it.name,
            name: it.name,
            type: 'Devices'
          });
        }
        if ($location.search()['pos.uuid'] != null) {
          pos = {
            id: $location.search()['pos.name'],
            label: $location.search()['pos.name'],
            type: 'Devices'
          };
          if (_ref = pos.id, __indexOf.call(_.pluck($scope.deviceList, 'id'), _ref) < 0) {
            $scope.deviceList.push(pos);
          }
          $scope.device = pos;
        }
        return $scope.POSList = new kendo.data.DataSource({
          data: $scope.deviceList
        });
      };
      POSService.getList().then(function(response) {
        return $scope.populateDeviceList(response);
      });
      $scope.updatePOS = function(e) {
        var condition, dataItem;
        dataItem = this.dataItem(e.item.index());
        $scope.posId = dataItem.id;
        $scope.POS = dataItem;
        condition = {
          logic: "and",
          filters: []
        };
        if ($scope.POS.name !== 'All POS') {
          condition.filters.push({
            field: "pos",
            operator: "eq",
            value: $scope.POS.name
          });
        }
        orderHistoryGrid.data('kendoGrid').dataSource.filter(condition);
      };
      $scope.resetDateRange = function() {
        var condition;
        condition = {
          logic: "and",
          filters: []
        };
        rangeFrom.data("kendoDateTimePicker").value(null);
        rangeTo.data("kendoDateTimePicker").value(null);
        return orderHistoryGrid.data('kendoGrid').dataSource.filter(condition);
      };
      $scope.showDetails = function(e) {
        var dataRow, nextRow;
        e.preventDefault();
        dataRow = $(e.currentTarget).closest("tr");
        nextRow = dataRow.next('tr');
        if (nextRow.hasClass('k-detail-row') && nextRow.filter(":visible").length) {
          dataRow.find('.k-grid-ShowItems').text('Show Items');
          return this.collapseRow($(e.currentTarget).closest("tr"));
        } else {
          dataRow.find('.k-grid-ShowItems').text('Hide Items');
          return this.expandRow($(e.currentTarget).closest("tr"));
        }
      };
      $scope.detailInit = function(e) {
        var detailRow, finalTotal, groupByState, itemTable, items, orderTotal, refundAmount, transactions, _ref, _ref1, _ref2, _ref3;
        detailRow = e.detailRow;
        itemTable = detailRow.find('.order-items table');
        items = e.data.basket.items;
        transactions = e.data.transactions;
        orderTotal = 0;
        refundAmount = 0;
        groupByState = _.groupBy(items, function(item) {
          return item.state.toLowerCase();
        });
        angular.forEach(items, function(value, index) {
          var row, _ref;
          orderTotal = orderTotal + value.total;
          if (value.state === 'REFUNDED') {
            refundAmount = refundAmount + value.total;
          }
          row = angular.element('<tr class="state-' + value.state.toLowerCase() + '"></tr>');
          row.append('<td>' + value.title + '</td>');
          row.append('<td> &pound;' + parseFloat((_ref = value.total) != null ? _ref : 0).toFixed(2) + '</td>');
          row.append('<td class="state-cell">' + value.state + '</td>');
          return itemTable.append(row);
        });
        if (transactions.length) {
          detailRow.find(".order-transactions").kendoGrid({
            dataSource: {
              data: transactions
            },
            columns: [
              {
                field: "created",
                title: "Date",
                width: "250px",
                template: '#= kendo.toString(kendo.parseDate(created), "HH:mm - dd / MMMM / yyyy" ) #'
              }, {
                field: "type",
                title: "Type"
              }, {
                field: "paymentType",
                title: "Payment"
              }, {
                field: "pos",
                title: "POS"
              }, {
                field: "amount",
                title: "Amount",
                template: '&pound;#= parseFloat(amount).toFixed(2) #',
                width: "100px   "
              }
            ]
          });
        }
        finalTotal = orderTotal - refundAmount;
        detailRow.find('.refunded-count span').text((_ref = (_ref1 = groupByState.refunded) != null ? _ref1.length : void 0) != null ? _ref : 0);
        detailRow.find('.paid-count span').text((_ref2 = (_ref3 = groupByState.paid) != null ? _ref3.length : void 0) != null ? _ref2 : 0);
        detailRow.find('.order-total span').text('£' + parseFloat(finalTotal != null ? finalTotal : 0).toFixed(2));
        detailRow.find(".tabstrip").kendoTabStrip({
          animation: {
            open: {
              effects: "fadeIn"
            }
          }
        });
      };
      orderHistoryGrid = $(".order-history-list").kendoGrid({
        sortable: true,
        filterable: true,
        columnMenu: true,
        pageable: {
          buttonCount: 5,
          pageSize: 15,
          refresh: true
        },
        dataSource: {
          serverPaging: true,
          serverSorting: true,
          serverFiltering: true,
          transport: {
            read: function(options) {
              return ReportsService.getPagedOrderList($rootScope.credentials.venue.id, options).then(function(response) {
                return options.success(response);
              });
            }
          },
          schema: {
            model: {
              fields: {
                dateCreated: {
                  type: "date"
                },
                pos: {
                  type: "string"
                },
                orderId: {
                  type: "string"
                }
              }
            },
            total: function(response) {
              return response.page.totalElements;
            }
          }
        },
        columns: [
          {
            field: "created",
            title: "Date",
            width: "250px",
            template: '#= kendo.toString(kendo.parseDate(created), "HH:mm - dd / MMMM / yyyy" ) #',
            filterable: false
          }, {
            field: "pos",
            title: "POS",
            filterable: {
              extra: false,
              operators: {
                string: {
                  eq: "Is equal to"
                }
              },
              cell: {
                operator: "eq"
              }
            }
          }, {
            field: "orderId",
            title: "Order ID",
            width: "140px",
            filterable: {
              extra: false,
              operators: {
                string: {
                  eq: "Is equal to"
                }
              },
              cell: {
                operator: "eq"
              }
            }
          }, {
            field: "orderTotal",
            title: "Total",
            template: '&pound;#= parseFloat(orderTotal).toFixed(2) #',
            width: "100px",
            sortable: false,
            filterable: false
          }, {
            command: {
              text: "Show Items",
              click: $scope.showDetails
            },
            title: " ",
            width: "120px"
          }
        ],
        detailTemplate: kendo.template($("#detail-template").html()),
        detailInit: $scope.detailInit,
        dataBound: function(e) {
          var dataRow, filter, filteredMembers;
          dataRow = this.tbody.find("tr.k-master-row").first();
          dataRow.find('.k-grid-ShowItems').text('Hide Items');
          this.expandRow(this.tbody.find("tr.k-master-row").first());
          filter = this.dataSource.filter();
          this.thead.find(".k-header-column-menu.k-state-active").removeClass("k-state-active");
          if (filter) {
            filteredMembers = {};
            setFilteredMembers(filter, filteredMembers);
            this.thead.find("th[data-field]").each(function() {
              var cell, filtered;
              cell = $(this);
              filtered = filteredMembers[cell.data("field")];
              if (filtered) {
                cell.find(".k-header-column-menu").addClass("k-state-active");
              }
            });
          }
        }
      });
      orderHistoryGrid.data('kendoGrid').dataSource.read();
      $timeout(function() {
        return $("#POSList").kendoDropDownList({
          dataTextField: "name",
          dataValueField: "id",
          dataSource: $scope.POSList,
          select: $scope.updatePOS
        });
      }, 500);
      $("#dateRangeFrom, #dateRangeTo").on("change", function() {
        var condition, maxdate, mindate;
        mindate = $("#dateRangeFrom").data("kendoDateTimePicker").value();
        maxdate = $("#dateRangeTo").data("kendoDateTimePicker").value();
        condition = {
          logic: "and",
          filters: []
        };
        if (mindate !== null) {
          condition.filters.push({
            field: "from",
            operator: "ge",
            value: moment(kendo.parseDate(mindate)).format('YYYY-MM-DDTHH:mm')
          });
        }
        if (maxdate !== null) {
          condition.filters.push({
            field: "to",
            operator: "le",
            value: moment(kendo.parseDate(maxdate)).format('YYYY-MM-DDTHH:mm')
          });
        }
        orderHistoryGrid.data('kendoGrid').dataSource.filter(condition);
      });
      $('#POSList').on("change", function() {});
      return setFilteredMembers = function(filter, members) {
        var i;
        if (filter.filters) {
          i = 0;
          while (i < filter.filters.length) {
            setFilteredMembers(filter.filters[i], members);
            i++;
          }
        } else {
          members[filter.field] = true;
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=sales-trx-history-controller.js.map
