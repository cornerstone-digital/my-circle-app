(function() {
  var setFilteredMembers;

  angular.module('smartRegisterApp').controller('CPRReportHistoryCtrl', [
    '$rootScope', '$scope', '$timeout', '$location', 'CPRList', 'ReportsService', 'POSService', 'MessagingService', 'ValidationService', function($rootScope, $scope, $timeout, $location, CPRList, ReportsService, POSService, MessagingService, ValidationService) {
      $scope.CPRList = CPRList;
      $scope.showReport = function(e) {
        var dataItem;
        e.preventDefault();
        dataItem = this.dataItem($(e.currentTarget).closest("tr"));
        window.location.href = "#/reports/venue/" + dataItem.venueId + "/cpr/" + dataItem.id;
        return location.reload();
      };
      $scope.create = function() {
        return $location.path("/reports/cpr");
      };
      return $(".cpr-list").kendoGrid({
        dataSource: {
          data: CPRList,
          page: 1,
          schema: {
            model: {
              fields: {
                dateCreated: {
                  type: "date"
                },
                pos: {
                  type: "string"
                },
                opening: {
                  type: "date"
                },
                closing: {
                  type: "date"
                }
              }
            }
          }
        },
        columns: [
          {
            field: "dateCreated",
            title: "Date",
            width: "250px",
            template: '#= kendo.toString(kendo.parseDate(closing), "dddd dd MMMM yyyy" ) #'
          }, {
            field: "pos",
            title: "POS Name"
          }, {
            field: "opening",
            title: "Opening",
            template: '#= kendo.toString(kendo.parseDate(opening), "MM/dd/yyyy HH:mm" ) #',
            width: "140px",
            filterable: {
              ui: "datetimepicker"
            }
          }, {
            field: "closing",
            title: "Closing",
            template: '#= kendo.toString(kendo.parseDate(closing), "MM/dd/yyyy HH:mm" ) #',
            width: "140px",
            filterable: {
              ui: "datetimepicker"
            }
          }, {
            command: {
              text: "View Details",
              click: $scope.showReport
            },
            title: " ",
            width: "120px"
          }
        ],
        sortable: true,
        filterable: true,
        pageable: {
          buttonCount: 5,
          pageSize: 10
        },
        groupable: true,
        columnMenu: true,
        dataBound: function(e) {
          var filter, filteredMembers;
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
    }
  ]);

  setFilteredMembers = function(filter, members) {
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

}).call(this);

//# sourceMappingURL=cpr-history-controller.js.map
