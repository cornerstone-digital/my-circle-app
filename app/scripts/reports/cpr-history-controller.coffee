angular.module('smartRegisterApp')
.controller 'CPRReportHistoryCtrl', ['$rootScope', '$scope', '$timeout', '$location', 'CPRList', 'ReportsService', 'POSService', 'MessagingService', 'ValidationService', ($rootScope, $scope, $timeout, $location, CPRList, ReportsService, POSService, MessagingService, ValidationService) ->
  $scope.CPRList = CPRList

  $scope.showReport = (e) ->
    e.preventDefault()
    dataItem = this.dataItem($(e.currentTarget).closest("tr"))
    window.location.href = "#/reports/venue/#{dataItem.venueId}/cpr/#{dataItem.id}"
    location.reload()

  $scope.create = ->
    $location.path "/reports/cpr"

  $(".cpr-list").kendoGrid({
    dataSource: {
      data: CPRList
      page: 1
      schema: {
        model: {
          fields: {
            dateCreated: { type: "date" }
            pos: { type: "string" }
            opening: { type: "date" }
            closing: { type: "date" }
          }
        }
      }
    }
    columns: [
      {
        field: "dateCreated"
        title: "Date"
        width: "250px"
        template: '#= kendo.toString(kendo.parseDate(closing), "dddd dd MMMM yyyy" ) #'
      }
      {
        field: "pos"
        title: "POS Name"
      }
      {
        field: "opening"
        title: "Opening"
        template: '#= kendo.toString(kendo.parseDate(opening), "MM/dd/yyyy HH:mm" ) #'
        width: "140px"
        filterable: {
          ui: "datetimepicker"
        }
      }
      {
        field: "closing"
        title: "Closing"
        template: '#= kendo.toString(kendo.parseDate(closing), "MM/dd/yyyy HH:mm" ) #'
        width: "140px"
        filterable: {
          ui: "datetimepicker"
        }
      }
      {
        command: {
          text: "View Details"
          click: $scope.showReport
        }
        title: " "
        width: "120px"
      }
    ]
    sortable: true
    filterable: true
    pageable: {
      buttonCount: 5
      pageSize: 10
    }
    groupable: true
    columnMenu: true
    dataBound: (e) ->
      filter = @dataSource.filter()
      @thead.find(".k-header-column-menu.k-state-active").removeClass "k-state-active"
      if filter
        filteredMembers = {}
        setFilteredMembers filter, filteredMembers
        @thead.find("th[data-field]").each ->
          cell = $(this)
          filtered = filteredMembers[cell.data("field")]
          cell.find(".k-header-column-menu").addClass "k-state-active"  if filtered
          return

      return
  })
]

setFilteredMembers = (filter, members) ->
  if filter.filters
    i = 0

    while i < filter.filters.length
      setFilteredMembers filter.filters[i], members
      i++
  else
    members[filter.field] = true
  return